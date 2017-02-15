//
//  TodayViewController.swift
//  Atmospheric Weather
//
//  Created by Casey Wilcox on 2/14/17.
//  Copyright © 2017 Casey Wilcox. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, OpenWeatherDelegate {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var client: OpenWeatherClient!
    
    var cities = ["Paris", "San-Francisco", "Toronto", "London", "New-York", "Shanghai"]
    var random = arc4random_uniform(UInt32(5))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        client = OpenWeatherClient(delegate: self)
        client.getWeatherForCity(city: "\(cities[4])")
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func successWeather(weather: Weather) {
        performUIUpdatesOnMain {
            self.tempLabel.text = "\(Int(round(weather.currentTemp)))°"
            self.cityLabel.text = weather.city
            
            switch(weather.icon) {
            case "50d":
                self.imageView.image = #imageLiteral(resourceName: "wsuncloud")
            case "50n":
                self.imageView.image = #imageLiteral(resourceName: "wcloudynight")
            case "01d":
                self.imageView.image = #imageLiteral(resourceName: "wsun")
            case "01n":
                self.imageView.image = #imageLiteral(resourceName: "wmoon")
            case "02d":
                self.imageView.image = #imageLiteral(resourceName: "wsuncloud")
            case "02n":
                self.imageView.image = #imageLiteral(resourceName: "wcloudynight")
            case "03d", "03n", "04d", "04n":
                self.imageView.image = #imageLiteral(resourceName: "wcloudy")
            case "09d", "09n":
                self.imageView.image = #imageLiteral(resourceName: "wrain")
            case "10d", "10n":
                self.imageView.image = #imageLiteral(resourceName: "wlightrain")
            case "011d", "011n":
                self.imageView.image = #imageLiteral(resourceName: "wstorm")
            case "13d", "13n":
                self.imageView.image = #imageLiteral(resourceName: "wsnow")
            default: break
            }

        }
    }
    
    func errorWeather(error: NSError) {
        //
    }
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    
}
