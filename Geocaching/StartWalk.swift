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

class StartWalk: UIViewController, CLLocationManagerDelegate,AVAudioPlayerDelegate  {

    var player: AVPlayer!
    var mapView:GMSMapView?
    var locationManager = CLLocationManager()
    var APIKey = "AIzaSyDWKxNekjyN_SsRSwauPUA1_KF98SNqYNM"
    var distanceThreshold = 20.0
    var polyline = GMSPolyline(path: nil)
    var pathFetched = false
    var nextMarkerIndex = 0
    var nextDestination = CLLocationCoordinate2D(latitude: items[0]["lat"] as! CLLocationDegrees,longitude: items[0]["long"] as! CLLocationDegrees)
    var disableColor = UIColor(red: 0.514, green: 0.514, blue: 0.514, alpha: 1)
    var soundOn = false
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
        self.locationManager.distanceFilter = 2
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
    
    func setNotifications(title: String, subtext: String, team: String) {
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: subtext,arguments: nil)
        content.userInfo["team"] = team
        content.categoryIdentifier = "Geocaching"
        let time = 1.0
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
          if let theError = error {
            NSLog(theError.localizedDescription)
          }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyShadows()
        disableButton()
        initMap()
        addMarkers()
    }
    
    func updateNextDestination() {
        nextMarkerIndex += 1
        if (nextMarkerIndex != 10) {
            nextDestination = CLLocationCoordinate2D(latitude: items[nextMarkerIndex]["lat"] as! CLLocationDegrees,longitude: items[nextMarkerIndex]["long"] as! CLLocationDegrees)
        }
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: (self.mapView?.camera.zoom)!)
        
        self.mapView?.animate(to: camera)
        
        let origin = location?.coordinate
        if (nextMarkerIndex != 10) {
            self.checkDistance(distance: self.distanceInMeterBetweenPoints(lat1: (origin?.latitude)!, lon1: (origin?.longitude)!, lat2: self.nextDestination.latitude, lon2: self.nextDestination.longitude))
        }
//        self.locationManager.stopUpdatingLocation()
        
    }
    
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }

            let loc = items[self.nextMarkerIndex - 1]["labelText"] as! String
            let dis = NSString(format: "%.2f", self.distanceThreshold) as String
            let subtext = "You are within " + dis + " from " + loc
            if settings.alertSetting == .enabled {
                self.setNotifications(title: items[self.nextMarkerIndex - 1]["teamName"] as! String, subtext: subtext, team: items[self.nextMarkerIndex - 1]["resource"] as! String)
            } else {
                self.setNotifications(title: items[self.nextMarkerIndex - 1]["teamName"] as! String, subtext: subtext, team: items[self.nextMarkerIndex - 1]["resource"] as! String)
            }
        }
    }
    
    func checkDistance(distance: double_t) {
        print(distance)
        if (distance > distanceThreshold && showImage.backgroundColor != UIColor.systemBlue) {
//            disableButton()
        } else if (distance < distanceThreshold && showImage.backgroundColor == disableColor) {
//            enableButton()
            self.scheduleNotification()
            if (self.soundOn) {
                self.play()
            }
            updateNextDestination()
            
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        let marker = nextMarkerIndex - 1
        let url = Bundle.main.url(forResource: (items[marker]["team_sound"] as! String), withExtension: "m4a", subdirectory: "Teams")
        let playerItem = AVPlayerItem(url: url!)
        self.player = AVPlayer(playerItem:playerItem)
        player!.volume = 1.0
        player!.play()
    }
    
    func play() {
        let marker = nextMarkerIndex
        let url = Bundle.main.url(forResource: (items[marker]["location_sound"] as! String), withExtension: "m4a", subdirectory: "Locations")
        let playerItem = AVPlayerItem(url: url!)
        self.player = AVPlayer(playerItem:playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        player!.volume = 1.0
        player!.play()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
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
