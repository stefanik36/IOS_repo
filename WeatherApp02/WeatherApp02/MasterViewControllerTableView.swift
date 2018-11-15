//
//  MasterViewControllerTableViewController.swift
//  WeatherApp02
//
//  Created by Student on 23/10/2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import UIKit


class CustomCell: UITableViewCell {
    @IBOutlet weak var cityUI: UILabel!
    @IBOutlet weak var tempUI: UILabel!
    @IBOutlet weak var imageUI: UIImageView!
}

extension MasterViewControllerTableView: UISplitViewControllerDelegate, AddCityProtocol {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return collapseDetailViewController
    }
}
protocol CitySelectionDelegate: class {
    func citySelected(_ newCity: CityInfo)
}

class MasterViewControllerTableView: UITableViewController {
    fileprivate var collapseDetailViewController = true

    @IBOutlet weak var addCityUI: UIButton!
    
    weak var delegate: CitySelectionDelegate?
    var defaultCities = ["Paris","London","Barcelona"]
    
    var cities: [CityInfo]{
        didSet{
            refresh()
        }
    }
    var startDate: Date;
    
    var name: String = ""
    var index: String = ""
    
    var window: UIWindow?
    
    
    func setDelegate(){
        let leftNavController = splitViewController!.viewControllers.first as? UINavigationController
        let masterViewController = leftNavController!.topViewController as? MasterViewControllerTableView
        let detailViewControllerNew = (self.storyboard?.instantiateViewController(withIdentifier: "ViewController")) as! ViewController
        masterViewController!.delegate = detailViewControllerNew
    }
    
    func refresh(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl = UIRefreshControl()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.startDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        self.cities = []
        
        super.init(coder: aDecoder)
        for cn in defaultCities {
            let metaWeater = MetaWeaterService()
            metaWeater.findCity(name: cn, completionHandler: addFirstAsCity)
        }
    }
    
    func addFirstAsCity(dict: [String : String]){
        addNewCity(cityIndex: (dict.first?.key)!, cityName: (dict.first?.value)!)
    }
    
    func addNewCity(cityIndex: String, cityName: String){
        let metaWeater = MetaWeaterService()
        metaWeater.getData(cityIndex: cityIndex, cityName: cityName, startDate: startDate, completionHandler: setData)
    }
    
    func setData(city: CityInfo){
        cities.append(city)
    }
    
    func add(index: String, name: String) {
        addNewCity(cityIndex: index, cityName: name)
        UIView.animate(withDuration: 2){
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func addCity(_ sender: Any) {
        performSegue(withIdentifier: "newCity", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCityUI.setTitle("+", for: .normal)
        splitViewController?.delegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cc = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell

        if(!cities.isEmpty){
            let city = cities[indexPath.row]
            cc.cityUI.text = city.name ?? "?? "
            cc.tempUI.text = (city.temp).map{"\(String(format:"%.1f", $0))"} ?? "?? "
            if let x = (city.image).map({UIImage(data: $0)})  {cc.imageUI?.image = x;}
        }
        return cc
    }
    
    func addCityDelegate() {
        addNewCity(cityIndex: index, cityName: name)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? NewCityController{
            destVC.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (!cities.isEmpty){
            let selectedCity = cities[indexPath.row]
            delegate?.citySelected(selectedCity)
            
            let detailViewController = delegate as? ViewController
            if(detailViewController == nil){
                setDelegate()
            }
    
            if let detailViewController = delegate as? ViewController{
                detailViewController.city = selectedCity
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
    }
}
