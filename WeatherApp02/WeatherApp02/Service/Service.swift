//
//  Service.swift
//  WeatherApp02
//
//  Created by Daniel Stefanik on 10.10.2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import Foundation

class MetaWeaterService{
    
    init(startDate: Date, completionHandler: @escaping ([Date: WeaterInfo]) -> ()) {
        self.startDate = startDate
        self.completionHandler = completionHandler
    }
    var maxRequests:Int=20;
    var currentRequest:Int=1;
    var startDate:Date;
    var weaterInfos:[Date: WeaterInfo]=[:];
    var isComplete:Bool = false;
    var calendar:Calendar = Calendar.current;
    
    var completionHandler: ([Date: WeaterInfo]) -> ();

     func getData() {
        isComplete = false;
        var date = startDate;
        for _ in 1...maxRequests {
            getFromOneDay(date: date,completionHandler: fill)
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
     
     private func getFromOneDay(date:Date, completionHandler: @escaping ([[String: AnyObject]],Data?,Date) -> ()){
     
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let url = URL(string: "https://www.metaweather.com/api/location/44418/\(year)/\(month)/\(day)/")!
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
