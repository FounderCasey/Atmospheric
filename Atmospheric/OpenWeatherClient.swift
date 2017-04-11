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
    
    func getWeatherForCoordinates(latitude: Double, longitude: Double) {
        let locationURL = URL(string: "\(Constants.baseURL)?APPID=\(Constants.apiKey)&units=imperial&lat=\(latitude)&lon=\(longitude)")!
        getWeatherFromClient(weatherRequest: locationURL as URL)
    }
    
    func getWeatherForCity(city: String) {
        let cityURL = URL(string: "\(Constants.baseURL)?APPID=\(Constants.apiKey)&units=imperial&q=\(city)")!
        getWeatherFromClient(weatherRequest: cityURL as URL)
    }
    
    func getWeatherFromClient(weatherRequest: URL) {
        let session = URLSession.shared
        let task = session.dataTask(with: weatherRequest) { (data, response, error) -> Void in
            if let error = error {
                self.delegate.errorWeather(error: error as NSError)
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let error = NSError(domain: "statusCode", code: ((response as? HTTPURLResponse)?.statusCode)!, userInfo: [NSLocalizedDescriptionKey: "Your request returned a status code other than 2xx!"])
                self.delegate.errorWeather(error: error)
                return
            }
            
            do {
                let parsedResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                
                guard let weather = Weather(weatherData: parsedResult) else {
                    return
                }
                self.delegate.successWeather(weather: weather)
            } catch let error as NSError {
                print("JSON error description: \(error.description)")
                self.delegate.errorWeather(error: error)
            }
        }
        task.resume()
    }
    
}

struct Constants {
    static let apiKey = "b3ae4048b5b7e39d8f9e9d9ecd64c2e6"
    static let baseURL = "http://api.openweathermap.org/data/2.5/weather"
}
