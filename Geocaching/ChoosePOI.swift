//
//  ChoosePOI.swift
//  Geocaching
//
//  Created by Abdallah Abuhashem on 5/13/20.
//  Copyright © 2020 Abdallah AbuHashem. All rights reserved.
//

import UIKit
import GoogleMaps

protocol ChangeNameDelegate {
    func changeName(name: String, loc: CLLocationCoordinate2D, index: Int)
}
class ChoosePOI: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate {
    
    var delegate: ChangeNameDelegate?

    @IBOutlet weak var mapViewContainer: UIView!
    var mapView:GMSMapView?
    var locationManager = CLLocationManager()
    var receivedIndex:Int = 0
    var marker = GMSMarker()
    var coordinate = CLLocationCoordinate2D()
    var name = ""
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var textBottomLayout: NSLayoutConstraint!
    
    @IBAction func dsimissModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func applyShadows() {
        mapViewContainer.layer.applySketchShadow()
    }
    
    func initMap() {
        //Init map
        mapView = GMSMapView.map(withFrame: mapViewContainer.bounds, camera: GMSCameraPosition.camera(withLatitude: 51.050657, longitude: 10.649514, zoom: 14))
        //Add map to view
        mapViewContainer.addSubview(mapView!)
        
        let mask = UIView(frame: mapViewContainer.bounds)
        mask.backgroundColor = .blue
        mask.layer.cornerRadius = 27
        mapView?.mask = mask
        
        mapView?.isMyLocationEnabled = true //Enable user location

        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.distanceFilter = 2
        self.locationManager.startUpdatingLocation()
    }
    
    func addMarker() {
        mapView?.clear()
        marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: items[receivedIndex]["lat"] as! CLLocationDegrees, longitude: items[receivedIndex]["long"] as! CLLocationDegrees)
        marker.title = items[receivedIndex]["teamName"] as? String
        marker.map = mapView
        coordinate = marker.position
    }
    
    @IBAction func updateLocations(_ sender: Any) {
        name = self.locationName.text ?? ""
        delegate?.changeName(name: name, loc: coordinate, index: receivedIndex)
//        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationName.delegate = self
        self.locationName.text = items[receivedIndex]["labelText"] as? String
        NotificationCenter.default.addObserver(self,
        selector: #selector(self.keyboardNotification(notification:)),
        name: UIResponder.keyboardWillChangeFrameNotification,
        object: nil)
        
        applyShadows()
        initMap()
        addMarker()
        mapView!.delegate = self
        // Do any additional setup after loading the view.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.textBottomLayout?.constant = 34
            } else {
                self.textBottomLayout?.constant = endFrame?.size.height ?? 34
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    
    //Location Manager delegates
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let location = locations.last
            
            let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: (self.mapView?.camera.zoom)!)
            
            self.mapView?.animate(to: camera)
            self.locationManager.stopUpdatingLocation()
            
        }
    

    

}

extension ChoosePOI: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        marker = GMSMarker()
        marker.position = coordinate
        marker.title = items[receivedIndex]["teamName"] as? String
        marker.map = mapView
        self.coordinate = coordinate
    }
}
