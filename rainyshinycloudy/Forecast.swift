//
//  Forecast.swift
//  RainyshinyCloudy
//
//  Created by Ibrahim Attalla on 5/26/18.
//  Copyright © 2018 Ibrahim Attalla. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    // this is avariable with no value to check it's input again

    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
    // this is a kind of safty to ensure that the data that getback from the sever is correct and not nil

    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var highTemp: String {
        if _highTemp == nil {
            _highTemp = ""
        }
        return _highTemp
    }
    
    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = ""
        }
        return _lowTemp
    }
    
    // here we create an init (constructor)  as a dictionary to pass data in it from class weatherVC from func downloadWeatherDetails

    init(weatherDict: Dictionary<String, AnyObject>) {
        
        // to get min and max temp from server
        if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject> {
            
            if let min = temp["min"] as? Double {
                
                let celsiusDegree = Int (min - 273.15)
                self._lowTemp = "\(celsiusDegree)˚"
                
                //  let degree:Double = Double( self._lowTemp)!
//                let degree = Int( self._lowTemp)!
//                print(degree)
            }
            
            if let max = temp["max"] as? Double {
                
                let celsiusDegree = Int (max - 273.15)
                self._highTemp = "\(celsiusDegree)˚"
                
                // let degree:Double = Double( self._highTemp)!
//                let degree = Int( self._highTemp)!
//
//                print(degree)
                
            }
            
        }
        // to get weather type and week days
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>] {
            
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
        }
        // before we get week days we create an extintion date under this class
        if let date = weatherDict["dt"] as? Double {
            // to convert the date to readable type
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._date = unixConvertedDate.dayOfTheWeek()
        }
    
    }
}

extension Date {
    //  this extention is going to allow us to get the day of week from date
    
    func dayOfTheWeek() -> String {
        // get object from dateFromatter
        let dateFormatter = DateFormatter()
        // to set the full name of the day of week like(sunday monday ......)
        dateFormatter.dateFormat = "EEEE"
        //and here we set self to get the date in this viewCotroller (weatherVC)
        return dateFormatter.string(from: self)
    }
}













