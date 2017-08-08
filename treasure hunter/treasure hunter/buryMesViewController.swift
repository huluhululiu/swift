//
//  buryMesViewController.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/23/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class buryMesViewController: UIViewController {
    var ref: DatabaseReference!
    var treasureID: String?
    
    @IBOutlet weak var message: UITextView!
    @IBAction func upload(_ sender: UIButton) {
        let text = message?.text
        if text == ""{
            self.failure()
        }
        else{
        ref?.child("Treasure/\(treasureID!)/message").setValue(message.text!)
        performSegue(withIdentifier: "back", sender: self)
        }
    }
    func failure(){
        let myAlert = UIAlertController(title: "Failure to set last message", message:
            "Please leave some final message for your hunter", preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        treasureID = UserDefaults.standard.string(forKey: "Key")
        self.hideKeyboardWhenTappedAround()
        ref = Database.database().reference()
        let myGroup = DispatchGroup()
               for _ in 0 ..< 1 {
            myGroup.enter()
            
            ref.child("Treasure").child(treasureID!).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                // Get user value
                
                if snapshot.hasChild("message"){
                
                self.ref.child("Treasure/\(self.treasureID!)").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let text = value?["message"] as? String
                    self.message.text = text
                    
                })}
            myGroup.leave()
            
        })}

        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
