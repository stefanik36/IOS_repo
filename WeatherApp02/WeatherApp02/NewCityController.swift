//
//  NewCityController.swift
//  WeatherApp02
//
//  Created by Daniel Stefanik on 30/10/2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import UIKit


protocol controls {
    func add()
}
protocol SomeProtocol {
    
    var index : String {get set}
    var name : String{ get set}
    
    func addCityDelegate()
}

class SearchCell: UITableViewCell {
    var delegate: controls?
    
//    @IBOutlet weak var addUI: UIButton!
    @IBOutlet weak var nameUI: UILabel!
    
//    var index: String?
//    var returnFunction: ((UIViewController) -> ())?;
    
//    @IBAction func add(_ sender: Any) {
//        print("ADD: \((nameUI.text)!)")
////        self.delegate?.add()
//
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MasterViewControllerTableViewController") as! MasterViewControllerTableViewController
//        nextViewController.add(index: index!, name: (nameUI.text)!)
//        returnFunction!(nextViewController)
//    }
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
    
    func toMain(controller: UIViewController){
//        _ = navigationController?.popViewController(animated: true)
//        self.window?.rootViewController = controller
        
//        let i = navigationController?.viewControllers.index(of: self)
//        let previousViewController = navigationController?.viewControllers[i!-1]
        
        let viewController = UIApplication.shared.keyWindow!.rootViewController?.children
        for x in viewController! {
            
            print("a: \(x)")
        }
//        let viewController = self.splitViewController?.viewControllers.first
        
//        let viewController = UIApplication.shared.keyWindow!.rootViewController as! MasterViewControllerTableViewController
        self.navigationController?.pushViewController(viewController![0], animated: true)
        
    }
    
    
    var delegate : SomeProtocol?

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
//        print("COUNT: \(search.count)")
        if(!search.isEmpty){
            let result = Array(self.search)[indexPath.row]
            cell.nameUI?.text = result.value
//            cell.index = result.key
//            cell.returnFunction = toMain
        }
          return cell
    }
    

    
}
