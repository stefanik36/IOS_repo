//
//  MapController.swift
//  WeatherApp02
//
//  Created by Daniel Stefanik on 14/11/2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import UIKit
import CoreLocation
//import MapKit

class MapController: UIViewController, CLLocationManagerDelegate {

//    @IBOutlet weak var MapUI: MKMapView!
//    var locationManager: CLLocationManager!
//
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//
//        if (CLLocationManager.locationServicesEnabled())
//        {
//            locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
//        }
//    }
//
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//    {
//
//        let location = locations.last! as CLLocation
//
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//        self.MapUI.setRegion(region, animated: true)
//    }

}
