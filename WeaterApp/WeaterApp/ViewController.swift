//
//  ViewController.swift
//  WeaterApp
//
//  Created by Student on 09/10/2018.
//  Copyright © 2018 Student. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    
    @IBOutlet weak var uiDate: UILabel!
    @IBOutlet weak var uiImage: UIImageView!
    
    var startDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!;
    var currentDate:Date?;
    
  //  var metaWeater : MetaWeater?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDate = startDate;
       // metaWeater = MetaWeater(startDate: startDate)
        
        //getData(completionHandler: handleData)
        
        print("asdasdasdas")
        
    }
    /*
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
    
    func getData(completionHandler: @escaping ([WeaterInfo]) -> ()) {
        metaWeater!.getData(completionHandler: completionHandler);
    }
 */
}

