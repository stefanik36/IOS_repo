//
//  Service.swift
//  WeatherApp02
//
//  Created by Daniel Stefanik on 10.10.2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import Foundation


class MetaWeater02Service{
    init(){
        self.maxRequests = 12;
    }
    
    init(maxRequests:Int){
        self.maxRequests = maxRequests;
    }
    
    var maxRequests:Int;
    var currentRequest:Int=1;
    var startDate:Date?;
    var weaterInfos:[Date: WeaterInfo]=[:];
    var isComplete:Bool = false;
    var calendar:Calendar = Calendar.current;
    var completionHandler: ((CityInfo) -> ())?;
    
    
    func findCity(name:String, completionHandler: @escaping ([String:String]) -> ()){
        let url = URL(string: "https://www.metaweather.com/api/location/search/?query=\(name)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("error:", error!)
                return
            }
            
            guard let data = data else {
                print("No data!")
                return
                
            }
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: AnyObject]]
            var dict:[String:String] = [:]
            for row in json{
                dict.updateValue(row["title"] as! String, forKey: "\((row["woeid"])!)")
            }
            completionHandler(dict)
        }
        task.resume()
    }
    
    func getData(cityIndex: String, cityName: String, startDate: Date, completionHandler: @escaping (CityInfo) -> ()) {
        self.startDate = startDate
        self.completionHandler = completionHandler
        isComplete = false;
        var date = startDate;
        for _ in 1...maxRequests {
            getFromOneDay(date: date, cityIndex: cityIndex, cityName: cityName, completionHandler: fill)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
    }
    
    func fill(
            json:[[String: AnyObject]],
            img:Data?,
            date:Date,
            cityIndex: String,
            cityName: String
        ){
      //  print("end index: \(json.endIndex) img: \(String(describing: img))")
     //   print("\(json.endIndex) && cr: \(currentRequest) mr: \(maxRequests)");
        
        if(json.endIndex>0){
            let wi = WeaterInfo(dictionary: json[json.endIndex/2])
            wi.image = img!
        //    print("wi.image: \(wi.image!)")
            weaterInfos.updateValue(wi, forKey: date)
            
        }
        if(currentRequest >= maxRequests && !isComplete){
            self.isComplete = true
            let first = weaterInfos.first?.value
//            print("_________________")
//            print((first?.image)!)
            self.completionHandler!(
                CityInfo(name: cityName, index: cityIndex, temp: (first?.theTemp)!, image: (first?.image)!, weaterInfos: weaterInfos)
            )
        }
        currentRequest = currentRequest+1
        
        /*
         if(json.endIndex>0 && currentRequest<maxRequests){
         let wi = WeaterInfo(dictionary: json[json.endIndex/2])
         wi.image = img
         print("\(img!.debugDescription)")
         weaterInfos.updateValue(wi, forKey: date)
         urrentRequest = currentRequest+1
         }else{
         self.completionHandler(weaterInfos)
         }
         */
    }
    
    private func getImageData(name: String) -> Data{
        let url = URL(string: "https://www.metaweather.com/static/img/weather/png/\(name).png")
//        print("IMG URL \(String(describing: url))")
        let data = try? Data(contentsOf: url!)
        return data!
    }
    
    private func getFromOneDay(
            date: Date,
            cityIndex: String,
            cityName: String,
            completionHandler: @escaping ([[String: AnyObject]],Data?,Date,String,String) -> ()
        ){
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let url = URL(string: "https://www.metaweather.com/api/location/\(cityIndex)/\(year)/\(month)/\(day)/")!
    //    print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("error:", error!)
                return
            }
            
            guard let data = data else {
                print("No data!")
                return
                
            }
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: AnyObject]]
            var img: Data? = nil;
            if(json.endIndex>0){
                img = self.getImageData(name: (json[json.endIndex/2]["weather_state_abbr"] as! String))
            }
            completionHandler(json,img,date,cityIndex,cityName)
        }
        task.resume()
    }
    
}









class MetaWeaterService{
    
    init(startDate: Date, completionHandler: @escaping ([Date: WeaterInfo]) -> ()) {
        self.startDate = startDate
        self.completionHandler = completionHandler
    }
    var maxRequests:Int=2;
    var currentRequest:Int=1;
    var startDate:Date;
    var weaterInfos:[Date: WeaterInfo]=[:];
    var isComplete:Bool = false;
    var calendar:Calendar = Calendar.current;
    
    var completionHandler: ([Date: WeaterInfo]) -> ();

    func getData(cityIndex: String) {
        isComplete = false;
        var date = startDate;
        for _ in 1...maxRequests {
            getFromOneDay(date: date,cityIndex: cityIndex ,completionHandler: fill)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
     }
     
    func fill(json:[[String: AnyObject]],img:Data?,date:Date){
        print("end index: \(json.endIndex) img: \(String(describing: img))")
        print("\(json.endIndex) && cr: \(currentRequest) mr: \(maxRequests)");
        
        if(json.endIndex>0){
            let wi = WeaterInfo(dictionary: json[json.endIndex/2])
            wi.image = img!
            print("wi.image: \(wi.image!)")
            weaterInfos.updateValue(wi, forKey: date)
            
        }
        if(currentRequest >= maxRequests && !isComplete){
            self.isComplete = true
            self.completionHandler(weaterInfos)
        }
        currentRequest = currentRequest+1
        
         /*
         if(json.endIndex>0 && currentRequest<maxRequests){
            let wi = WeaterInfo(dictionary: json[json.endIndex/2])
            wi.image = img
            print("\(img!.debugDescription)")
            weaterInfos.updateValue(wi, forKey: date)
            urrentRequest = currentRequest+1
         }else{
            self.completionHandler(weaterInfos)
         }
 */
     }
    
    private func getImageData(name: String) -> Data{
        let url = URL(string: "https://www.metaweather.com/static/img/weather/png/\(name).png")
        print("IMG URL \(String(describing: url))")
        let data = try? Data(contentsOf: url!)
        return data!
    }
     
     private func getFromOneDay(date:Date,cityIndex:String, completionHandler: @escaping ([[String: AnyObject]],Data?,Date) -> ()){
     
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let url = URL(string: "https://www.metaweather.com/api/location/\(cityIndex)/\(year)/\(month)/\(day)/")!
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
             guard error == nil else {
                print("error:", error!)
                return
             }
             
             guard let data = data else {
                print("No data!")
                return
             
             }
             let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: AnyObject]]
            var img: Data? = nil;
            if(json.endIndex>0){
                img = self.getImageData(name: (json[json.endIndex/2]["weather_state_abbr"] as! String))
            }
            completionHandler(json,img,date)
         }
         task.resume()
     }
    
}
