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
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let metaWeater = MetaWeaterService()
        metaWeater.findCityByLocation(latitude: locValue.latitude, longitude: locValue.longitude, completionHandler: locationResult)
    }
    
    func locationResult(index: String, name: String){
        DispatchQueue.main.async {
            self.closeUI.text = name;
            self.closeIndex = index;
        }
    }
    @IBAction func ChooseCity(_ sender: Any) {
        if(self.closeIndex != nil && self.closeUI.text != nil){
            doDelegate(index: self.closeIndex!, name: self.closeUI.text!)
        }
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
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func search(_ sender: Any) {
        let metaWeater = MetaWeaterService()
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
