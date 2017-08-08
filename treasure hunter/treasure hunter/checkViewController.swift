//
//  checkViewController.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/28/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class checkViewController: UIViewController {
   @IBOutlet weak var levelMes: UILabel!
    var identities = [String]()
     var ref: DatabaseReference!
    var level: Int?
    var treasureID: String?
    @IBOutlet weak var idLabel: UILabel!
    override func viewDidLoad() {
        hintText.isHidden = true
        hintLabel.isHidden = true
        submitButton.isHidden = true
        super.viewDidLoad()
         identities = ["default","You have not sent out your code or your hunter hasn't started the trip yet.","Your hunter is looking for the poem right now","Your hunter found the poem and is looking for the treasure location.", "Your hunter found the treasure location but has not found the treasure yet.", "Your hunter found the treasure but has not viewed the last message yet.","Your hunter viewed the last message. The treasure hunting trip is over for this treasure."]
        self.treasureID = UserDefaults.standard.string(forKey: "Key")
        self.idLabel.text = treasureID
        ref = Database.database().reference()
        let myGroup = DispatchGroup()
        for _ in 0 ..< 1 {
            myGroup.enter()
            ref.child("Treasure/\(treasureID!)").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                print(snapshot)
                let value = snapshot.value as? NSDictionary
                
                self.level = (value?["level"] as? Int)!
                print(self.level!)
                self.levelMes.text = self.identities [self.level!]
                myGroup.leave()
            })}
        if self.level == 3 {
            hintText.isHidden = false
            hintLabel.isHidden = false
            submitButton.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var hintText: UITextField!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(_ sender: UIButton) {
        let text = hintText.text
        if text == ""{
            self.failure()
        }
        else{
            ref?.child("Treasure/\(treasureID!)/hint").setValue(hintText.text!)
            performSegue(withIdentifier: "back", sender: self)
        }
    }
    func failure(){
        let myAlert = UIAlertController(title: "Failure to set hint", message:
            "If you don't want to give a hint, it's OK.", preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(myAlert, animated: true, completion: nil)
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
