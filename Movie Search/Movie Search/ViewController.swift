//
//  ViewController.swift
//  Movie Search
//
//  Created by Jiangnan Liu on 7/13/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var ID: String!
    var image: UIImage!
    var theName: String!
    var theScore: String!
    var imdbId: String!
    var theYear: String!
    
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var imdb: UILabel!
    @IBOutlet weak var Favorite: UIButton!
    @IBOutlet weak var Dislike: UIButton!
    @IBOutlet weak var movieName: UINavigationItem!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBAction func shareMessage(_ sender: Any) {
        let myAlert = UIAlertController(title: "Message Copied", message:
            "I found \(theName!) (imdb: \(imdbId!))", preferredStyle: UIAlertControllerStyle.alert)
        UIPasteboard.general.string = "I found \(theName!) (imdb: \(imdbId!))"
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    @IBAction func addToFavorite(_ sender: Any) {
        if(UserDefaults.standard.stringArray(forKey: "fav") != nil){
            var array = UserDefaults.standard.stringArray(forKey: "fav") ?? [String]()
            
            if (!array.contains(theName)) {
                array.append(theName)
                UserDefaults.standard.set(array,forKey:"fav")
            }
            else {
                let favAlert = UIAlertController(title: "Oops!", message:
                    "It's already existed!", preferredStyle: UIAlertControllerStyle.alert)
                favAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                self.present(favAlert, animated: true, completion: nil)
            }
        }
        else{
            var array = [String]()
            array.append(theName)
            UserDefaults.standard.set(array,forKey:"fav")
        }
        
        //this chunk of code if from the tutorial https://www.youtube.com/watch?v=3vMTpBCFljY
        let myAlert = UIAlertController(title: "Success!", message:
            "Successfully Added to Favourite", preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    
    @IBAction func addToDislike(_ sender: Any) {
        if(UserDefaults.standard.stringArray(forKey: "dis") != nil){
            var array = UserDefaults.standard.stringArray(forKey: "dis") ?? [String]()
            if (!array.contains(theName)) {
                array.append(theName)
                UserDefaults.standard.set(array,forKey:"dis")
            }
            else {
                let favAlert = UIAlertController(title: "Oops!", message:
                    "It's already existed!", preferredStyle: UIAlertControllerStyle.alert)
                favAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                self.present(favAlert, animated: true, completion: nil)
            }
        }
        else{
            var array = [String]()
            array.append(theName)
            UserDefaults.standard.set(array,forKey:"dis")
        }
        
        //this chunk of code if from the tutorial https://www.youtube.com/watch?v=3vMTpBCFljY
        let myAlert = UIAlertController(title: "Success!", message:
            "Successfully Added to Dislike", preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    private func getJSON(path: String) -> JSON {
        guard let url = URL(string: path) else { return JSON.null }
        do {
            let data = try Data(contentsOf: url)
            return JSON(data: data)
        } catch {
            return JSON.null
        }
    }
    
    private func fetchData(){
        print(ID)
        let json = getJSON(path: "https://api.themoviedb.org/3/movie/\(ID!)?api_key=5088218d00a2d95c81d2adec92fe1632")
        
        theName = json["original_title"].stringValue
        theYear = json["release_date"].stringValue
        theScore = json["vote_average"].stringValue
        imdbId = json["imdb_id"].stringValue
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        movieName.title = theName
        self.moviePoster.image = self.image
        
        date.text = "Released: \(theYear!)"
        score.text = "Score: \(theScore!)/10"
        imdb.text = "IMDB: \(imdbId!)"
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

