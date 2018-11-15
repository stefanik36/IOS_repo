//
//  MapController.swift
//  WeatherApp02
//
//  Created by Daniel Stefanik on 14/11/2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var cityNameUI: UILabel!
    @IBOutlet weak var mapUI: MKMapView!
    var locationManager: CLLocationManager!
    
    var cityName: String?;

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.cityNameUI.text = cityName

        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        let metaWeater = MetaWeaterService()
        metaWeater.findCityLocation(name: self.cityName!, completionHandler: showMap)
    }
    
    
    func showMap(latt:Double, long:Double){
        let center = CLLocationCoordinate2D(latitude: latt, longitude: long)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.mapUI.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latt, longitude: long)
        self.mapUI.addAnnotation(annotation)
    }

}
