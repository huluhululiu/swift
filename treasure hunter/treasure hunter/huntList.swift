//
//  huntList.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/27/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

//
//  buryList.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/27/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//
import UIKit
import Foundation
import FirebaseDatabase
class huntList: UITableViewController {
    var names = [String]()
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    var user: String?
    
    @IBOutlet weak var myList: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        myList.delegate = self
        myList.dataSource = self
        ref = Database.database().reference()
        //let uid = UserDefaults.standard.string(forKey: "user")
        user = userItem.shared.array[0]
        handle = ref?.child("user").child(user!).child("hunt").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? String
            if let actualPost = post {
                
                let p = Post(aFirebaseKey: snapshot.key, aName: actualPost)
                postsArray.append(p)
                self.names.append(actualPost)
                self.myList.reloadData()
            
            }
            
            
        })
        
    }
    var path: DatabaseReference?
    var treasureID: String?
    @IBAction func newH(_ sender: UIBarButtonItem) {
//        path = ref?.child("Treasure").childByAutoId()
//        treasureID = (path?.key)!
        let alert = UIAlertController(title: "New Treasure", message:
            "what's your treasure name and ID: ", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: pwdTextField)
        alert.addTextField(configurationHandler: nameTextField)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        alert.addAction(cancel)
        let ok = UIAlertAction(title: "OK", style: .default, handler: self.okHandler)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletePlanetIndexPath = indexPath as NSIndexPath?
            let treaToDelete = names[indexPath.row]
            confirmDelete(planet: treaToDelete)
            
           
            
            tableView.reloadData()
        }
    }
    
    func confirmDelete(planet: String) {
        let alert = UIAlertController(title: "Delete Treasure", message: "Do you really want to delete \(planet)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeletePlanet)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeletePlanet)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
        deletePlanetIndexPath = nil
    }
    
    
    var deletePlanetIndexPath: NSIndexPath? = nil
    
    func handleDeletePlanet(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deletePlanetIndexPath {
            
            print(indexPath.row)
            //names.removeFirst()
            // Note that indexPath is wrapped in an array:  [indexPath]
            let nameOfTreasure = names[indexPath.row]
            let index = postsArray.index(where: {$0.tname == nameOfTreasure})
            let id = postsArray[index!].firebaseKey
            names.remove(at: indexPath.row)
            let deleteRef = self.ref?.child("user").child(self.user!).child("hunt").child(id!)
            deleteRef?.removeValue { error in
                
            }
            myList.reloadData()
            deletePlanetIndexPath = nil
        }
    }

    @IBAction func logout(_ sender: UIBarButtonItem) {
        userItem.shared.array.removeAll()
        performSegue(withIdentifier: "homehome", sender: self)
    }
    func okHandler(alert: UIAlertAction){
        let id = pwdTextField?.text
        let name = nameTextField?.text
        if id == "" || name == ""{
            view.shake()
        }
        else{
            let myGroup = DispatchGroup()
            for _ in 0 ..< 1 {
                myGroup.enter()
                
                ref.child("Treasure").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                    // Get user value
                    
                    if snapshot.hasChild(id!){
                        print("exist?\(snapshot.hasChild(id!))")
                        UserDefaults.standard.set(id, forKey: "Key")
                        self.ref.child("Treasure/\(id!)").observeSingleEvent(of: .value, with: { (snapshot) in
                            // Get user value
                            let value = snapshot.value as? NSDictionary
                            let level = value?["level"] as? Int
                            if level == 1{
                                 UserDefaults.standard.set(id, forKey: "Key")  //Integer
                                
                                 self.ref?.child("user").child(self.user!).child("hunt").child(id!).setValue(self.nameTextField?.text)
                                self.performSegue(withIdentifier: "newhunt", sender: self)
                            }
                            else{
                               self.view.shake()
                                //self.names.append((self.pwdTextField?.text)!)
                            }
                            
                        })}
                    else{
                        self.view.shake()
                    }
                    myGroup.leave()
                    
                })}
            
        }

       
    }
    func failure(){
        let myAlert = UIAlertController(title: "Not exist!", message:
            "The creator deleted the treasure:(", preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    var pwdTextField: UITextField?
    func pwdTextField(textField: UITextField){
        pwdTextField = textField
        pwdTextField?.placeholder = "Treasure ID"
        //pwdTextField?.isSecureTextEntry = true
    }
    var nameTextField: UITextField?
    func nameTextField(textField: UITextField){
        nameTextField = textField
        nameTextField?.placeholder = "Name your hunt trip"
        //pwdTextField?.isSecureTextEntry = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "huntCell")
        cell?.textLabel!.text = names[indexPath.row]
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = myList.dequeueReusableCell(withIdentifier: "buryCell", for: indexPath) as UITableViewCell
        let nameOfTreasure = names[indexPath.row]
        let index = postsArray.index(where: {$0.tname == nameOfTreasure})
        let id = postsArray[index!].firebaseKey
         UserDefaults.standard.set(id!, forKey: "Key")
        let myGroup = DispatchGroup()
        for _ in 0 ..< 1 {
            myGroup.enter()
            
            ref.child("Treasure").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                // Get user value
                
                if snapshot.hasChild(id!){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "huntPoemMap")
        //viewController.treasureID = IDnum
                    self.navigationController?.pushViewController(viewController!, animated: true)}
        else{
            let deleteRef = self.ref?.child("user").child(self.user!).child("hunt").child(id!)
            deleteRef?.removeValue { error in
                
            }
           self.names.remove(at: indexPath.row)
                    self.myList.reloadData()
            self.failure()
                }})}
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func huntList(segue:UIStoryboardSegue) { }

    
}

