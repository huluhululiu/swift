//
//  huntHintImageViewController.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/25/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//
import UIKit
import FirebaseStorage
import FirebaseDatabase

class huntHintImageViewController: UIViewController {
    var ref: DatabaseReference!
    var treasureID: String?
    var imageLink: String?
    var level: Int = 0
    @IBOutlet weak var imageHint: UIImageView!
    @IBAction func nextPage(_ sender: UIButton) {
        performSegue(withIdentifier: "huntCode", sender: self)
    }
    override func viewDidLoad() {
        ref = Database.database().reference()
        treasureID = UserDefaults.standard.string(forKey: "Key")
       
        let myGroup = DispatchGroup()
        for _ in 0 ..< 1 {
            myGroup.enter()
            
            ref.child("Treasure").child(treasureID!).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                // Get user value
                
                if snapshot.hasChild("image"){
                    
                    self.ref.child("Treasure/\(self.treasureID!)").observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        self.imageLink = value?["image"] as? String
                        self.level = (value?["level"] as? Int)!
                        if self.level < 4
                        {
                            let five = 4
                            self.ref?.child("Treasure/\(self.treasureID!)/level").setValue(five)
                        }
                        let url = URL(string: self.imageLink!)
                        print("got image link")
                        do{
                            let imagedata = try Data(contentsOf: url!)
                            self.imageHint.image = UIImage(data: imagedata)
                        }catch{
                            print("error")
                        }
                        
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
