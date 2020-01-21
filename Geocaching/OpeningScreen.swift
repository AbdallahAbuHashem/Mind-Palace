//
//  OpeningScreen.swift
//  Geocaching
//
//  Created by Abdallah Abuhashem on 1/20/20.
//  Copyright © 2020 Abdallah AbuHashem. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class OpeningScreen: UIViewController {
    @IBOutlet weak var latText: UITextField!
    @IBOutlet weak var longText: UITextField!
    @IBOutlet weak var radiusText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let controller = segue.destination as! ViewController
            if let radius = Double(radiusText.text!) {
                controller.distanceThreshold = radius
            }
            if let lat = Double(latText.text!) {
                if let long = Double(longText.text!) {
                    controller.destination = CLLocationCoordinate2D(latitude: lat,longitude: long)
//                    controller.destination = CLLocationCoordinate2D(latitude: 37.4259767,longitude: -122.1634626)
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "showMap" {
                if latText.text == "" && longText.text == "" && radiusText.text == "" {
                    return false
                }
            }
        }
        return true
    }
}
