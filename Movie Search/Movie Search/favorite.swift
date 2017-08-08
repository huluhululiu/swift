//
//  favorite.swift
//  Movie Search
//
//  Created by Jiangnan Liu on 7/16/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit

class favorite:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var theData: [String] = []
    var deleteMovieIndexPath: NSIndexPath? = nil
    @IBOutlet weak var favList: UITableView!
    @IBOutlet weak var favorite: UINavigationItem!
    
    @IBAction func sort(_ sender: Any) {
        theData.sort()
        favList.reloadData()
    }
    private func setupTableView() {
        favList.dataSource = self
        favList.delegate = self
        favList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    //the func tableView, confirmDelete, handleDeletePlanet and cancelDeletePlanet are all from the online
    //tutorial: https://www.andrewcbancroft.com/2015/07/16/uitableview-swipe-to-delete-workflow-in-swift/
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteMovieIndexPath = indexPath as NSIndexPath?
            let movieToDelete = theData[indexPath.row]
            confirmDelete(planet: movieToDelete)
            
            theData.remove(at: indexPath.row)
            var favo = UserDefaults.standard.stringArray(forKey: "dis") ?? [String]()
            
            favo.remove(at: indexPath.row)
            tableView.reloadData()
            UserDefaults.standard.set(favo,forKey:"fav")
        }
    }
    
    func confirmDelete(planet: String) {
        let alert = UIAlertController(title: "Delete Movie", message: "Do you really want to delete \(planet)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeletePlanet)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeletePlanet)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    var deletePlanetIndexPath: NSIndexPath? = nil
    
    func handleDeletePlanet(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deletePlanetIndexPath {
            favList.beginUpdates()
            
            theData.remove(at: indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            favList.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            
            deletePlanetIndexPath = nil
            
            favList.endUpdates()
        }
    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
        deletePlanetIndexPath = nil
    }
    
    
    private func fetchData(){
        
        let array = UserDefaults.standard.stringArray(forKey: "fav")
        
        if ( array != nil){
            theData = array!
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = theData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theData.count
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        favList.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        favorite.title = "Favorites"
        setupTableView()
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
