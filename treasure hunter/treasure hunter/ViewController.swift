//
//  ViewController.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/18/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    var ref: DatabaseReference!
    override func viewDidLoad() {
        ref = Database.database().reference()
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func infoBox(_ sender: UIButton) {
       
            performSegue(withIdentifier: "info", sender: self)
        
    }
   
    @IBOutlet weak var newTre: UIButton!
    var path: DatabaseReference?
    var treasureID: String?
    @IBAction func newBury(_ sender: UIButton) {
      
        path = ref?.child("Treasure").childByAutoId()
        treasureID = (path?.key)!
        let alert = UIAlertController(title: "New Treasure", message:
            "Set your email for ID: " + treasureID!, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: pwdTextField)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        alert.addAction(cancel)
        let ok = UIAlertAction(title: "OK", style: .default, handler: self.okHandler)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
        //

        //setValue()
        
        
    }
    var pwdTextField: UITextField?
    func pwdTextField(textField: UITextField){
        pwdTextField = textField
        pwdTextField?.placeholder = "email"
        //pwdTextField?.isSecureTextEntry = true
    }
    func failure(){
        let myAlert = UIAlertController(title: "Failure to enter the treasure", message:
            "Please type a valid ID", preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    var id: String?
    @IBOutlet weak var fileID: UITextField!
    @IBOutlet weak var submit: UIButton!
    @IBAction func newHunt(_ sender: UIButton) {
        let id = fileID?.text
        if id == ""{
            failure()
        }
        else{ 
            let myGroup = DispatchGroup()
            for _ in 0 ..< 1 {
                myGroup.enter()
                
                ref.child("Treasure").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                    // Get user value
                    
                    if snapshot.hasChild(id!){
                        UserDefaults.standard.set(id, forKey: "Key")
                        self.ref.child("Treasure/\(id!)").observeSingleEvent(of: .value, with: { (snapshot) in
                            // Get user value
                            let value = snapshot.value as? NSDictionary
                            let level = value?["level"] as? Int
                            if level == 0{
                                self.performSegue(withIdentifier: "newbury", sender: self.submit)
                            }
                            else{
                                self.performSegue(withIdentifier: "newhunt", sender: self.submit)
                            }
                            
                        })}
                    else{
                        self.view.shake()
                    }
                    myGroup.leave()
                    
                })}

        }
    }
    
    
    func okHandler(alert: UIAlertAction){
        path?.setValue(["password": pwdTextField?.text])
        let notStartYet = 0
        path?.setValue(["level": notStartYet])
        UserDefaults.standard.set(treasureID, forKey: "Key")  //Integer
        
       performSegue(withIdentifier: "newbury", sender: self)
    }
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "newbury"{
//        let destination = segue.destination as! TableViewController
//        destination.IDnum = id!
//        }
//        }
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss the keyboard when the view is tapped on
           }
    @IBAction func unwindToHome(segue:UIStoryboardSegue) { }


    }

