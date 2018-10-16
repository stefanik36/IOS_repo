//
//  Model.swift
//  WeatherApp02
//
//  Created by Klaudia Tutaj on 10.10.2018.
//  Copyright © 2018 Dainel Stefanik. All rights reserved.
//

import Foundation

class WeaterInfo {
    
    init() {}
    init(dictionary: [String: AnyObject]) {
        if let x = dictionary["id"] as? Int {self.id = x;}
        self.weatherStateName = (dictionary["weather_state_name"] as! String)
        self.weatherStateAbbr = (dictionary["weather_state_abbr"] as! String)
        if let x = dictionary["wind_speed"] as? Double {self.windSpeed = x;}
        if let x = dictionary["wind_direction"] as? Double {self.windDirection = x}
        //TODO
        //wi.windDirectionCompass = CompassPoint(json[0]["wind_direction_compass"] as! String)
        
        if let x = dictionary["min_temp"] as? Double {self.minTemp = x;}
        if let x = dictionary["the_temp"] as? Double {self.theTemp = x;}
        if let x = dictionary["max_temp"] as? Double {self.maxTemp = x;}
        
        if let x = dictionary["air_pressure"] as? Double {self.airPressure = x;}
        if let x = dictionary["humidity"] as? Double {self.humidity = x;}
        if let x = dictionary["visibility"] as? Double {self.visibility = x;}
        if let x = dictionary["predictability"] as? Int {self.predictability = x;}
    }
    var id: Int?;
    var applicableDate: Date?;
    
    var weatherStateName: String?;
    var weatherStateAbbr: String?;
    
    var windSpeed: Double?;
    var windDirection: Double?;
    var windDirectionCompass: CompassPoint?;
    
    var minTemp: Double?;
    var theTemp: Double?;
    var maxTemp: Double?;
    
    var airPressure: Double?;
    var humidity: Double?;
    var visibility: Double?;
    var predictability: Int?;
    
    var image: Data?;
    
    enum CompassPoint {
        case N
        case S
        case E
        case W
    }
}
