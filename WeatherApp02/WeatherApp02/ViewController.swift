//
//  ViewController.swift
//  WeatherApp02
//
//  Created by Daniel Stefanik on 10.10.2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var minTempUI: UITextField!
    @IBOutlet weak var tempUI: UITextField!
    @IBOutlet weak var maxTempUI: UITextField!
    
    @IBOutlet weak var windSpeedUI: UITextField!
    @IBOutlet weak var windDirectionUI: UITextField!
    @IBOutlet weak var windDirectionCompassUI: UITextField!
    
    @IBOutlet weak var airPressureUI: UITextField!
    @IBOutlet weak var humidityUI: UITextField!
    @IBOutlet weak var visibilityUI: UITextField!
    @IBOutlet weak var predictabilityUI: UITextField!
    
    @IBOutlet weak var weatherStateUI: UILabel!
    @IBOutlet weak var imageUI: UIImageView!
    
    //@IBOutlet weak var dateUI: UILabel!
    @IBOutlet weak var dateUI: UILabel!
    @IBOutlet weak var prevUI: UIButton!
    @IBOutlet weak var nextUI: UIButton!
    
    var overlay : UIView?
    
    var startDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!;
    var currentDate:Date?;
    var calendar:Calendar = Calendar.current;
    let dateFormatterPrint = DateFormatter()
    
   // var metaWeater : MetaWeaterService?;
    var weaterInfos: [Date: WeaterInfo]?;
    
    func loadingPanel(){
        
        overlay = UIView(frame: view.frame)
        let title = UILabel()
        title.text = "Loading..."
        title.numberOfLines = 0
        title.textAlignment = .center
        title.textColor = UIColor.white
        title.sizeToFit()
        title.center = overlay!.center
        overlay!.addSubview(title)
        
        overlay!.backgroundColor = UIColor.black
        overlay!.alpha = 0.8
        view.addSubview(overlay!)

    }
    
    func prepareView(){
        self.minTempUI.textAlignment = .center
        self.tempUI.textAlignment = .center
        self.maxTempUI.textAlignment = .center
        
        self.windSpeedUI.textAlignment = .center
        self.windDirectionUI.textAlignment = .center
        self.windDirectionCompassUI.textAlignment = .center
        
        self.airPressureUI.textAlignment = .center
        self.humidityUI.textAlignment = .center
        self.visibilityUI.textAlignment = .center
        self.predictabilityUI.textAlignment = .center
        
        self.weatherStateUI.textAlignment = .center
        self.dateUI.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingPanel()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"
        let metaWeater = MetaWeaterService(
            startDate: startDate,
            completionHandler: handleData
        )
        metaWeater.getData();
        prepareView();
    }
    
    @IBAction func nextButton(_ sender: Any) {
        setWeather(date: next())
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
        
        print("set weather \(self.dateFormatterPrint.string(from: date)) \(String(describing: wi)) img:")
        print((wi?.image)!)
        
        DispatchQueue.main.async {
            self.overlay?.removeFromSuperview()
//            self.dismiss(animated: false, completion: nil)
            
            
            //self.minTempUI.text = "\(String(format:"%.1f", (wi?.minTemp)!))"
            self.minTempUI.text = (wi?.minTemp).map{"\(String(format:"%.1f", $0))"} ?? ""
      
            self.tempUI.text = (wi?.theTemp).map{"\(String(format:"%.1f", $0))"} ?? ""
            self.maxTempUI.text = (wi?.maxTemp).map{"\(String(format:"%.1f", $0))"} ?? ""
            
            self.windSpeedUI.text = (wi?.windSpeed).map{"\(String(format:"%.1f", $0))"} ?? ""
            self.windDirectionUI.text = (wi?.windDirection).map{"\(String(format:"%.1f", $0))"} ?? ""
            self.windDirectionCompassUI.text = (wi?.windDirectionCompass).map{"\($0)"} ?? ""
            
            self.airPressureUI.text = (wi?.airPressure).map{"\(String(format:"%.1f", $0))"} ?? ""
            self.humidityUI.text = (wi?.humidity).map{"\(String(format:"%.1f", $0))"} ?? ""
            self.visibilityUI.text = (wi?.visibility).map{"\(String(format:"%.1f", $0))"} ?? ""
            self.predictabilityUI.text = (wi?.predictability).map{"\(String(format:"%.1f", $0))"} ?? ""
         
            self.weatherStateUI.text = (wi?.weatherStateName).map{"\($0)"} ?? ""

            if let x = (wi?.image).map({UIImage(data: $0)})  {self.imageUI.image = x;}
            
            self.dateUI.text = self.dateFormatterPrint.string(from: date)
            
            self.setButtonsAbility();
        }
        
    }
    
    func setFirst(){
        setWeather(date: startDate)
    }
}

