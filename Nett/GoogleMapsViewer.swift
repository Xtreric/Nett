//
//  GoogleMapsViewer.swift
//  Nett
//
//  Created by Eric Huang on 2016/7/27.
//  Copyright © 2016年 WeBIM. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps


class GoogleMapsViewer: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    // 設置CLLocationManager實例委託和精度
    let locationManager = CLLocationManager()
    let didFindMyLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 設置CLLocationManager實例委託和精度
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 5  // 設置距離篩選器distanceFilter，設備至少移動5米，才通知委託更新
        
        
        
        mapView.myLocationEnabled = true
        self.view = mapView

        
        // GOOGLE MAPS SDK: BORDER
        let mapInsets = UIEdgeInsets(top: 80.0, left: 0.0, bottom: 45.0, right: 0.0)
        mapView.padding = mapInsets
        
        // GOOGLE MAPS SDK: COMPASS
        mapView.settings.compassButton = true
        
        // GOOGLE MAPS SDK: USER'S LOCATION
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        mapView.accessibilityElementsHidden = false

        /*
        // 現在時間
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let string = formatter.stringFromDate(now)
        
        print(string)
        */
        
        // GOOGLE MAPS SDK: MARKER
        //let marker1 = GMSMarker()
        //marker1.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        //marker1.flat = true
        //marker1.position = CLLocationCoordinate2DMake(25.042237, 121.535820)
        //marker1.title = "Taipei Tech"
        //marker1.snippet = "infoWindow-Test"
        //marker1.map = mapView
        //marker1.appearAnimation = kGMSMarkerAnimationPop
        //marker1.opacity = 0.6
        //marker1.infoWindowAnchor = CGPointMake(0.5, 0.5)
        //marker1.draggable = true
        //marker1.icon = UIImage(named: "maps")
        
        
        // GOOGLE MAPS SDK: MARKER
        //let marker = GMSMarker()
        //marker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
        //marker.flat = true
        //marker.position = CLLocationCoordinate2DMake(25.033971, 121.564735)
        //marker.title = "Taipei 101"
        //marker.snippet = "infoWindow-Test"
        //marker.map = mapView
        //marker.appearAnimation = kGMSMarkerAnimationPop
        //marker.opacity = 0.6
        //marker.icon = UIImage(named: "maps")
        //marker.draggable = true
        
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView


        // PRINT MYLOCATION COORDINATION
//        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GoogleMapsViewer.place), userInfo: nil, repeats: true)

    }
    
    // PRINT MYLOCATION COORDINATION
//    func place() {
//        print(mapView.myLocation)
//    }

    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil).first! as! CustomInfoWindow
        infoWindow.label.text = "\(marker.position.latitude) \(marker.position.longitude)"
        return infoWindow
    }
    
    func getDistanceMetresBetweenLocationCoordinates(coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
        let location2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
        return location1.distanceFromLocation(location2)
    }
    
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.cameraWithLatitude((location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        mapView?.animateToCameraPosition(camera)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription)
    }
    
}

