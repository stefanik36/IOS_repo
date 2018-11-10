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
//
//extension AppDelegate : UISplitViewControllerDelegate {
//    func splitViewController(_ svc: UISplitViewController, collapseSecondary vc2: UIViewController, onto vc1: UIViewController) -> Bool {
//        return true
//    }
//}
extension MasterViewControllerTableViewController: UISplitViewControllerDelegate, AddCityProtocol {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return collapseDetailViewController
    }
}
protocol CitySelectionDelegate: class {
    func citySelected(_ newCity: CityInfo)
}

class MasterViewControllerTableViewController: UITableViewController {
    fileprivate var collapseDetailViewController = true

    @IBOutlet weak var addCityUI: UIButton!
    
//    var overlay : UIView?
    
    weak var delegate: CitySelectionDelegate?
    var defaultCities = ["Paris","London","Barcelona"]
    
    var cities: [CityInfo]{
        didSet{
//            print("ARR CHANGE \(cities.endIndex)")
//            for c in cities {
//                print(c.name!)
//            }
            refresh()
        }
    }
    var startDate: Date;
    
    var name: String = ""
    var index: String = ""
    //var metaWeater: MetaWeater02Service?;
    
//    func loadingPanel(){
//
//        overlay = UIView(frame: view.frame)
//        let title = UILabel()
//        title.text = "Loading..."
//        title.numberOfLines = 0
//        title.textAlignment = .center
//        title.textColor = UIColor.white
//        title.sizeToFit()
//        title.center = overlay!.center
//        overlay!.addSubview(title)
//
//        overlay!.backgroundColor = UIColor.black
//        overlay!.alpha = 0.8
//        view.addSubview(overlay!)
//
//    }
    var window: UIWindow?
    func setDelegate02(){
        let leftNavController = splitViewController!.viewControllers.first as? UINavigationController
        
        let masterViewController = leftNavController!.topViewController as? MasterViewControllerTableViewController
        let detailViewControllerNew = (self.storyboard?.instantiateViewController(withIdentifier: "ViewController")) as! ViewController
        masterViewController!.delegate = detailViewControllerNew
    }
    func setDelegate(vc: ViewController) -> ViewController?{
        if var topController = UIApplication.shared.keyWindow?.rootViewController  {
            print("1 \(topController)")
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
                print("2 \(presentedViewController)")
            }
            
            let last = splitViewController!.viewControllers.last as? UINavigationController
            
            print("last2: \(String(describing: last))")
            print("count: \(splitViewController!.viewControllers.count)")
            print("3 \(topController)")
            let leftNavController = splitViewController!.viewControllers.first as? UINavigationController
            print("\(String(describing: leftNavController))")
            let masterViewController = leftNavController!.topViewController as? MasterViewControllerTableViewController
            print("\(String(describing: masterViewController))")
//            let detailViewController = splitViewController!.viewControllers.last as? ViewController
            print("\(String(describing: vc))")
            masterViewController!.delegate = vc
            return vc
//            topController!.delegate = detailViewController
            
            // topController should now be your topmost view controller
        }
//        print(":::::::::::")
//        let splitViewController = window?.rootViewController as? UISplitViewController
//        print("\(String(describing: splitViewController))")
//        let leftNavController = splitViewController!.viewControllers.first //as? UINavigationController
//        print("\(String(describing: leftNavController))")
//        let masterViewController = leftNavController!.topViewController as? MasterViewControllerTableViewController
//        print("\(String(describing: masterViewController))")
//        let detailViewController = splitViewController!.viewControllers.last as? ViewController
//        print("\(String(describing: detailViewController))")
//        guard let splitViewController = window?.rootViewController as? UISplitViewController,
//            let leftNavController = splitViewController.viewControllers.first as? UINavigationController,
//            let masterViewController = leftNavController.topViewController as? MasterViewControllerTableViewController,
//            let detailViewController = splitViewController.viewControllers.last as? ViewController
//            //            let rightNavController = splitViewController.viewControllers.last as? UINavigationController
//            //            let detailViewController = rightNavController.topViewController as? ViewController
//
//            else { fatalError() }
        
