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
import CoreLocation
class huntPoemMapViewController: UIViewController,UINavigationControllerDelegate,CLLocationManagerDelegate {
    var ref: DatabaseReference!
    var treasureID: String?
    var span: MKCoordinateSpan?
    let currentLoc = CLLocationManager()
    @IBOutlet weak var map: MKMapView!
    var a:Double?
    var b:Double?
    var poemA:Double?
    var poemB:Double?
    var level:Int = 0
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[0]
        a = location.coordinate.latitude
        b = location.coordinate.longitude
    }
    override func viewDidLoad() {
        treasureID = UserDefaults.standard.string(forKey: "Key")
        
        ref = Database.database().reference()
        super.viewDidLoad()
        span = MKCoordinateSpanMake(0.1,0.1)
        currentLoc.delegate = self
        currentLoc.desiredAccuracy = kCLLocationAccuracyBest
        currentLoc.requestWhenInUseAuthorization()
        currentLoc.startUpdatingLocation()
        let myGroup = DispatchGroup()
        for _ in 0 ..< 1 {
            myGroup.enter()
        ref.child("Treasure/\(treasureID!)").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot)
            let value = snapshot.value as? NSDictionary
            let latitude = value?["poemlati"] as? Double
            let longitude = value?["poemlong"] as? Double
            self.poemA = latitude
            self.poemB = longitude
            self.level = (value?["level"] as? Int)!
            if self.level < 2
        {
            let five = 2
            self.ref?.child("Treasure/\(self.treasureID!)/level").setValue(five)
        }
            print(self.level)
            self.mark(loc1: latitude!,loc2: longitude!)
            myGroup.leave()
        })}
        
        
    }
    
    func mark(loc1: Double, loc2: Double){
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(loc1, loc2)
        
        // Do any additional setup after loading the view.
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span!)
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = "Poem Location!"
        map.addAnnotation(annotation)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var distanInMeters: Int = 0
    @IBAction func nextPage(_ sender: UIButton) {
        print(String(describing: a))
        print(String(describing: b))
        print(String(describing: poemA))
        print(String(describing: poemB))
       
        let coordinateTre = CLLocation(latitude: a!, longitude: b!)
        let coordinateYou = CLLocation(latitude: poemA!, longitude: poemB!)
        self.distanInMeters = Int(coordinateTre.distance(from: coordinateYou))
        if (distanInMeters < 20) || level > 2  {
            performSegue(withIdentifier: "huntPoem", sender: self)}
        else {
            failure()
        }
    }
    func failure(){
        if distanInMeters < 100{
            self.map.showsUserLocation = true
        }
        let myAlert = UIAlertController(title: "Not Yet", message:
            "Your distance to the poem is: " + String(distanInMeters) + " meters", preferredStyle: UIAlertControllerStyle.alert)
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
