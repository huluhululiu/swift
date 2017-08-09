//
//  ViewController.swift
//  lab2pet
//
//  Created by Jiangnan Liu on 6/28/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    
    
        @IBOutlet weak var happyNum: UILabel!
    @IBOutlet weak var foodNum: UILabel!
    
    @IBOutlet weak var happyDisplay: DisplayView!
    @IBOutlet weak var foodDisplay: DisplayView!
    

    var currentPet: Pet!
    var cat = Pet(f: 0, h: 0)
    var fish = Pet(f: 0, h: 0)
    var bird = Pet(f: 0, h: 0)
    var bunny = Pet(f: 0, h: 0)
    var dog = Pet(f: 0, h: 0)
    func update(){
        happyNum.text = String(currentPet.happy)
        foodNum.text = String(currentPet.food)
        let happyDisplayValue = Double(currentPet.happy)/10
        let foodDisplayValue = Double(currentPet.food)/10
        
        happyDisplay.animateValue(to: CGFloat(happyDisplayValue))
        foodDisplay.animateValue(to: CGFloat(foodDisplayValue))
    }
    @IBAction func dog(_ sender: UIButton) {
       petImage.image = UIImage(named: "dog@3x.png")
       topView.backgroundColor = UIColor.red
        currentPet = dog
        happyDisplay.color = UIColor.red
        foodDisplay.color = UIColor.red
        update()
        
    }
    @IBAction func cat(_ sender: UIButton) {
        petImage.image = UIImage(named: "cat@3x.png")
        topView.backgroundColor = UIColor.blue
        currentPet = cat
        happyDisplay.color = UIColor.blue
        foodDisplay.color = UIColor.blue
        update()
    }
    @IBAction func bird(_ sender: UIButton) {
        petImage.image = UIImage(named: "bird@3x.png")
        topView.backgroundColor = UIColor.yellow
        currentPet = bird
        happyDisplay.color = UIColor.yellow
        foodDisplay.color = UIColor.yellow
        update()
    }
    @IBAction func bunny(_ sender: UIButton) {
        petImage.image = UIImage(named: "bunny@3x.png")
        topView.backgroundColor = UIColor.purple
        currentPet = bunny
        happyDisplay.color = UIColor.purple
        foodDisplay.color = UIColor.purple
        update()
    }
    @IBAction func fish(_ sender: UIButton) {
        petImage.image = UIImage(named: "fish@3x.png")
        topView.backgroundColor = UIColor.orange
        currentPet = fish
        happyDisplay.color = UIColor.orange
        foodDisplay.color = UIColor.orange
        update()
    }
    @IBAction func play(_ sender: UIButton) {
        currentPet.play()
        update()
    }
    @IBAction func feed(_ sender: UIButton) {
        currentPet.feed()
        update()
    }
    @IBAction func reborn(_ sender: UIButton) {
        currentPet.reborn()
        update()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currentPet = cat
        petImage.image = UIImage(named: "cat@3x.png")
        topView.backgroundColor = UIColor.blue
        currentPet = cat
        happyDisplay.color = UIColor.blue
        foodDisplay.color = UIColor.blue
        update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

