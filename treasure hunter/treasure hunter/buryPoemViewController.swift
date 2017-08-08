//
//  buryPoemViewController.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/23/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class buryPoemViewController: UIViewController {
    var ref: DatabaseReference!
    var treasureID: String?
    override func viewDidLoad() {
        treasureID = UserDefaults.standard.string(forKey: "Key")
        self.hideKeyboardWhenTappedAround()
        
        ref = Database.database().reference()
        let myGroup = DispatchGroup()
        for _ in 0 ..< 1 {
            myGroup.enter()
            
            ref.child("Treasure").child(treasureID!).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                // Get user value
                
                if snapshot.hasChild("poem"){
                    
                    self.ref.child("Treasure/\(self.treasureID!)").observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        let text = value?["poem"] as? String
                        self.poem.text = text
                        
                    })}
                myGroup.leave()
                
            })}

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func upload(_ sender: UIButton) {
        let text = poem?.text
        if text == ""{
            self.failure()
        }
        else{
            ref?.child("Treasure/\(treasureID!)/poem").setValue(poem.text!)
            performSegue(withIdentifier: "back", sender: self)
        }
    }
    func failure(){
        let myAlert = UIAlertController(title: "Failure to set poem", message:
            "Please leave some hint verse for your hunter", preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    @IBOutlet weak var poem: UITextView!
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
