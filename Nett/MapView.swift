//
//  MapView.swift
//  Nett
//
//  Created by Eric Huang on 2016/8/3.
//  Copyright © 2016年 WeBIM. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var appleMapView: MKMapView!
    @IBOutlet weak var currentLocationBtn: UIButton!
    
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        
        // 得到座標
        let coordinate = locationManager.location?.coordinate
        print("\(coordinate?.latitude)")
        print("\(coordinate?.longitude)")
        
        // 直向縮放
        let latDelta:CLLocationDegrees = 0.01
        // 橫向縮放
        let lonDelta:CLLocationDegrees = 0.01
        // 從直向縮放與橫向縮放產生縮放範圍
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        // 從座標與縮放範圍產生顯示範圍
        if coordinate != nil {
            let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate!, span)
            appleMapView.setRegion(region, animated: true) // 讓地圖秀出區域
            
            
        // 地圖顯示模式
        appleMapView.mapType = .Standard
        
        // 設定定位準確程度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
        // 設定活動模式
        locationManager.activityType = .AutomotiveNavigation
            
        // 設定delegate
        locationManager.delegate = self

        // 開始更新位置資訊
        locationManager.startUpdatingLocation()
            
        // 設定userTrackingMode
        appleMapView.userTrackingMode = .Follow
            
        // 顯示使用者定位
        appleMapView.showsUserLocation = true
        
        // 顯示地圖比例尺
        appleMapView.showsScale = true
        
        // 顯示交通狀況
        appleMapView.showsTraffic = false
        
        // 顯示建築物
        appleMapView.showsBuildings = true

        /*
        // 地圖顯示模式
        let segment = UISegmentedControl(items: ["Standard","Satellite","Hybrid"])
        segment.frame = CGRectMake(20, 40, 200, 30)
        segment.selectedSegmentIndex = 0
        segment.tintColor = UIColor.blueColor()
        segment.addTarget(self, action: #selector(MapView.changeMapType(_:)), forControlEvents: .ValueChanged)
        self.view.addSubview(segment)
        */
        }
        
        // 地圖上放上大頭針
        let latitudePlace:CLLocationDegrees = 25.033931  // 緯度
        let longitudePlace:CLLocationDegrees = 121.564632  // 經度
        // 從經緯度產生座標
        let coordinatePlace: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudePlace, longitudePlace)
        // 產生大頭針
        let annotationPlace = MKPointAnnotation()
        // 設定大頭針的座標
        annotationPlace.coordinate = coordinatePlace
        // 標題
        annotationPlace.title = "Taipei 101"
        // 副標題
        annotationPlace.subtitle = "The tallest tower of the world"
        // 加到地圖中
        appleMapView.addAnnotation(annotationPlace)
        
        
        // 地圖上放上大頭針
        let latitudePlace1:CLLocationDegrees = 25.031022  // 緯度
        let longitudePlace1:CLLocationDegrees = 121.549233  // 經度
        // 從經緯度產生座標
        let coordinatePlace1: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudePlace1, longitudePlace1)
        // 產生大頭針
        let annotationPlace1 = MKPointAnnotation()
        // 設定大頭針的座標
        annotationPlace1.coordinate = coordinatePlace1
        // 標題
        annotationPlace1.title = "Starbucks"
        // 副標題
        annotationPlace1.subtitle = "敦富門市"
        // 加到地圖中
        appleMapView.addAnnotation(annotationPlace1)
        
        
    }

    
    @IBAction func currentLocationBtn_Click(sender: AnyObject) {
        // 得到座標
        let coordinate = locationManager.location?.coordinate
        print("\(coordinate?.latitude)")
        print("\(coordinate?.longitude)")
        print("just pressed button")
        // 直向縮放
        let latDelta:CLLocationDegrees = 0.01
        // 橫向縮放
        let lonDelta:CLLocationDegrees = 0.01
        // 從直向縮放與橫向縮放產生縮放範圍
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        // 從座標與縮放範圍產生顯示範圍
        if coordinate != nil {
            let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate!, span)
            appleMapView.setRegion(region, animated: true) // 讓地圖秀出區域
        }
    }
    
    /*
    // 地圖顯示模式
    func changeMapType(segment:UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 1:
            appleMapView.mapType = .Satellite
            break
        case 2:
            appleMapView.mapType = .Hybrid
            break
        default:
            appleMapView.mapType = .Standard
            break
        }
    }
    */

    
    @IBAction func addPin(gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .Began else { return }
        
        // 得到觸控點
        let tapPoint = gesture.locationInView(appleMapView)
        // 觸碰點轉成座標 CLLocationCoordinate2D
        let coordinate = appleMapView.convertPoint(tapPoint, toCoordinateFromView: appleMapView)
        
        // 產生大頭針
        let annotation = MKPointAnnotation()
        // 設定大頭針的座標
        annotation.coordinate = coordinate
        // 大頭針標題
        annotation.title = "\(coordinate.latitude), \(coordinate.longitude)"
        // 把大頭針加到地圖上
        appleMapView.addAnnotation(annotation)
        appleMapView.showAnnotations([annotation], animated: true)
        
        reverseGeocode(annotation) { placemark in
            annotation.subtitle = annotation.title
            annotation.title = placemark.name
            
            self.appleMapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            // 判斷大頭針是否為別的類別, 如果不是MKPointAnnotation而是MKUserLocation, 就return離開
            return nil
        }
        // 新建一個來判斷可否回收的標記
        let identifier = "myPin"
        // 試著看看是否有可重複使用的大頭針，如果有的話，存在變數 result 中
        var result = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if result == nil {
            // 如果沒有可重複使用的大頭針，則新建一個大頭針，並設定其顯示文字
            result = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            // 如果有的話，設定其顯示文字
            result?.annotation = annotation
        }
        
        // 設定點選可以秀出資訊
        result?.canShowCallout = true
        // 設定顯示圖片
        result?.image = UIImage(named: "MyPin")
        // 設定大頭針顏色
        //(result as! MKPinAnnotationView).pinTintColor = UIColor.redColor()
        // 設定大頭針是否做出落下動畫
        //(result as! MKPinAnnotationView).animatesDrop = false
        
        
        // 讀入圖片，設定Callout左邊顯示的View
        let mapImageView = UIImageView(image: UIImage(named: "maps"))
        let nextImageBtn = UIImage(named: "Next")! as UIImage
        result?.leftCalloutAccessoryView = mapImageView
        // 設定Callout右邊的button
        let button = UIButton(type: .DetailDisclosure)
        button.addTarget(self, action: #selector(MapView.buttonPressed(_:)), forControlEvents: .TouchUpInside)
        result?.rightCalloutAccessoryView = button
        
        return result
    }
    
    
    // Note: return an optional clousre async with default value
    private func reverseGeocode(annotation: MKAnnotation, completion: (CLPlacemark -> Void)? = nil) {
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, _) in
            guard let placemark = placemarks?.first else { return }
            completion?(placemark) // Note: Using optional closure
        }
    }
    
    
    // Callout 資訊視窗翻頁
    func buttonPressed(button:UIButton) {
        print("button_clicked")
        self.performSegueWithIdentifier("nextPageSegue", sender: nil)
        
    }
}