//
//  ViewController.swift
//  paint
//  I watched a video and learnt some from it https://www.youtube.com/watch?v=-KOFYD4Tbvk
//  Created by Jiangnan Liu on 7/4/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var DrawView: UIImageView!
    
    var lineBegin = CGPoint.zero
    var brushWidth: CGFloat = 5.0
    var opacity: CGFloat = 1.0
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    private var countFirst: [Int] = []
    private var countLast: [Int] = []
    var contexts = [CGContext]()
    //
    private var prevPoints: [CGPoint] = []
    private var lastPoints: [CGPoint] = []
    private var brushMemory: [CGFloat]=[]
    private var colorMemory: [CGColor]=[]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touchPoint = (touches.first)!.location(in: self.view) as CGPoint
        lineBegin = touchPoint
        countFirst.append(prevPoints.count)
    }
    
    func drawing(fromPoint: CGPoint, toPoint: CGPoint) {
        
        let A = CGPoint(x: fromPoint.x, y: fromPoint.y)
        let B = CGPoint(x: toPoint.x, y: toPoint.y)
        
        UIGraphicsBeginImageContext(view.frame.size)
        DrawView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        let context = UIGraphicsGetCurrentContext()
        //the 4 lines above are from the tutorial video listed at the beginning
        prevPoints.append(A)
        lastPoints.append(B)
        brushMemory.append(brushWidth)
        let myColor=UIColor(red: red, green: green, blue: blue, alpha: opacity).cgColor
        colorMemory.append(myColor)
        
        context?.move(to: A)
        context?.addLine(to: B)
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: opacity).cgColor)
        
        context?.strokePath()
        DrawView.image = UIGraphicsGetImageFromCurrentImageContext()
        //this line is from the tutorial above
        
        UIGraphicsEndPDFContext()
        contexts.append(context!)
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        prevPoints.removeAll()
        lastPoints.removeAll()
        brushMemory.removeAll()
        colorMemory.removeAll()
        DrawView.image = UIImage()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let currentPnt = (touches.first)!.location(in: self.view) as CGPoint
        drawing(fromPoint: lineBegin, toPoint: currentPnt)
        
        lineBegin = currentPnt
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        drawing(fromPoint: lineBegin, toPoint: lineBegin)
        countLast.append(prevPoints.count)
    }
    
    @IBAction func changeWidth(_ sender: UISlider) {
        brushWidth = CGFloat((sender).value)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        let image = DrawView.image                                 //this line is from the tutorial above
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)      //this line is from the tutorial above
    }
    
    @IBAction func changeOpacity(_ sender: UISlider) {
        opacity = CGFloat((sender).value)
    }
    
    @IBAction func eraseButton(_ sender: UIButton) {
        red = 1.0
        green = 1.0
        blue = 1.0
        opacity = 1.0
        //brushWidth = 15
    }
    func restoreCanvas(startPoint: CGPoint, endPoint: CGPoint, brushWide: CGFloat, memoryColor: CGColor){
       // print("Rebrush:\(brushWide)")
        let A = CGPoint(x: startPoint.x, y: startPoint.y)
        let B = CGPoint(x: endPoint.x, y: endPoint.y)
        
        UIGraphicsBeginImageContext(view.frame.size)
        DrawView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        let context = UIGraphicsGetCurrentContext()
        //the 4 lines above are from the tutorial listed at the beginning
       
        
        context?.move(to: A)
        context?.addLine(to: B)
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWide)
        context?.setStrokeColor(memoryColor)
        
        context?.strokePath()
        DrawView.image = UIGraphicsGetImageFromCurrentImageContext()
        //this line is from the tutorial above
        
        UIGraphicsEndPDFContext()
        contexts.append(context!)
        
    }
    @IBAction func undoButton(_ sender: UIButton) {
        //contexts.remove(at: contexts)
        if !(prevPoints.isEmpty) && !(lastPoints.isEmpty) && !(brushMemory.isEmpty) && !(colorMemory.isEmpty) && !(countLast.isEmpty) && !(countFirst.isEmpty){
            DrawView.image = UIImage()
           
            
            prevPoints.removeSubrange(countFirst.last!..<countLast.last!)
            lastPoints.removeSubrange(countFirst.last!..<countLast.last!)
            brushMemory.removeSubrange(countFirst.last!..<countLast.last!)
            colorMemory.removeSubrange(countFirst.last!..<countLast.last!)
            countFirst.removeLast()
            countLast.removeLast()
            
            let iterations = prevPoints.count
            var i = 0
            while i < iterations{
            restoreCanvas(startPoint: prevPoints[i], endPoint: lastPoints[i], brushWide: brushMemory[i], memoryColor: colorMemory[i])
                i += 1
            }
            
        }
    }
    
    @IBAction func ChooseColors(_ sender: UIButton) {
        if sender.tag == 0 {                    //this is red
            red = 1.0
            green = 0
            blue = 0
        }
        else if sender.tag == 1 {               //this is blue
            red = 0
            green = 0
            blue = 1.0
        }
        else if sender.tag == 2 {               //this is yellow
            red = 1.0
            green = 1.0
            blue = 0
        }
        else if sender.tag == 3 {               //this is green
            red = 0
            green = 1.0
            blue = 0
        }
        else if sender.tag == 4 {               //this is purple
            red = 1.0
            green = 0
            blue = 1.0
        }
        else if sender.tag == 5 {               //this is black
            red = 0
            green = 0
            blue = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


