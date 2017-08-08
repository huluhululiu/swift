//
//  activateViewController.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/23/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class activateViewController: UIViewController {
    var ref: DatabaseReference!
    var treasureID: String?
    var checkHints: Int = 0
    
    @IBOutlet weak var printID: UILabel!
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        ref = Database.database().reference()
        treasureID = UserDefaults.standard.string(forKey: "Key")
        printID.text = treasureID
        ref.child("Treasure").child(treasureID!).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            // Get user value
            if snapshot.hasChild("poemlati"){
                self.checkHints += 1
            }
            if snapshot.hasChild("poem"){
                self.checkHints += 1
            }
            if snapshot.hasChild("latitude"){
                self.checkHints += 1
            }
            if snapshot.hasChild("message"){
                self.checkHints += 1
            }
            if self.checkHints < 4{
                self.failure()
            }
            
            
            
            
        })

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func failure(){
        let myAlert = UIAlertController(title: "Failure to enter activate page", message:
            "Please finish other clues first.", preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: transfer))
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func transfer(alert: UIAlertAction){
        performSegue(withIdentifier: "back", sender: self)
    }
    @IBOutlet weak var username: UITextField!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func activate(_ sender: UIButton) {
        let name = username?.text
        if name == ""{
            let myAlert = UIAlertController(title: "Failure to activate", message:
                "Please enter your name in order to finish up.", preferredStyle: UIAlertControllerStyle.alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(myAlert, animated: true, completion: nil)
        }else{
        ref?.child("Treasure/\(treasureID!)/creator").setValue(username.text!)
            let start = 1
             ref?.child("Treasure/\(treasureID!)/level").setValue(start)
            performSegue(withIdentifier: "list", sender: self)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
