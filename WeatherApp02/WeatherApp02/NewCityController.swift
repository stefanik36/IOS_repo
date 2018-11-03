//
//  NewCityController.swift
//  WeatherApp02
//
//  Created by Daniel Stefanik on 30/10/2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import UIKit


protocol AddCityProtocol {
    var index : String {get set}
    var name : String{ get set}
    func addCityDelegate()
}

class SearchCell: UITableViewCell {
    @IBOutlet weak var nameUI: UILabel!
}

class NewCityController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableUI: UITableView!
    @IBOutlet weak var inputUI: UITextField!
    
    var delegate : AddCityProtocol?
    
    var search:[String:String] = [:]{
        didSet{
            refresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableUI.dataSource = self;
        self.tableUI.delegate = self;
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
            delegate?.index = result.key
            delegate?.name = result.value
            delegate?.addCityDelegate()
            _ = navigationController?.popViewController(animated: true)
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