        print("APP DELEGATE")
        
//        let firstCity = masterViewController.cities.first
//        detailViewController.city = firstCity
//        masterViewController!.delegate = detailViewController
//        detailViewController.navigationItem.leftItemsSupplementBackButton = true
//        detailViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        return nil
    }
    
    func refresh(){
        
//        setDelegate()
        
        print("refresh")
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl = UIRefreshControl()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("init")
        self.startDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        self.cities = []
        
        super.init(coder: aDecoder)
        for cn in defaultCities {
            let metaWeater = MetaWeater02Service()
            metaWeater.findCity(name: cn, completionHandler: addFirstAsCity)
        }
    }
    
    func addFirstAsCity(dict: [String : String]){
        addNewCity(cityIndex: (dict.first?.key)!, cityName: (dict.first?.value)!)
    }
    
    func addNewCity(cityIndex: String, cityName: String){
        let metaWeater = MetaWeater02Service()
        metaWeater.getData(cityIndex: cityIndex, cityName: cityName, startDate: startDate, completionHandler: setData)
    }
    
    func setData(city: CityInfo){
        cities.append(city)
    }
    
//    func displaySecondVC() {
//        let sc = SearchCell()
//        sc.delegate = self
//
//        self.present(sc, animated: true)
//    }
    func add(index: String, name: String) {
        addNewCity(cityIndex: index, cityName: name)
        print("ADD?::: \(index) : \(name)")
        UIView.animate(withDuration: 2){
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func addCity(_ sender: Any) {
        print("new City")
        performSegue(withIdentifier: "newCity", sender: sender)
    }
    //    @IBAction func addCity02(_ sender: Any) {
//        print("new City")
//        performSegue(withIdentifier: "newCity", sender: sender)
//    }
    
    
    
//    @IBAction func addCity(_ sender: UIButton) {
//        print("new City")
//        performSegue(withIdentifier: "newCity", sender: sender)
//    }
    
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        print("segue - \(identifier)")
//
////        if let destinationViewController = segue.destination as? <NewCityController> {
////            if let button = sender as? UIButton {
////                secondViewController.<buttonIndex> = button.tag
////                // Note: add/define var buttonIndex: Int = 0 in <YourDestinationViewController> and print there in viewDidLoad.
////            }
////
////        }
//    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
//        loadingPanel()s
        self.addCityUI.setTitle("+", for: .normal)
        
        splitViewController?.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //        cell.textLabel?.text = city.name
        //        cell.detailTextLabel?.text = (city.temp).map{"\(String(format:"%.1f", $0))"} ?? ""
        // print("_________________")
        //        print(city.image!)
        //        if let x = (city.image).map({UIImage(data: $0)})  {cell.imageView?.image = x;}
        
        //        return cell
        let cc = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
//        let cc = CustomCell()
        
        
        if(!cities.isEmpty){
            let city = cities[indexPath.row]
            cc.cityUI.text = city.name ?? "?? "
            cc.tempUI.text = (city.temp).map{"\(String(format:"%.1f", $0))"} ?? "?? "
            if let x = (city.image).map({UIImage(data: $0)})  {cc.imageUI?.image = x;}
        }
        return cc
    }
    
    func addCityDelegate() {
        print("addCityDelegate: \(self.name) : \(self.index)")
        addNewCity(cityIndex: index, cityName: name)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? NewCityController{
            destVC.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (!cities.isEmpty){
            print("select city")
            
//            self.overlay?.removeFromSuperview()
           
//            print(splitViewController!.viewControllers.count)
            let selectedCity = cities[indexPath.row]
            delegate?.citySelected(selectedCity)
            
            
            let detailViewController = delegate as? ViewController
            if(detailViewController == nil){
                print("set delegate 02")
                setDelegate02()
            }
    
            if let detailViewController = delegate as? ViewController{
                print("delegate")
                detailViewController.city = selectedCity
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
