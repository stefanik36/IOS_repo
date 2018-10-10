//
//  Service.swift
//  WeatherApp02
//
//  Created by Klaudia Tutaj on 10.10.2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import Foundation

class MetaWeaterService{
    
    init(startDate: Date,  completionHandler: @escaping ([WeaterInfo]) -> ()) {
        self.startDate = startDate
        self.completionHandler = completionHandler
    }
    var maxRequests:Int=1;
    var currentRequest:Int=1;
    var startDate:Date;
    var weaterInfos:[WeaterInfo]=[];
    var isComplete:Bool = false;
    var calendar:Calendar = Calendar.current;
    
    var completionHandler: ([WeaterInfo]) -> ();
    
     func getData() {
        isComplete = false;
        var date = startDate;
        for _ in 1...maxRequests {
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            getFromOneDay(year: year,month: month,day: day,completionHandler: fill)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
     }
     
     func fill(json:[[String: AnyObject]]){
        print("end index: ")
        print(json.endIndex);
         if(json.endIndex>0 && currentRequest<maxRequests){
            weaterInfos.append(WeaterInfo(dictionary: json[json.endIndex/2]))
            currentRequest = currentRequest+1
         }else{
            self.completionHandler(weaterInfos)
         }
     }
     
     private func getFromOneDay(year:Int, month:Int, day:Int, completionHandler: @escaping ([[String: AnyObject]]) -> ()){
     
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
             completionHandler(json)
         }
         task.resume()
     }
    
}
