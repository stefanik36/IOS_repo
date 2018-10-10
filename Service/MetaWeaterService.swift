//
//  MetaWeaterService.swift
//  WeaterApp
//
//  Created by Klaudia Tutaj on 10.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class MetaWeater{
    
    /*
    init(startDate: Date) {
        self.startDate = startDate
    }
    var startDate:Date;
    var weaterInfos:[WeaterInfo]=[];
    var isComplete:Bool = false;
    var calendar:Calendar = Calendar.current;
    
    
    func getData(completionHandler: @escaping ([WeaterInfo]) -> ()) {
        isComplete = false;
        var date = startDate;
        while isComplete {
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            getFromOneDay(year: year,month: month,day: day,completionHandler: fill)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        
        completionHandler(weaterInfos)
    }
    
    func fill(json:[[String: AnyObject]]){
        if(json.endIndex>0){
           weaterInfos.append(WeaterInfo(dictionary: json[json.endIndex/2]))
        }else{
            isComplete = true;
        }
    }
    
    private func getFromOneDay(year:Int, month:Int, day:Int, completionHandler: @escaping ([[String: AnyObject]]) -> ()){
        
        let url = URL(string: "https://www.metaweather.com/api/location/44418/\(year)/\(month)/\(day)/")!
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
 */
}
