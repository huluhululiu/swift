//
//  TreLocViewController.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/20/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit
import MapKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

class TreLocViewController: UIViewController {
    var ref: DatabaseReference!
    var treasureID: String?
    var latitude: Double?
    var longitude: Double?
    var span: MKCoordinateSpan?
    @IBOutlet weak var map: MKMapView!
    func failure(){
        let myAlert = UIAlertController(title: "Failure to enter treasure location", message:
            "Please upload a treasure hint first", preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: transfer))
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func transfer(alert: UIAlertAction){
        performSegue(withIdentifier: "back", sender: self)
    }
    
    func mark(loc1: Double, loc2: Double){
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(loc1, loc2)
        
        // Do any additional setup after loading the view.
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span!)
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = "Treasure Location!"
        map.addAnnotation(annotation)
    }
    override func viewDidLoad() {
        treasureID = UserDefaults.standard.string(forKey: "Key")

        ref = Database.database().reference()
        super.viewDidLoad()
        span = MKCoordinateSpanMake(0.1,0.1)
        let myGroup = DispatchGroup()
        
        for i in 0 ..< 1 {
            myGroup.enter()
      ref.child("Treasure").child(treasureID!).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            // Get user value
            print(snapshot)
            print("Finished request \(i)")
            if !snapshot.hasChild("longitude"){
                self.failure()
            }
            else{
                self.ref.child("Treasure/\(self.treasureID!)").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
          let value = snapshot.value as? NSDictionary
            let latitude = value?["latitude"] as? Double
            let longitude = value?["longitude"] as? Double
            self.mark(loc1: latitude!,loc2: longitude!)
            })}
            
            
        myGroup.leave()})
        
       
        }
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
