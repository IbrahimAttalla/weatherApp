//
//  AppDelegate.swift
//  RainyshinyCloudy
//
//  Created by Ibrahim Attalla on 5/25/18.
//  Copyright © 2018 Ibrahim Attalla. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //create an object form corelocation and create an object with no value to store our location
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    // object from class currentweather , Forecast to get it's methods
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    
    // this array created to store all forecasts allover 10 days in it and using it in func downloadWeatherDetails
    var forecasts = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to applay the location in this viewController
        locationManager.delegate = self
        
        // ot get best location accuresy that you need
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //it only works when the app is actually active on the screen and use it (not like google that always Authorized )
        locationManager.requestWhenInUseAuthorization()
        //when any changes in location
        locationManager.startMonitoringSignificantLocationChanges()
        
        // to applay the tableView in this viewController
        tableView.delegate = self
        tableView.dataSource = self
        
        currentWeather = CurrentWeather()
        // we move this func from here to func locationAuthStatus untile we get our location
        //        currentweather.downloadWeatherDetails {
        //            // code UI update
        //            self.downloadWeatherData {
        //                self.updateMainUI()
        //            }
        //      }
    }
    
    
    // in view did appear while it appear the func called to get latitude and longitude befor evry thing
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            // if we authorized get location
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            currentWeather.downloadWeatherDetails {
                // code UI update

                self.downloadForecastData {
                    self.updateMainUI()
                }
            }
            // and here we save this location in something called singleton class
            //singleton is aclass use a static variables which can used through out entire app (like constants file that we store the constant in it to use allover the app)

        } else {
            //if we not authorized call this func again until we authorized ...
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        //Downloading forecast weather data for TableView
        Alamofire.request(FORECAST_URL).responseJSON { response in
            let result = response.result
            // evey request has response and every response has a result
            // the following line for print the JSON into console
            print(response)
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    //  here we create a for loop to get all data from sever and save into array named forecasts

                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                    // here to reload tableview after append  all data loop and delete the frist item becuase it is already exist at the top view
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                }
            }
            completed()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            // here we must pass the forecast object that need in func in weatherCell class
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherCell()
        }
    }
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
    
}

