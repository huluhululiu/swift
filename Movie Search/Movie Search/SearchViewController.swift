//
//  SearchViewController.swift
//  Movie Search
//
//  Created by Jiangnan Liu on 7/16/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate{
    
    var imdbID: String!
    var input: String!
    var thePoster: UIImage!
    var mArray: [Movie] = []
    var imageCache: [UIImage] = []
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame:CGRect(x: 0, y: 0, width: 50, height: 50))
    
    

    @IBOutlet weak var searchCollection: UICollectionView!
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mArray.removeAll()
        imageCache.removeAll()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped=true
        activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.gray
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchData(t: self.search.text!)
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.searchCollection.reloadData()
            }
        }
    }
    
    
    private func fetchData(t:String){
        let newString = t.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let json = getJSON(path: "https://api.themoviedb.org/3/search/movie?api_key=5088218d00a2d95c81d2adec92fe1632&query=\(newString)")
        for result in json["results"].arrayValue{
            var m = Movie()
            m.poster = "https://image.tmdb.org/t/p/w500"+result["poster_path"].stringValue
            
            m.title = result["title"].stringValue
            m.id = result["id"].stringValue
            m.year = result["release_date"].stringValue
            mArray.append(m)
            print(m.poster!)
            print(m.title!)
        }
        catchImages()
        
    }
    
    
    private func catchImages(){
        
        for item in mArray{
            do{
                var url = URL(string: item.poster!)
                if item.poster == "https://image.tmdb.org/t/p/w500"{
                    url = URL(string: "https://img3.doubanio.com/view/status/raw/public/9aca72d6b76cbd3.jpg")
                }
                let imagedata = try Data(contentsOf: url!)
                let image = UIImage(data: imagedata)
                imageCache.append(image!)
            }catch{
               // https://img3.doubanio.com/view/status/raw/public/9aca72d6b76cbd3.jpg
                print("error")
                
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //this line of code if from the tutorial https://www.youtube.com/watch?v=JbPc62YWhPQ
        let cell = searchCollection.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath) as! collectionViewCell
        
        cell.movieTitle.text = mArray[indexPath.row].title
        cell.posterImage.image = imageCache[indexPath.row]
        
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCache.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = searchCollection.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath) as! collectionViewCell
        
        imdbID = mArray[indexPath.row].id
        thePoster = imageCache[indexPath.row]
        
        
        
        self.performSegue(withIdentifier: "imdb", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "imdb" {
            let destination = segue.destination as! ViewController
            destination.ID = imdbID
            destination.image = thePoster
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle.title="Movie"
        search.delegate = self
        searchCollection.dataSource = self
        searchCollection.delegate = self
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
