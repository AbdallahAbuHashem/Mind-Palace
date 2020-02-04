//
//  StartWalk.swift
//  Geocaching
//
//  Created by Abdallah Abuhashem on 2/3/20.
//  Copyright © 2020 Abdallah AbuHashem. All rights reserved.
//

import UIKit
import GoogleMaps
import AVFoundation

class StartWalk: UIViewController, CLLocationManagerDelegate {

    var mapView:GMSMapView?
    var locationManager = CLLocationManager()
    var APIKey = "AIzaSyDWKxNekjyN_SsRSwauPUA1_KF98SNqYNM"
    var distanceThreshold = 40.0
    var polyline = GMSPolyline(path: nil)
    var pathFetched = false
    var nextMarkerIndex = 0
    var nextDestination = CLLocationCoordinate2D(latitude: items[0]["lat"] as! CLLocationDegrees,longitude: items[0]["long"] as! CLLocationDegrees)
    var disableColor = UIColor(red: 0.514, green: 0.514, blue: 0.514, alpha: 1)
    
    @IBOutlet weak var showImage: UIButton!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBAction func dismissModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func applyShadows() {
        mapViewContainer.layer.applySketchShadow()
        showImage.layer.applySketchShadow()
    }
    
    func disableButton() {
        showImage.isEnabled = false
        showImage.backgroundColor = disableColor
    }
    
    func enableButton() {
        showImage.isEnabled = true
        showImage.backgroundColor = UIColor.systemBlue
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
        self.locationManager.distanceFilter = 10
        self.locationManager.startUpdatingLocation()
    }
    
    func addMarkers() {
        for (_, item) in items.enumerated() {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: item["lat"] as! CLLocationDegrees, longitude: item["long"] as! CLLocationDegrees)
            marker.title = item["labelText"] as? String
            marker.map = mapView
        }
    }
    
    func speechTest(string: String) {
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyShadows()
        disableButton()
        initMap()
        addMarkers()
        speechTest(string: "Hello world")
    }
    
    func updateNextDestination() {
        nextMarkerIndex += 1
        nextDestination = CLLocationCoordinate2D(latitude: items[nextMarkerIndex]["lat"] as! CLLocationDegrees,longitude: items[nextMarkerIndex]["long"] as! CLLocationDegrees)
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: (self.mapView?.camera.zoom)!)
        
        self.mapView?.animate(to: camera)
        
        let origin = location?.coordinate
        self.checkDistance(distance: self.distanceInMeterBetweenPoints(lat1: (origin?.latitude)!, lon1: (origin?.longitude)!, lat2: self.nextDestination.latitude, lon2: self.nextDestination.longitude))
//        self.locationManager.stopUpdatingLocation()
        
    }
    
    func checkDistance(distance: double_t) {
        print(distance)
        if (distance > distanceThreshold && showImage.backgroundColor != UIColor.systemBlue) {
//            disableButton()
        } else if (distance < distanceThreshold && showImage.backgroundColor == disableColor) {
//            enableButton()
            speechTest(string: items[nextMarkerIndex]["labelText"] as! String)
            updateNextDestination()
        }
    }
    
    func degreesToRadians(degrees: double_t) -> double_t {
        return (degrees * Double.pi / 180.0);
    }
    
    func distanceInMeterBetweenPoints(lat1: double_t, lon1: double_t, lat2: double_t, lon2: double_t) -> double_t {
        let earthRadiusKm = 6371.0;
        
        let dLat = degreesToRadians(degrees: lat2-lat1);
        let dLon = degreesToRadians(degrees: lon2-lon1);
        
        let lat1Rad = degreesToRadians(degrees: lat1);
        let lat2Rad = degreesToRadians(degrees: lat2);
        
        let a = sin(dLat/2) * sin(dLat/2) +
        sin(dLon/2) * sin(dLon/2) * cos(lat1Rad) * cos(lat2Rad);
        let c = 2 * atan2(sqrt(a), sqrt(1-a));
        return earthRadiusKm * 1000 * c;
    }
}