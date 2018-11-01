//
//  NewCityController.swift
//  WeatherApp02
//
//  Created by Daniel Stefanik on 30/10/2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import UIKit
class SearchCell: UITableViewCell {
    
    @IBOutlet weak var addUI: UIButton!
    @IBOutlet weak var nameUI: UILabel!
    
    @IBAction func add(_ sender: Any) {
        print("ADD: \((nameUI.text)!)")
    }
}
class NewCityController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    @IBOutlet weak var tableUI: SearchTableContrloller!
//    @IBOutlet weak var tableUI: SearchTableController!
    @IBOutlet weak var tableUI: UITableView!
    
    @IBOutlet weak var inputUI: UITextField!
    
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
        print("cancel")
//        dismiss(animated: true, completion: nil)
        _ = navigationController?.popViewController(animated: true)
//        _ = navigationController?.popToRootViewController(animated: true)
//        performSegue(withIdentifier: "cancel", sender: sender)
        
    }
    @IBAction func search(_ sender: Any) {
        print("search:")
        print(inputUI.text ?? "??")
        let metaWeater = MetaWeater02Service()
        metaWeater.findCity(name: inputUI.text ?? "", completionHandler: searchResult)
    }
    
    func searchResult(result: [String:String]){
//        for v in result{
//            print("\(v.key):\(v.value)")
//        }
        self.search = result
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("c: \(search.count)")
        return search.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
//        print("COUNT: \(search.count)")
        if(!search.isEmpty){
            let result = Array(self.search)[indexPath.row]
            cell.nameUI?.text = result.value
        }
        return cell
    }
    

    
}
