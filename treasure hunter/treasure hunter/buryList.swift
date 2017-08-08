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
class buryList: UITableViewController {
    var names = [String]()
    var ref: DatabaseReference!
    
    @IBOutlet weak var myList: UITableView!
    
    var handle: DatabaseHandle!
    var user: String?
    
    @IBOutlet weak var logout: UIBarButtonItem!
    
    @IBAction func home(_ sender: UIBarButtonItem) {
        userItem.shared.array.removeAll()
        print("is delete succ??")
        print(userItem.shared.array)
        performSegue(withIdentifier: "homehome", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myList.delegate = self
        myList.dataSource = self
        ref = Database.database().reference()
        user = userItem.shared.array[0]
        handle = ref?.child("user").child(user!).child("bury").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? String
            if let actualPost = post {
                
                let p = Post(aFirebaseKey: snapshot.key, aName: actualPost)
                
                postsArray.append(p)
                //print(p)
                self.names.append(actualPost)
                self.myList.reloadData()
            }
            
            
        })
        
    }
    var path: DatabaseReference?
    var treasureID: String?
    @IBAction func newB(_ sender: UIBarButtonItem) {
        path = ref?.child("Treasure").childByAutoId()
        treasureID = (path?.key)!
        let alert = UIAlertController(title: "New Treasure", message:
            "Set your treasure name for ID: " + treasureID!, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: pwdTextField)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        alert.addAction(cancel)
        let ok = UIAlertAction(title: "OK", style: .default, handler: self.okHandler)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    func okHandler(alert: UIAlertAction){
        path?.setValue(pwdTextField?.text)
        ref?.child("user").child(user!).child("bury").child(treasureID!).setValue(pwdTextField?.text)
        let notStartYet = 0
        path?.setValue(["level": notStartYet])
        UserDefaults.standard.set(treasureID, forKey: "Key")  //Integer
        
        performSegue(withIdentifier: "newbury", sender: self)
    }
    var pwdTextField: UITextField?
    func pwdTextField(textField: UITextField){
        pwdTextField = textField
        pwdTextField?.placeholder = "Name your treasure"
        //pwdTextField?.isSecureTextEntry = true
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
            let deleteRef = self.ref?.child("user").child(self.user!).child("bury").child(id!)
            deleteRef?.removeValue { error in
                
            }
            let deleteRefTrea = self.ref?.child("Treasure").child(id!)
            deleteRefTrea?.removeValue { error in
                
            }
            myList.reloadData()
            deletePlanetIndexPath = nil
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buryCell")
        cell?.textLabel!.text = names[indexPath.row]
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
          let cell = myList.dequeueReusableCell(withIdentifier: "buryCell", for: indexPath) as UITableViewCell
        let nameOfTreasure = names[indexPath.row]
        let index = postsArray.index(where: {$0.tname == nameOfTreasure})
        let id = postsArray[index!].firebaseKey
        self.ref.child("Treasure/\(id!)").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let level = value?["level"] as? Int
            if level == 0{
                 UserDefaults.standard.set(id!, forKey: "Key")
                self.performSegue(withIdentifier: "newbury", sender: cell)
            }
            else{
                UserDefaults.standard.set(id!, forKey: "Key")
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "progressCheck")
                //viewController.treasureID = IDnum
                self.navigationController?.pushViewController(viewController!, animated: true)
            }
            
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    @IBAction func buryListView(segue:UIStoryboardSegue) { }
    
}
