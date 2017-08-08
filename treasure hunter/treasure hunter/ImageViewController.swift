//
//  ImageViewController.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/19/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseCore
import MapKit

import CoreLocation
import FirebaseStorage
class ImageViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate{
    var ref: DatabaseReference!
    var treasureID: String?
    
    let currentLoc = CLLocationManager()
    let date = Date()
    let calendar = Calendar.current
    let hour = Calendar.current.component(.hour, from: Date())
    let minutes = Calendar.current.component(.minute, from: Date())
    @IBOutlet weak var imageHint: UIImageView!
    
    @IBAction func donedone(_ sender: UIButton) {
        let time = "\(NSDate())"
        let current = time.components(separatedBy: "+")
        ref?.child("Treasure/\(treasureID!)/latitude").setValue(a)
        ref?.child("Treasure/\(treasureID!)/longitude").setValue(b)
        ref?.child("Treasure/\(treasureID!)/time").setValue(current[0])
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child(treasureID! + ".jpg")
        if let imageData = UIImagePNGRepresentation(imageHint.image!){
            imageRef.putData(imageData, metadata: nil,completion:{ (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let imageURL = metadata?.downloadURL() {
                    print("upload successfully")
                    self.ref?.child("Treasure/\(self.treasureID!)/image").setValue(imageURL.absoluteString)
                }
                
            })}
    }
        
        
    @IBAction func upload(_ sender: UIButton) {
        let image = UIImagePickerController()
        
        image.delegate = self
        
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            //After it is complete
        }
        
    }
    var a:Double?
    var b:Double?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame:CGRect(x: 0, y: 0, width: 50, height: 50))
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[0]
        a = location.coordinate.latitude
        b = location.coordinate.longitude
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageHint.image = image
        }
        else
        {
            //Error message
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraTake(_ sender: Any) {
        let image = UIImagePickerController()
        
        image.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            image.sourceType = UIImagePickerControllerSourceType.camera
             self.present(image, animated: true)
        }else{
            print("camera not available")
        }
        
       
        
    }
    override func viewDidLoad() {
        ref = Database.database().reference()
         //progress.setProgress(0.0, animated: true)

        treasureID = UserDefaults.standard.string(forKey: "Key")
        currentLoc.delegate = self
        currentLoc.desiredAccuracy = kCLLocationAccuracyBest
        currentLoc.requestWhenInUseAuthorization()
        currentLoc.startUpdatingLocation()
        var imageLink:String?
        let myGroup = DispatchGroup()
        for _ in 0 ..< 1 {
            myGroup.enter()
            
            ref.child("Treasure").child(treasureID!).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                // Get user value
                
                if snapshot.hasChild("image"){
                    
                    self.ref.child("Treasure/\(self.treasureID!)").observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        imageLink = value?["image"] as? String
                        let url = URL(string: imageLink!)
                        print("got image link")
                        do{
                            let imagedata = try Data(contentsOf: url!)
                            self.imageHint.image = UIImage(data: imagedata)
                        }catch{
                            print("error")
                        }
//                        let url = NSURL(string: imageLink!)
//                        
//                        let config = URLSessionConfiguration.default
//                        let session = URLSession(session: config, downloadTask: self, didFinishDownloadingToURL: nil)
//                        
//                        // Don't specify a completion handler here or the delegate won't be called
//                        let task = session.downloadTaskWithURL(url)     
//                        task.resume()
                        
                    })}
                myGroup.leave()
                
            })}
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func failure(){
        let myAlert = UIAlertController(title: "Failure to enter image hint", message:
            "Please enter a four-digit code first", preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: transfer))
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func transfer(alert: UIAlertAction){
        performSegue(withIdentifier: "back", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func URLSession(session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        print("Downloaded \(totalBytesWritten) / \(totalBytesExpectedToWrite) bytes ")
//        
//        dispatch_get_main_queue().asynchronously() {
//            self.progress.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
//        }
//    }
//    
//    func URLSession(session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
//        // The location is only temporary. You need to read it or copy it to your container before
//        // exiting this function. UIImage(contentsOfFile: ) seems to load the image lazily. NSData
//        // does it right away.
//        if let data = NSData(contentsOf: location as URL), let image = UIImage(data: data as Data) {
//            dispatch_get_main_queue().asynchronously() {
//                self.imageHint.contentMode = .ScaleAspectFit
//                self.imageView.clipsToBounds = true
//                self.imageView.image = image
//            }
//        } else {
//            fatalError("Cannot load the image")
//        }
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
