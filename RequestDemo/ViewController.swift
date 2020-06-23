//
//  ViewController.swift
//  RequestDemo
//
//  Created by Mousa Alwaraki on 4/25/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var locationManager: CLLocationManager!
    var lat:Double = 0
    var long:Double = 0
    let gradientLayer = CAGradientLayer()
    var sunShowing:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocation()
        setBackground()
        dayLabel.text = Date().getWeekdayString()
        
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.clear
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.white
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
    
    
    func setBackground() {
        backgroundView.layer.addSublayer(gradientLayer)
        if traitCollection.userInterfaceStyle == .light {
            setBlueGradientBackground()
        } else {
            setGreyGradientBackground()
        }
    }
    
    func checkLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    func setWeatherImage(to imageName: String) {
        if imageName == "Few clouds" || imageName == "Scattered clouds" {
            conditionImageView.image = UIImage(named: "Broken clouds")
        } else if imageName == "Shower rain" {
            conditionImageView.image = UIImage(named: "Rain")
        } else if imageName == "Clouds" {
        conditionImageView.image = UIImage(named: "Overcast clouds")
        } else {
            conditionImageView.image = UIImage(named: imageName)
        }
        if sunShowing == true {
            return
        } else {
            if imageName == "Clear" {
                conditionImageView.image = UIImage(named: "Moon")
            } else if imageName == "Broken clouds" || imageName == "Few clouds" || imageName == "Scattered clouds" {
                conditionImageView.image = UIImage(named: "Night cloud")
            } else if imageName == "Mist" {
                conditionImageView.image = UIImage(named: "Mist night")
            }
        }
    }
    
    func updateTemperatureLabel(to temperature: String) {
        tempLabel.text = temperature
    }
    
    func updateConditionLabel(to condition: String) {
        conditionLabel.text = condition
    }
    
    func setBlueGradientBackground() {
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    func setGreyGradientBackground() {
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    func getWeatherData(from url: String) {
        let taskWeather = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            guard let data = data, error == nil else {
                print("Something went wrong")
                return
            }
            // have data
            var result: ResponseWeather?
            do {
                result = try JSONDecoder().decode(ResponseWeather.self, from: data)
            } catch {
                print("failed to convert: \(error)")
            }
            guard let json = result else {
                return
            }
            
            let temperatureString = String(format: "%.0f", json.main?.temp ?? 0)
            let iconName = json.weather.first??.main ?? ""
            let condition = iconName
            let dayNight = condition.suffix(1)
            
            if dayNight == "d" {
                self.sunShowing = true
            } else {
                self.sunShowing = false
            }
            
            DispatchQueue.main.async {
                self.updateTemperatureLabel(to: temperatureString)
                self.setWeatherImage(to: iconName)
                self.updateConditionLabel(to: condition)
                print(iconName)
            }
        }
        taskWeather.resume()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        lat = (userLocation.coordinate.latitude)
        long = (userLocation.coordinate.longitude)
        
        print(lat)
        print(long)
        
        let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=723d228c131820cfbbede7827c3b6355&units=metric"
        getWeatherData(from: weatherUrl)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                
                self.countryNameLabel.text = "\(placemark.country!)"
                self.cityNameLabel.text = "\(placemark.locality!)"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}
