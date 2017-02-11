//
//  WeatherViewController.swift
//  Atmospheric
//
//  Created by Casey Wilcox on 2/1/17.
//  Copyright © 2017 Casey Wilcox. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, OpenWeatherDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var upperImageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var noConnectionView: UIView!
    
    var client: OpenWeatherClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        client = OpenWeatherClient(delegate: self)
        cityTextField.delegate = self
        if tempLabel.text == "" {
            activityIndicator.startAnimating()
            client.getWeatherForCity(city: "San-Francisco")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noConnectionView.isHidden = true
    }

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    func successWeather(weather: Weather) {
        performUIUpdatesOnMain {
            self.noConnectionView.isHidden = true
            self.activityIndicator.stopAnimating()
            self.cityLabel.text = weather.city
            self.descriptionLabel.text = weather.description
            self.tempLabel.text = "\(Int(round(weather.currentTemp)))°"
            self.windLabel.text = "Wind: \(weather.windSpeed) mph"
            self.humidityLabel.text = "Humidity: \(weather.humidity)%"
            
            switch(weather.icon) {
                case "50d":
                    self.imageView.image = #imageLiteral(resourceName: "partiallyCloudy")
                case "50n":
                    self.imageView.image = #imageLiteral(resourceName: "nightCloudy")
                case "01d":
                    self.imageView.image = #imageLiteral(resourceName: "sun")
                case "01n":
                    self.imageView.image = #imageLiteral(resourceName: "night")
                case "02d":
                    self.imageView.image = #imageLiteral(resourceName: "partiallyCloudy")
                case "02n":
                    self.imageView.image = #imageLiteral(resourceName: "nightCloudy")
                case "03d", "03n", "04d", "04n":
                    self.imageView.image = #imageLiteral(resourceName: "cloudy")
                case "09d", "09n":
                    self.imageView.image = #imageLiteral(resourceName: "rain")
                case "10d", "10n":
                    self.imageView.image = #imageLiteral(resourceName: "lightRain")
                case "011d", "011n":
                    self.imageView.image = #imageLiteral(resourceName: "storm")
                case "13d", "13n":
                    self.imageView.image = #imageLiteral(resourceName: "snow")
                default: break
            }
            
            /* UPDATING IN V2
             if weather.icon.contains("d") {
             self.backgroundImageView.image = #imageLiteral(resourceName: "dayBackground")
             self.cityLabel.textColor = .black
             self.tempLabel.textColor = .black
             self.windLabel.textColor = .black
             self.humidityLabel.textColor = .black
             self.descriptionLabel.textColor = .black
             } else if weather.icon.contains("n") {
             self.backgroundImageView.image = #imageLiteral(resourceName: "nightBackground")
             self.cityLabel.textColor = .white
             self.tempLabel.textColor = .white
             self.windLabel.textColor = .white
             self.humidityLabel.textColor = .white
             self.descriptionLabel.textColor = .white
             }*/
        }
    }
    
    func errorWeather(error: NSError) {
        performUIUpdatesOnMain {
            self.activityIndicator.stopAnimating()
            self.displayAlert(title: "Connection Error", message: "Failed to get weather")
            self.noConnectionView.isHidden = false
        }
        print("")
        print("ErrorWeather: \(error)")
    }
    
    @IBAction func attributes(_ sender: Any) {
        displayAlert(title: "Attributes", message: "Weather Icons provided by: Eucalyp - FlatIcon\nList Icons provided by: Madebyoliver - FlatIcon")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField.text?.isEmpty)! {
            displayAlert(title: "Oops!", message: "Lets add some characters")
        } else {
            performUIUpdatesOnMain {
                self.activityIndicator.startAnimating()
            }
            client.getWeatherForCity(city: textField.text!.replacingOccurrences(of: " ", with: "-").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
            textField.text = ""
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension UIViewController {
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

