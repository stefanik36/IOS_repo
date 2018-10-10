//
//  ViewController.swift
//  WeatherApp02
//
//  Created by Klaudia Tutaj on 10.10.2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nextUI: UIButton!
    @IBOutlet weak var minTempUI: UITextField!
    var startDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!;
    var currentDate:Date?;
    
    var metaWeater : MetaWeaterService?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDate = startDate;
        metaWeater = MetaWeaterService(startDate: startDate, completionHandler: handleData)
        
        getData()
        
        print("asdasdasdas")
        
    }
    
    @IBAction func nextButton(_ sender: Any) {
        minTempUI.insertText("asdasdfg")
    }
    
     func handleData(weaterInfos: [WeaterInfo]){
         print("handleData");
         print(weaterInfos.endIndex);
         for wi in weaterInfos{
            print(wi.id!);
         }
     }
     
     @IBAction func prev(_ sender: Any) {
     
     }
     @IBAction func next(_ sender: Any) {
     
     }
     
     func getData() {
        metaWeater!.getData();
     }
    

}

