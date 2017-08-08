//
//  bury4digitViewController.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/23/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class bury4digitViewController: UIViewController {
    var ref: DatabaseReference!
    var treasureID: String?
    var pwdTextField: UITextField?
    
    
    @IBOutlet weak var dig1: UITextField!
    @IBOutlet weak var dig2: UITextField!
    @IBOutlet weak var dig3: UITextField!
    @IBOutlet weak var dig4: UITextField!
    override func viewDidLoad() {
         treasureID = UserDefaults.standard.string(forKey: "Key")
        ref = Database.database().reference()
        self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func upload(_ sender: UIButton) {
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
            
           
            let code = "\(d1)\(d2)\(d3)\(d4)"
          
        self.ref?.child("Treasure/\(treasureID!)/4digit").setValue(code)
        performSegue(withIdentifier: "back", sender: self)
        }
    }
    func failure(){
        let myAlert = UIAlertController(title: "Failure to set treasure code", message:
            "Please type 4 digit code", preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(myAlert, animated: true, completion: nil)
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
