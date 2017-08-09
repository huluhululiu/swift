//
//  petspets.swift
//  lab2pet
//
//  Created by Jiangnan Liu on 6/28/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import Foundation
class Pet{
    var happy: Int
    var food: Int
    func play(){
        if food <= 0 {
            food = 0
        }
        else{

        happy = happy + 1
        food = food - 1
        if happy > 10 {
            happy = 10
          }
        }
        }
    func feed(){
        food = food + 1
        
        if food > 10 {
            food = 10
        }
    }
    func reborn(){
        food = 5
        happy = 5
    }
    init(f:Int, h:Int) {
        self.happy=h;
        self.food=f;
    }
    
}
