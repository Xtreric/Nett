//
//  MapVC.swift
//  Nett
//
//  Created by Eric Huang on 2016/7/27.
//  Copyright © 2016年 WeBIM. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapVC: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var mapView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.cameraWithLatitude(23.911649, longitude: 121.049752, zoom: 7.5)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.delegate = self
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(25.033971, 121.564735)
        marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        marker.flat = true
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.opacity = 0.6
        marker.title = ""
        marker.snippet = ""
        marker.map = mapView
        
        
        // GOOGLE MAPS SDK: COMPASS
        mapView.settings.compassButton = true
        
        // GOOGLE MAPS SDK: USER'S LOCATION
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        // GOOGLE MAPS SDK: BORDER
        let mapInsets = UIEdgeInsets(top: 80.0, left: 0.0, bottom: 45.0, right: 0.0)
        mapView.padding = mapInsets
    
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil).first! as! CustomInfoWindow
        infoWindow.label.text = "\(marker.position.latitude) \(marker.position.longitude)"
        infoWindow.label1.text = "Taipei 101"
        //infoWindow.infoImage.image = UIImage(named: "maps")! as UIImage
        return infoWindow
    }
    
    
    func getDistanceMetresBetweenLocationCoordinates(coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
        let location2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
        return location1.distanceFromLocation(location2)
    }
}

