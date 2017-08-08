//
//  mapSet.swift
//  treasure hunter
//
//  Created by Jiangnan Liu on 7/27/17.
//  Copyright © 2017 Jiangnan Liu. All rights reserved.
//

import Foundation
import MapKit

extension PoemLocViewController: MKMapViewDelegate {
func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    print ("check")
    if !(annotation is MKUserLocation) {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
        
        let rightButton = UIButton(type: .contactAdd)
        rightButton.tag = annotation.hash
        
        pinView.animatesDrop = true
        pinView.canShowCallout = true
        pinView.rightCalloutAccessoryView = rightButton
        
        return pinView
    }
    else {
        return nil
    }
}
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            print("button tapped")
            ref?.child("Treasure/\(treasureID!)/poemlati").setValue(a)
            ref?.child("Treasure/\(treasureID!)/poemlong").setValue(b)
            //performSegue(withIdentifier: "back", sender: self)
        }
    }
}
