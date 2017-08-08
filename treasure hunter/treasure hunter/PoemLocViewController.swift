//
//  PoemLocViewController.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/22/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class PoemLocViewController: UIViewController,UISearchBarDelegate {
    
    
    @IBOutlet weak var myMapView: MKMapView!
    
    var a:Double?
    var b:Double?
    var ref: DatabaseReference!
    var treasureID: String?
    var span: MKCoordinateSpan?
    @IBOutlet weak var search: UISearchBar!
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
//        //Hide search bar
//        searchBar.resignFirstResponder()
//        dismiss(animated: true, completion: nil)
        
        //Create the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
           activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            //print(response)
            if response == nil
            {
                print("ERROR")
            }
            else
            {
                //Remove annotations
                    self.myMapView.removeAnnotations(self.myMapView.annotations)
                
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                print(latitude!)
                self.a = latitude
                self.b = longitude
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = "Poem"
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.myMapView.setRegion(region, animated: true)
            }
            
        }
    }

    
    override func viewDidLoad() {
        ref = Database.database().reference()
        treasureID = UserDefaults.standard.string(forKey: "Key")
        super.viewDidLoad()
        myMapView.delegate = self
        search.delegate = self
        let myGroup = DispatchGroup()
         span = MKCoordinateSpanMake(0.1,0.1)
          self.hideKeyboardWhenTappedAround()
        for _ in 0 ..< 1 {
            myGroup.enter()
         ref.child("Treasure").child(treasureID!).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            // Get user value
            
            if snapshot.hasChild("poemlong"){
                print("gotit")
                self.ref.child("Treasure/\(self.treasureID!)").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let latitude = value?["poemlati"] as? Double
                    let longitude = value?["poemlong"] as? Double
                    self.mark(loc1: latitude!,loc2: longitude!)
                })}
           
            
            
            myGroup.leave()
         }
            )}
        let uilgr = UITapGestureRecognizer(target: self, action: #selector(PoemLocViewController.pinOnMap(_:)))
       
        myMapView.addGestureRecognizer(uilgr)

        
        //IOS 9
                // Do any additional setup after loading the view.
        }
    func mark(loc1: Double, loc2: Double){
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(loc1, loc2)
        
        // Do any additional setup after loading the view.
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span!)
        myMapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = "Poem"
        myMapView.addAnnotation(annotation)
        }
    
    func pinOnMap(_ sender: UITapGestureRecognizer) {
        print("read press")
        
        let location = sender.location(in: self.myMapView)
        let locCoordinates = self.myMapView.convert(location, toCoordinateFrom: self.myMapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locCoordinates
        annotation.title = "Poem"
        self.myMapView.removeAnnotations(myMapView.annotations)
        self.myMapView.addAnnotation(annotation)
        self.a = locCoordinates.latitude
        self.b = locCoordinates.longitude

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
