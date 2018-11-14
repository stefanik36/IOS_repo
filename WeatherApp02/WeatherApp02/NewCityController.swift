//
//  NewCityController.swift
//  WeatherApp02
//
//  Created by Daniel Stefanik on 30/10/2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol AddCityProtocol {
    var index : String {get set}
    var name : String{ get set}
    func addCityDelegate()
}

class SearchCell: UITableViewCell {
    @IBOutlet weak var nameUI: UILabel!
}

class NewCityController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet weak var tableUI: UITableView!
    @IBOutlet weak var inputUI: UITextField!
    @IBOutlet weak var closeUI: UILabel!
    
    var delegate : AddCityProtocol?
    var locationManager: CLLocationManager!
    var search:[String:String] = [:]{
        didSet{
            refresh()
        }
    }
    var closeIndex: String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableUI.dataSource = self;
        self.tableUI.delegate = self;
        
        
        print("location :")
        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            print("location enabled")
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        
    }
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//    {
//
//        let location = locations.last! as CLLocation
//
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//        self.map.setRegion(region, animated: true)
//    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("LM")
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let metaWeater = MetaWeater02Service()
        metaWeater.findCityByLocation(latitude: locValue.latitude, longitude: locValue.longitude, completionHandler: locationResult)
    }
    
    func locationResult(index: String, name: String){
        print("LOCATION SEARCH: \(index):\(name)")
        DispatchQueue.main.async {
            self.closeUI.text = name;
            self.closeIndex = index;
        }
    }
    @IBAction func ChooseCity(_ sender: Any) {
        print("add city touch location")
       doDelegate(index: self.closeIndex!, name: self.closeUI.text!)
    }
    
    func doDelegate(index:String, name:String){
        delegate?.index = index
        delegate?.name = name
        delegate?.addCityDelegate()
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    func refresh(){
        DispatchQueue.main.async {
            self.tableUI.reloadData()
            self.tableUI.refreshControl = UIRefreshControl()
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func search(_ sender: Any) {
        print("search:")
        print(inputUI.text ?? "??")
        let metaWeater = MetaWeater02Service()
        if let name = inputUI.text {
            if(name != "" && !name.isEmpty){
                metaWeater.findCity(name: name, completionHandler: searchResult)
            }
        }
    }
    
    func searchResult(result: [String:String]){
        self.search = result
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search.count
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (!search.isEmpty){
            print("add city touch")
            let result = Array(self.search)[indexPath.row]
            doDelegate(index: result.key, name: result.value)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        if(!search.isEmpty){
            let result = Array(self.search)[indexPath.row]
            cell.nameUI?.text = result.value
        }
        return cell
    }
    

    
}
