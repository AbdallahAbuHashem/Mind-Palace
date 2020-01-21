//
//  ViewController.swift
//  Geocaching
//
//  Created by Abdallah Abuhashem on 1/13/20.
//  Copyright © 2020 Abdallah AbuHashem. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate {

    var mapView:GMSMapView?
    var locationManager = CLLocationManager()
    var APIKey = "AIzaSyDWKxNekjyN_SsRSwauPUA1_KF98SNqYNM"
    var distanceThreshold = 50.0
    var polyline = GMSPolyline(path: nil)
    var pathFetched = false
    var destination = CLLocationCoordinate2D(latitude: 0,longitude: 0)
    //var destination = CLLocationCoordinate2D(latitude: 37.4259767,longitude: -122.1634626)
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init map
        mapView = GMSMapView.map(withFrame: mapViewContainer.bounds, camera: GMSCameraPosition.camera(withLatitude: 51.050657, longitude: 10.649514, zoom: 14))
        //Add map to view
        mapViewContainer.addSubview(mapView!)
        mapView?.isMyLocationEnabled = true //Enable user location
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
    }

    @IBAction func onClick(_ sender: Any) {
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: (self.mapView?.camera.zoom)!)
        
        self.mapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        let origin = location?.coordinate
        if (!pathFetched) {
            pathFetched = true
            self.fetchRoute(from: origin!, to: self.destination)
        }
        
        self.checkDistance(distance: self.distanceInMeterBetweenPoints(lat1: (origin?.latitude)!, lon1: (origin?.longitude)!, lat2: self.destination.latitude, lon2: self.destination.longitude))
//        self.locationManager.stopUpdatingLocation()
        
    }
    
    func checkDistance(distance: double_t) {
        if (distance > distanceThreshold && nextButton.backgroundColor != UIColor.black) {
            nextButton.isEnabled = false
            nextButton.backgroundColor = UIColor.black
            nextButton.setTitle("Move to destination", for: .normal)
        } else if (distance < distanceThreshold && nextButton.backgroundColor == UIColor.black) {
            nextButton.isEnabled = true
            nextButton.backgroundColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
            nextButton.setTitle("Next", for: .normal)
        }
    }
    
    //Get route using Directions API
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let session = URLSession.shared
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&mode=walking&key=\(self.APIKey)")!
        
        //Construct request and callback
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any], let jsonResponse = jsonResult else {
                print("error in JSONSerialization")
                return
            }
            
            guard let routes = jsonResponse["routes"] as? [Any] else {
                return
            }
            
            guard let route = routes[0] as? [String: Any] else {
                return
            }
            
            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                return
            }
            
            guard let polyLineString = overview_polyline["points"] as? String else {
                return
            }
            
            //Drawing must happen on the main thread
            DispatchQueue.main.async {
                self.drawPath(from: polyLineString)
            }
        })
        //Send request
        task.resume()
    }
    
    //Draw the path on screen
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        self.polyline = GMSPolyline(path: path)
        self.polyline.strokeWidth = 3.0
        self.polyline.map = mapView // Google MapView
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

