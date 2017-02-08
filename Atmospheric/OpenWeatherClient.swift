//
//  OpenWeatherClient.swift
//  Atmospheric
//
//  Created by Casey Wilcox on 2/1/17.
//  Copyright © 2017 Casey Wilcox. All rights reserved.
//

import Foundation

protocol OpenWeatherDelegate {
    func successWeather(weather: Weather)
    func errorWeather(error: NSError)
}

class OpenWeatherClient {
    
    private var delegate: OpenWeatherDelegate
    
    init(delegate: OpenWeatherDelegate) {
        self.delegate = delegate
    }
    
    func getWeatherForCity(city: String) {
        let urlString = "\(Constants.baseURL)?APPID=\(Constants.apiKey)&units=imperial&q=\(city)"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                self.delegate.errorWeather(error: error as NSError)
            } else {
                do {
                    let parsedResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                    let weather = Weather(weatherData: parsedResult)
                    
                    self.delegate.successWeather(weather: weather!)
                } catch let error as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    print("JSON error description: \(error.description)")
                    self.delegate.errorWeather(error: error)
                }
            }
        }
        task.resume()
    }
}

struct Constants {
    static let apiKey = "b3ae4048b5b7e39d8f9e9d9ecd64c2e6"
    static let baseURL = "http://api.openweathermap.org/data/2.5/weather"
}
