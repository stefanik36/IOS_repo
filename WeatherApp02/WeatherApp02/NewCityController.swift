//
//  NewCityController.swift
//  WeatherApp02
//
//  Created by Klaudia Tutaj on 30/10/2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import UIKit

class NewCityController: UIViewController {

    @IBOutlet weak var tableUI: UITableView!
    @IBOutlet weak var inputUI: UITextField!
    @IBAction func cancel(_ sender: Any) {
        print("cancel")
    }
    @IBAction func search(_ sender: Any) {
        print("search:")
        print(inputUI.text ?? "??")
        let metaWeater = MetaWeater02Service()
        metaWeater.findCity(name: inputUI.text ?? "", completionHandler: searchResult)
    }
    
    func searchResult(result: [String:String]){
        for v in result{
            print("\(v.key):\(v.value)")
        }
        DispatchQueue.main.async {
            self.tableUI.beginUpdates()
            self.tableUI.insertRows(
                at: [IndexPath(row: 5, section: 0)],
                with: .automatic
            )
            self.tableUI.endUpdates()
        }
    }
    
    
    
}
