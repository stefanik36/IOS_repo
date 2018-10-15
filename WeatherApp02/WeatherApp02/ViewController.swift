//
//  ViewController.swift
//  WeatherApp02
//
//  Created by Klaudia Tutaj on 10.10.2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var prevUI: UIButton!
    @IBOutlet weak var nextUI: UIButton!
    
    @IBOutlet weak var minTempUI: UITextField!
    @IBOutlet weak var tempUI: UITextField!
    @IBOutlet weak var maxTempUI: UITextField!
    
    @IBOutlet weak var windSpeedUI: UITextField!
    @IBOutlet weak var windDirectionUI: UITextField!
    @IBOutlet weak var windDirectionCompassUI: UITextField!
    
    @IBOutlet weak var dateUI: UILabel!
    
    
    
    
    var startDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!;
    var currentDate:Date?;
    var calendar:Calendar = Calendar.current;
    let dateFormatterPrint = DateFormatter()
    
   // var metaWeater : MetaWeaterService?;
    var weaterInfos: [Date: WeaterInfo]?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"
        
        let metaWeater = MetaWeaterService(
            startDate: startDate,
            completionHandler: handleData
        )
        metaWeater.getData();
        
    }
    
    @IBAction func nextButton(_ sender: Any) {
        setWeather(date: next())
        //minTempUI.insertText("asdasdfg")
    }
    @IBAction func prevButton(_ sender: Any) {
        setWeather(date: prev())
    }
    
    func handleData(weaterInfos: [Date: WeaterInfo]){
        self.weaterInfos = weaterInfos
        setFirst()
     }
    
    func next() -> Date{
        return calendar.date(byAdding: .day, value: 1, to: currentDate!)!
    }
    
    func prev() -> Date{
        return calendar.date(byAdding: .day, value: -1, to: currentDate!)!
    }
    
    func hasNext() -> Bool{
        return (self.weaterInfos?[next()] != nil)
    }
    
    func hasPrev() -> Bool{
        return (self.weaterInfos?[prev()] != nil)
    }
    
    func setButtonsAbility(){
        nextUI.isEnabled = hasNext();
        prevUI.isEnabled = hasPrev();
    }
    
    func setWeather(date:Date){
        let wi = self.weaterInfos?[date]
        self.currentDate = date
        
        DispatchQueue.main.async {
            
            self.dateUI.text = self.dateFormatterPrint.string(from: date)
            
            self.minTempUI.text = "\(wi?.minTemp ?? -666)"
            self.tempUI.text = "\(wi?.theTemp ?? -666)"
            self.maxTempUI.text = "\(wi?.maxTemp ?? -666)"
            
            self.windSpeedUI.text = "\(wi?.windSpeed ?? 666)"
            self.windDirectionUI.text = "\(wi?.windDirection ?? 666)"
            self.windDirectionCompassUI.text = "\(wi?.windDirectionCompass.debugDescription ?? "?")"
            
            
            self.setButtonsAbility();
        }
        
    }
    
    func setFirst(){
        //let first = self.weaterInfos?[(self.weaterInfos?.endIndex)!]
        setWeather(date: startDate)
        
        //print("handleData");
//        print(self.weaterInfos!.endIndex);
        for wi in self.weaterInfos!{
            print(self.dateFormatterPrint.string(from: wi.key));
        }
    }
}

