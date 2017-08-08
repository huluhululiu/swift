//
//  blistCell.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/26/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import Foundation
class Item: NSObject {
    var name: String?
    var treasureID: String?
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.treasureID = dictionary["treasureID"] as? String ?? ""
    }
}
