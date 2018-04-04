//
//  ViewController.swift
//  DarkSkyApp
//
//  Created by Borut on 18/03/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import UIKit
import CoreLocation
import Moya

class MainViewControler: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var imgHumidity: UIImageView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var bodyImage: UIImageView!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblLowTemp: UILabel!
    @IBOutlet weak var lblHighTemp: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var imgWind: UIImageView!
    @IBOutlet weak var imgPressure: UIImageView!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var weatherObjects: WeatherModel?
    let locationManager = CLLocationManager()
    let formatter = MeasurementFormatter()
    @IBOutlet weak var visualBlurEffect: UIVisualEffectView!
    var effect:UIVisualEffect!
    let providerWeather = MoyaProvider<WeatherApi>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.setGradientBackground(firstColor: Colors.dayUpColor, secondColor: Colors.dayDownColor)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        searchView.layer.cornerRadius = searchView.frame.size.width/15
        searchView.clipsToBounds = true
        
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapSearchView))
        mytapGestureRecognizer.numberOfTapsRequired = 1
        self.searchView.addGestureRecognizer(mytapGestureRecognizer)
    }
    
    // MARK: func for downloading data for user location
    func getWeatherDataUserLocation(lat: Float, long: Float){
        providerWeather.request(.cityLatAndLon(lat: lat, long: long)) { result in
            switch result {
            case let .success(response):
                do {
                    let decoder = JSONDecoder()
                    let weatherDownload = try decoder.decode(WeatherModel.self, from: response.data)
                    self.weatherObjects = weatherDownload
                    DispatchQueue.main.async {
                        self.updateUI()
                        self.activityIndicator.stopAnimating()
                        self.locationManager.stopUpdatingLocation()
                    }
                }catch let err  {
                    print(" there is some error: \(err)" )
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    // MARK: function for updateing UI
    func updateUI()  {
        if let icon = weatherObjects?.currently.icon {
             headerImage.image = UIImage(named: "header_image-\(icon)")
             bodyImage.image = UIImage(named: "body_image-\(icon)")
             gradleBySummary()
        }
        if let temp = weatherObjects?.currently.temperature {
        lblTemp.text = "\(temp)"
        }
        for weatherMinMax in (weatherObjects?.daily.data)!{
        lblLowTemp.text = "\(weatherMinMax.temperatureMin)"
        lblHighTemp.text = "\(weatherMinMax.temperatureMax)"
        }
        lblSummary.text = weatherObjects?.currently.summary
        if let humidity = weatherObjects?.currently.humidity {
            lblHumidity.text = "\(humidity)%"
        }
        if let windSpeed = weatherObjects?.currently.windSpeed {
            lblWindSpeed.text = "\(windSpeed)"
        }
        if let pressure = weatherObjects?.currently.pressure {
            lblPressure.text = "\(pressure)"
        }
        geocode(latitude: (weatherObjects?.latitude)!, longitude: (weatherObjects?.longitude)!, completion: { (placemark, error) in
                guard let placemark = placemark, error == nil else { return }
                DispatchQueue.main.async {
                    self.lblCity.text = placemark.locality
                }
            })
        self.activityIndicator.stopAnimating()
    }
    
    @objc func tapSearchView(_ recognizer: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.2) {
            self.effect = self.visualBlurEffect.effect
            self.visualBlurEffect.alpha = 1.0
        }
        self.performSegue(withIdentifier: SegueNames.segueSearch, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueNames.segueSearch {
            let destinationVC = segue.destination as! SearchViewController
            destinationVC.delegate = self
        }
        else if segue.identifier == SegueNames.segueSettings {
            let destinationVC = segue.destination as! SettingsViewController
            destinationVC.delegate = self
        }
    }
    @IBAction func btnSettingsPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.effect = self.visualBlurEffect.effect
            self.visualBlurEffect.alpha = 1.0
        }
    }
    func gradleBySummary()  {
        switch weatherObjects?.currently.icon {
        case "clear-day"?:
            view.setGradientBackground(firstColor: Colors.dayUpColor, secondColor: Colors.dayDownColor)
        case "clear-night"?:
            view.setGradientBackground(firstColor: Colors.nightUp, secondColor: Colors.nightDown)
        case "snow"?:
            view.setGradientBackground(firstColor: Colors.snowUp, secondColor: Colors.snowDown)
        case "fog"?:
            view.setGradientBackground(firstColor: Colors.fogUp, secondColor: Colors.fogDown)
        default:
            view.setGradientBackground(firstColor: Colors.dayUpColor, secondColor: Colors.dayDownColor)
        }
    }
}
// MARK: Search delegate extension
extension MainViewControler:SearchControllerDataDelegate {
    func sendBlurStatus(intForAlpha: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.effect = self.visualBlurEffect.effect
            self.visualBlurEffect.alpha = intForAlpha
        }
    }
    
    func sendLatLong(lat: String, long: String) {
        providerWeather.request(.delegateDataFromSearch(lat: lat, long: long)) { result in
            switch result {
            case let .success(response):
                do {
                    let decoder = JSONDecoder()
                    let weatherDownload = try decoder.decode(WeatherModel.self, from: response.data)
                    self.weatherObjects = weatherDownload
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                    
                }catch let err  {
                    print(" there is some error: \(err)" )
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    func sendString(data: String, intForAlpha: CGFloat,boolShowSearchBar: Bool ) {
        lblCity.text = data
        UIView.animate(withDuration: 0.2) {
            self.effect = self.visualBlurEffect.effect
            self.visualBlurEffect.alpha = intForAlpha
        }
    }
}
// MARK: Settings delegate
extension MainViewControler: SettingsControllerDataDelegate{
    func sendLatLongCity(lat: String, long: String) {
        providerWeather.request(.delegateDataFromSearch(lat: lat, long: long)) { result in
            switch result {
            case let .success(response):
                do {
                    let decoder = JSONDecoder()
                    let weatherDownload = try decoder.decode(WeatherModel.self, from: response.data)
                    self.weatherObjects = weatherDownload
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                    
                }catch let err  {
                    print(" there is some error: \(err)" )
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func sendBlurAndShowSearchBar(intForAlpha: CGFloat,boolShowSearchBar: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.effect = self.visualBlurEffect.effect
            self.visualBlurEffect.alpha = intForAlpha
        }
    }
    func sendMetricOrImperial(trueOrFalse: Bool) {
        if trueOrFalse == true {
            let mesurmentTempMain = Measurement(value: Double(weatherObjects!.currently.temperature), unit: UnitTemperature.fahrenheit)
                let temp = formatter.string(from: mesurmentTempMain)
                let roundTemp = (temp as NSString).floatValue
                lblTemp.text = String(format: "%.0f°",(roundTemp / 95) * 100)
            for timeObj in weatherObjects!.daily.data {
                    let mesurmentTempMin = Measurement(value: Double(timeObj.temperatureMin), unit: UnitTemperature.fahrenheit)
                    let tempMin = formatter.string(from: mesurmentTempMin)
                    let mesurmentTempMax = Measurement(value: Double(timeObj.temperatureMax), unit: UnitTemperature.fahrenheit)
                    let tempMax = formatter.string(from: mesurmentTempMax)
                    let roundLow = (tempMin as NSString).floatValue
                    let roundHigh = (tempMax as NSString).floatValue
                    lblLowTemp.text = String(format: "%.0f°",(roundLow / 95) * 100)
                    lblHighTemp.text = String(format: "%.0f°",(roundHigh / 95) * 100)
                }
        }
        else {
            let mesurmentTempMain = Measurement(value: Double(weatherObjects!.currently.temperature), unit: UnitTemperature.celsius)
                let temp = formatter.string(from: mesurmentTempMain)
                lblTemp.text = String(format: "%.2f", temp)

                for timeObj in weatherObjects!.daily.data {
                    let mesurmentTempMin = Measurement(value: Double(timeObj.temperatureMin), unit: UnitTemperature.celsius)
                    let tempMin = formatter.string(from: mesurmentTempMin)
                    let mesurmentTempMax = Measurement(value: Double(timeObj.temperatureMax), unit: UnitTemperature.celsius)
                    let tempMax = formatter.string(from: mesurmentTempMax)
                    lblLowTemp.text = tempMin
                    lblHighTemp.text = tempMax
                }
        }
    }
    func showOrRemoveCondions(sendString: String) {
        if sendString == conditionsData.hideHumidity {
            lblHumidity.isHidden = true
            imgHumidity.isHidden = true
        }
        else if sendString == conditionsData.showHumidity {
            lblHumidity.isHidden = false
            imgHumidity.isHidden = false
        }
        
        if sendString == conditionsData.hideWind {
            lblWindSpeed.isHidden = true
            imgWind.isHidden = true
        }
        else if sendString == conditionsData.showWind {
            lblWindSpeed.isHidden = false
            imgWind.isHidden = false
        }
        if sendString == conditionsData.hidePressure {
            lblPressure.isHidden = true
            imgPressure.isHidden = true
        }
        else if sendString == conditionsData.showPressure {
            lblPressure.isHidden = false
            imgPressure.isHidden = false
        }
    }
}
// MARK: Core location delegate
extension MainViewControler: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let locationsLongitude = location.coordinate.longitude
        let locationsLatitude = location.coordinate.latitude
        getWeatherDataUserLocation(lat: Float(locationsLatitude), long: Float(locationsLongitude))
    }
}
