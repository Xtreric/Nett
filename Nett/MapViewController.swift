//
//  MapViewController.swift
//  Nett
//
//  Created by Eric Huang on 2016/7/27.
//  Copyright © 2016年 WeBIM. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate{

    
    @IBOutlet weak var mapViewer: GMSMapView!
    
    let locationManager = CLLocationManager()
    let didFindMyLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            mapViewer.myLocationEnabled = true
        }
    }
    

    
    override func loadView() {
        
        let camera = GMSCameraPosition.cameraWithLatitude(25.030678, longitude: 121.549191, zoom: 15)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        self.view = mapView

        let mapInsets = UIEdgeInsets(top: 80.0, left: 0.0, bottom: 45.0, right: 0.0)
        mapView.padding = mapInsets
        
        // GOOGLE MAPS SDK: MAP PRESENT STYLE
        mapView.mapType = kGMSTypeNormal
        
        // GOOGLE MAPS SDK: GESTURES
        mapView.settings.zoomGestures = true  //控制縮放手勢
        mapView.settings.scrollGestures = true  //控制捲動手勢
        mapView.settings.tiltGestures = true  //控制傾斜手勢
        mapView.settings.rotateGestures = true  //控制旋轉手勢
        
        mapView.accessibilityElementsHidden = false
        
        // GOOGLE MAPS SDK: USER'S LOCATION
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
        } else {
            print("User's location is unknown")
        }
        
        // GOOGLE MAPS SDK: COMPASS
        mapView.settings.compassButton = true
    }

    
    
    
    
}