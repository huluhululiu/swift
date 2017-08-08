//
//  FirstViewController.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/27/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class FirstViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    var isSignIn:Bool = true
    @IBOutlet weak var signregiLable: UISegmentedControl!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var password: UITextField!
    var ref: DatabaseReference!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        errorMessage.isHidden = true
        userItem.shared.array.removeAll()
        print(userItem.shared.array)
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        super.viewDidLoad()
         ref = Database.database().reference()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    @IBAction func infoBox(_ sender: UIButton) {
        performSegue(withIdentifier: "info", sender: self)
    }
    
    @IBAction func labelPrint(_ sender: UISegmentedControl) {
        
        // Flip the boolean
        isSignIn = !isSignIn
        
        // Check the bool and set the button and labels
        if isSignIn {
            signInLabel.text = "Sign In"
            
        }
        else {
            signInLabel.text = "Register"
            
        }

    }
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBAction func submitForm(_ sender: UIButton) {
        // TODO: Do some form validation on the email and password
        
        if let email = email.text, let pass = password.text {
            
            // Check if it's sign in or register
            if isSignIn {
                // Sign in the user with Firebase
                Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                    
                    // Check that user isn't nil
                    if user != nil {
                        let uid = user?.uid
                        userItem.shared.array.append(uid!)
                        print(userItem.shared.array)
                        // User is found, go to home screen
                         self.performSegue(withIdentifier: "intoLists", sender: self)
                        
                    }
                    else {print("error1")
                        self.view.shake()
                        self.errorMessage.isHidden = false
                        self.errorMessage.text = error?.localizedDescription
                        // Error: check error and show message
                    }
                    
                })
                
            }
            else {
                // Register the user with Firebase
                
                Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                    
                    // Check that user isn't nil
                    if user != nil {
                        let uid = user?.uid
                        print("accomplished register")
                       self.ref?.child("user").child(uid!)
                        self.ref?.child("user").child(uid!).child("bury")
                        self.ref?.child("user").child(uid!).child("hunt")
                        // User is found, go to home screen
//                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "tryThis")
//                        //viewController.treasureID = IDnum
//                        self.navigationController?.pushViewController(viewController!, animated: true)
                        userItem.shared.array.append(uid!)
                        self.performSegue(withIdentifier: "intoLists", sender: self)
                        
                    }
                    else {
                        print(error!)
                        print("error2")
                        self.view.shake()
                        self.errorMessage.isHidden = false
                        self.errorMessage.text = error?.localizedDescription
                        // Error: check error and show message
                    }
                })
                
            }
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        ref = Database.database().reference()
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss the keyboard when the view is tapped on
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    @IBAction func homeScreen(segue:UIStoryboardSegue) { }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
