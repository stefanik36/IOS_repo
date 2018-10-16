//
//  Service.swift
//  WeatherApp02
//
//  Created by Klaudia Tutaj on 10.10.2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import Foundation

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
    
    var dictionary: [String: String] = [
        "Snow": "s",
        "Sleet": "sl",
        "Hail": "h",
        "Thunderstorm": "t",
        "Heavy Rain": "hr",
        "Light Rain": "lr",
        "Showers": "s",
        "Heavy Cloud": "hc",
        "Light Cloud": "lc",
        "Clear": "c"
    ];
    
     func getData() {
        isComplete = false;
        var date = startDate;
        for _ in 1...maxRequests {
            getFromOneDay(date: date,completionHandler: fill)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
     }
     
    func fill(json:[[String: AnyObject]],img:Data?,date:Date){
        print("end index: \(json.endIndex)")
        print("\(json.endIndex) && cr: \(currentRequest) mr: \(maxRequests)");
        
        if(json.endIndex>0){
            let wi = WeaterInfo(dictionary: json[json.endIndex/2])
            wi.image = img
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
        print("1")
        let url = URL(string: "https://www.metaweather.com/static/img/weather/s.svg")
        print("2")
        let data = try? Data(contentsOf: url!)
        print("3")
        return data!
    }
     
     private func getFromOneDay(date:Date, completionHandler: @escaping ([[String: AnyObject]],Data?,Date) -> ()){
     
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let url = URL(string: "https://www.metaweather.com/api/location/44418/\(year)/\(month)/\(day)/")!
        print(url)
        //let url = URL(string: "https://www.metaweather.com/api/location/search/?query=london")!
        
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
                img = self.getImageData(name: (json[json.endIndex/2]["weather_state_name"] as! String))
            }
            completionHandler(json,img,date)
         }
         task.resume()
     }
    
}
