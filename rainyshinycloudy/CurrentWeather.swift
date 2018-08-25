//
//  CurrentWeather.swift
//  RainyshinyCloudy
//
//  Created by Ibrahim Attalla on 5/26/18.
//  Copyright © 2018 Ibrahim Attalla. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    // this is avariable with no value to check it's input again

    var _cityName: String!
    var _date: String!
    var _weatherType: String! 
    var _currentTemp: String!
    // this is a kind of safty to ensure that the data that getback from the sever is correct and not nill

    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        // but here before return the date set it in some type
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        // here we get the date from the system of device not server using func dateFormatter.string(from: Date())
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: String {
        if _currentTemp == nil {
            _currentTemp = ""
        }
        return _currentTemp
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        //Download Current Weather Data
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { response in
            let result = response.result
            print(CURRENT_WEATHER_URL)
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                    print(self._cityName)
                }
                
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                        print(self._weatherType)
                    }
                
                }
                
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    
                    if let currentTemperature = main["temp"] as? Double {
                    

                        let celsiusDegree = Int (currentTemperature - 273.15)
                        self._currentTemp = "\(celsiusDegree) ̊"
                        
                        let degree:String = self.currentTemp
                        print(degree)
                    }
                }
            }
            completed()
        }
    }
}












