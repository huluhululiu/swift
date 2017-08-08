//
//  tbvc.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/19/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
class TableViewController: UITableViewController {
    var names = [String]()
    var identities = [String]()
    var IDnum: String?
    
    override func viewDidLoad() {
        
        names = ["Treasure Poem","Image Hint","Last Message", "Passwords", "Treasure Location", "Poem Location","Activate"]
        identities = ["a","b","c", "d", "e", "f","g"]
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    func initCustom(IDnum: String){
        self.IDnum = IDnum
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel!.text = names[indexPath.row]
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcName = identities[indexPath.row]
        let viewController = storyboard?.instantiateViewController(withIdentifier: vcName)
        //viewController.treasureID = IDnum
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }

}
