//
//  treasure.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/28/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import Foundation
struct Post {
    var firebaseKey : String?
    var tname: String?
    
    init(aFirebaseKey: String, aName: String) {
        self.firebaseKey = aFirebaseKey
        self.tname = aName
    }
}

var postsArray = [Post]()
