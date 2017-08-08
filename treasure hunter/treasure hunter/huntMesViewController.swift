//
//  huntMesViewController.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/26/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class huntMesViewController: UIViewController {
    var ref: DatabaseReference!
    var treasureID: String?
    
    @IBOutlet weak var message: UITextView!
    
    @IBAction func home(_ sender: UIButton) {
        performSegue(withIdentifier: "huntlist", sender: self)
    }
    override func viewDidLoad() {
        ref = Database.database().reference()
        treasureID = UserDefaults.standard.string(forKey: "Key")
        super.viewDidLoad()
        let five = 6
        ref?.child("Treasure/\(treasureID!)/level").setValue(five)
        let myGroup = DispatchGroup()
        for _ in 0 ..< 1 {
            myGroup.enter()
            self.ref.child("Treasure/\(self.treasureID!)").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let text = value?["message"] as? String
                self.message.text = text
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
