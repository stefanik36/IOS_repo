//
//  MasterViewControllerTableViewController.swift
//  WeatherApp02
//
//  Created by Student on 23/10/2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import UIKit

protocol CitySelectionDelegate: class {
    func citySelected(_ newCity: CityInfo)
}

class MasterViewControllerTableViewController: UITableViewController {

    
    
    weak var delegate: CitySelectionDelegate?
    var defaultCities = ["Paris","London","Barcelona"]
    
    var cities:[CityInfo];
    
    required init?(coder aDecoder: NSCoder) {
        
        //Load data from defaultCities and in loop add to cities
        
        self.cities = [
            CityInfo(name: defaultCities[0], index: "index #1", temp: 666.666, image: Data()),
            CityInfo(name: defaultCities[1], index: "index #2", temp: 666.667, image: Data()),
            CityInfo(name: defaultCities[2], index: "index #3", temp: 666.686, image: Data())
        ]
        
        
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let city = cities[indexPath.row]
        cell.textLabel?.text = city.name
        // Configure the cell...

        return cell
    }
    
  

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        delegate?.citySelected(selectedCity)
        if let detailViewController = delegate as? ViewController,
            let detailNavigationController = detailViewController.navigationController {
            splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
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
