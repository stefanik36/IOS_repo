//
//  Service.swift
//  WeatherApp02
//
//  Created by Daniel Stefanik on 10.10.2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import Foundation


class MetaWeaterService{
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
    
    
    func findCityLocation(name:String, completionHandler: @escaping (Double, Double) -> ()){
        let rawString = "https://www.metaweather.com/api/location/search/?query=\(name)"
        let urlString = rawString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: urlString!)!
        
        
        
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

            let latt_long = (json[0]["latt_long"]) as! String
            let trimmedString = latt_long.replacingOccurrences(of: " ", with: "")
            let latt_long_arr = trimmedString.components(separatedBy: ",")
            
            let latt = Double(latt_long_arr[0])
            let long = Double(latt_long_arr[1])
            completionHandler(latt!, long!)

            
        }
        task.resume()
    }
    
    
    func findCityByLocation(latitude:Double, longitude:Double, completionHandler: @escaping (String, String) -> ()){
        let url = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(latitude),\(longitude)")!
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
            
            let index = (json[0]["woeid"]) as! Int
            let name =  (json[0]["title"]) as! String
            
            completionHandler("\(index)", name)
        }
        task.resume()
    }
    
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
        
        if(json.endIndex>0){
            let wi = WeaterInfo(dictionary: json[json.endIndex/2])
            wi.image = img!
            weaterInfos.updateValue(wi, forKey: date)
            
        }
        if(currentRequest >= maxRequests && !isComplete){
            self.isComplete = true
            let first = weaterInfos.first?.value
            self.completionHandler!(
                CityInfo(name: cityName, index: cityIndex, temp: (first?.theTemp)!, image: (first?.image)!, weaterInfos: weaterInfos)
            )
        }
        currentRequest = currentRequest+1
    }
    
    private func getImageData(name: String) -> Data{
        let url = URL(string: "https://www.metaweather.com/static/img/weather/png/\(name).png")
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
