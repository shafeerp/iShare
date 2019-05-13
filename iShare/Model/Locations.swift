//
//  Locations.swift
//  iShare
//
//  Created by Shafeer Puthalan on 11/05/19.
//  Copyright © 2019 Shafeer Puthalan. All rights reserved.
//

import Foundation
import CoreLocation

class Locations {

    var home : CLLocation
    var office : CLLocation
    var requestorHome : CLLocation
    var requestorOffice : CLLocation

    init(locations : [String:CLLocation]) {

        self.home = locations[Constants.Maps.ONE]!
        self.office = locations[Constants.Maps.TWO]!
        self.requestorHome = locations[Constants.Maps.THREE]!
        self.requestorOffice = locations[Constants.Maps.FOUR]!
    }
}
extension Locations {
    func calculateNormalDistance() -> Int {
        return Int(round((home.distance(from: office))))
    }
    
    func distanceIncludingRequestor() -> Int {
        return Int(round((home.distance(from: requestorHome))) + round((requestorHome.distance(from: requestorOffice))) + round((requestorOffice.distance(from: office))))
    }
}
