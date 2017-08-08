//
//  hunt4digitViewController.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/25/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class hunt4digitViewController: UIViewController {
    var ref: DatabaseReference!
    var treasureID: String?
    var code: String?
    var level: Int = 0
    @IBOutlet weak var dig4: UITextField!
    @IBOutlet weak var dig3: UITextField!
    @IBOutlet weak var dig2: UITextField!
    @IBOutlet weak var dig1: UITextField!
    @IBAction func nextPage(_ sender: UIButton) {
        var count = 0
        let d1 = (dig1?.text)!
        let d2 = (dig2?.text)!
        let d3 = (dig3?.text)!
        let d4 = (dig4?.text)!
        if d1 == ""{
            count += 1
        }
        if d2 == ""{
            count += 1
        }
        if d3 == ""{
            count += 1
        }
        if d4 == ""{
            count += 1
        }
        if count == 4 {
            self.failure()
        }
        else{
            
            
            let input = "\(d1)\(d2)\(d3)\(d4)"
            if code == input {
                performSegue(withIdentifier: "huntMessage", sender: self)}
            else{
                    self.view.shake()
            }
        }
    }
    func failure(){
        let myAlert = UIAlertController(title: "Failure to access last message", message:
            "Please type 4 digit code on the treasure you found", preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        ref = Database.database().reference()
        
        self.hideKeyboardWhenTappedAround()
        treasureID = UserDefaults.standard.string(forKey: "Key")
        
        super.viewDidLoad()
        let myGroup = DispatchGroup()
        for _ in 0 ..< 1 {
            myGroup.enter()
            self.ref.child("Treasure/\(self.treasureID!)").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                self.level = (value?["level"] as? Int)!
                if self.level < 5
                {
                    let five = 5
                    self.ref?.child("Treasure/\(self.treasureID!)/level").setValue(five)
                }
                let text = value?["4digit"] as? String
                self.code = text
                myGroup.leave()
            })}
        

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
