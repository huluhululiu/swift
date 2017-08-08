//
//  huntPoemViewController.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/25/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreLocation
class huntPoemViewController: UIViewController,UINavigationControllerDelegate,CLLocationManagerDelegate {
    var ref: DatabaseReference!
    var treasureID: String?
    var treLati: Double?
    var treLong: Double?
    var a: Double?
    var b: Double?
    var level:Int = 0
    var hint: String?
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var name: UILabel!
    let currentLoc = CLLocationManager()
    @IBOutlet weak var poem: UITextView!
    
    @IBOutlet weak var extraHint: UIButton!
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[0]
        a = location.coordinate.latitude
        b = location.coordinate.longitude
       print("knockknock")
        print(String(describing: a))
        print(String(describing: b))
    }        
    var distanInMeters: Int = 0
    @IBAction func nextPage(_ sender: UIButton) {
        print(String(describing: a))
        print(String(describing: b))
        print(String(describing: treLati))
        print(String(describing: treLong))
        let coordinateTre = CLLocation(latitude: a!, longitude: b!)
        let coordinateYou = CLLocation(latitude: treLati!, longitude: treLong!)
        self.distanInMeters = Int(coordinateTre.distance(from: coordinateYou))
        if distanInMeters < 20 || level > 3  {
            performSegue(withIdentifier: "huntHint", sender: self)}
        else {
            failure()
        }
    }
    func failure(){
        let myAlert = UIAlertController(title: "Not Yet", message:
            "Your distance to the treasure is: " + String(distanInMeters) + " meters", preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        extraHint.isHidden = true
        treasureID = UserDefaults.standard.string(forKey: "Key")
        ref = Database.database().reference()
        super.viewDidLoad()
        currentLoc.delegate = self
        currentLoc.desiredAccuracy = kCLLocationAccuracyBest
        currentLoc.requestWhenInUseAuthorization()
        currentLoc.startUpdatingLocation()
        let myGroup = DispatchGroup()
        for _ in 0 ..< 1 {
            myGroup.enter()
                    self.ref.child("Treasure/\(self.treasureID!)").observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        let text = value?["poem"] as? String
                        self.treLati = value?["latitude"] as? Double
                        self.treLong = value?["longitude"] as? Double
                        self.poem.text = text
                        self.level = (value?["level"] as? Int)!
                        if self.level < 3
                        {
                            let five = 3
                            self.ref?.child("Treasure/\(self.treasureID!)/level").setValue(five)
                        }

                        let creator = value?["creator"] as? String
                        self.time.text = value?["time"] as? String
                        self.name.text = "Buried by " + creator!
                        myGroup.leave()
                    })}
        let anotherGroup = DispatchGroup()
        for _ in 0 ..< 1 {
            anotherGroup.enter()
            
            ref.child("Treasure").child(treasureID!).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                // Get user value
                
                if snapshot.hasChild("hint"){
                    
                    self.ref.child("Treasure/\(self.treasureID!)").observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        let text = value?["hint"] as? String
                        self.hint = text
                        self.extraHint.isHidden = false
                    })}
                anotherGroup.leave()
                
            })}

     
        
        

        // Do any additional setup after loading the view.
    }

    @IBAction func extraClue(_ sender: UIButton) {
        let myAlert = UIAlertController(title: "Extra hint!", message:
           hint, preferredStyle: UIAlertControllerStyle.alert)
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
