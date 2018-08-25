//
//  Location.swift
//  RainyshinyCloudy
//
//  Created by Ibrahim Attalla on 5/27/18.
//  Copyright © 2018 Ibrahim Attalla. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
