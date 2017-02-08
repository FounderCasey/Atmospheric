//
//  Weather.swift
//  Atmospheric
//
//  Created by Casey Wilcox on 2/1/17.
//  Copyright © 2017 Casey Wilcox. All rights reserved.
//

import Foundation

struct Weather {
    var city: String
    var currentTemp: Double
    var humidity: Int
    var windSpeed: Double
    var icon: String
    var description: String
    
    var celsius: Double {
        get {
            return currentTemp - 273.15
        }
    }
    
    var fahrenheit: Double {
        get {
            return (currentTemp - 273.15) * 1.8 + 32
        }
    }
    
    init?(weatherData: [String: AnyObject]) {
        guard let cityCheck = weatherData["name"] as? String else {
            return nil
        }
        
        city = cityCheck
        
        let weatherDict = weatherData["weather"]![0] as! [String: AnyObject]
        description = weatherDict["description"] as! String
        icon = weatherDict["icon"] as! String
        
        let mainDict = weatherData["main"] as! [String: AnyObject]
        currentTemp = mainDict["temp"] as! Double
        humidity = mainDict["humidity"] as! Int
        
        let windDict = weatherData["wind"] as! [String: AnyObject]
        windSpeed = windDict["speed"] as! Double
    }
}
