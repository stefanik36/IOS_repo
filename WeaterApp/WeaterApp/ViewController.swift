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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func prev(_ sender: Any) {
        
        
        //let url = URL(string: "https://www.metaweather.com/api/location/44418/2013/4/27/")!
        let url = URL(string: "https://www.metaweather.com/api/location/search/?query=london")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("error:", error!)
                return
            }
            
            guard let data = data else {
                print("asd")
                return
                
            }
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: AnyObject]]
            print(json)
            print(json[1]["id"]!)
            
        }
        
        task.resume()
        
    }
    @IBAction func next(_ sender: Any) {
        
    }
    
    func changeDate(){}
}

