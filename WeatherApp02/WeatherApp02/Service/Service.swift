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
    var maxRequests:Int=30;
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
     
    func fill(json:[[String: AnyObject]],date:Date){
        print("end index: \(json.endIndex)")
        print("\(json.endIndex) && cr: \(currentRequest) mr: \(maxRequests)");
         if(json.endIndex>0 && currentRequest<maxRequests){
            let wi = WeaterInfo(dictionary: json[json.endIndex/2])
            weaterInfos.updateValue(wi, forKey: date)
            currentRequest = currentRequest+1
         }else{
            self.completionHandler(weaterInfos)
         }
     }
     
     private func getFromOneDay(date:Date, completionHandler: @escaping ([[String: AnyObject]],Date) -> ()){
     
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
             completionHandler(json,date)
         }
         task.resume()
     }
    
}
