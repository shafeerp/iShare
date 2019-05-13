//
//  DirectionRequest.swift
//  iShare
//
//  Created by Shafeer Puthalan on 12/05/19.
//  Copyright © 2019 Shafeer Puthalan. All rights reserved.
//

import Foundation

class DirectionRequest : APIRequest {
    
    var method = RequestType.get
    
    var path = "json"
    
    var parameters: [String : String]
    
    init(locations : Locations, wayPoints : Bool) {
        let origin = "\(locations.home.coordinate.latitude),\(locations.home.coordinate.longitude)"
        let destination = "\(locations.office.coordinate.latitude),\(locations.office.coordinate.longitude)"
        if wayPoints {
            let stop1 = "\(locations.requestorHome.coordinate.latitude),\(locations.requestorHome.coordinate.longitude)"
            let stop2 = "\(locations.requestorOffice.coordinate.latitude),\(locations.requestorOffice.coordinate.longitude)"
            let waypoints = stop1 + "|" + stop2
            self.parameters = ["origin":"\(origin)","destination":"\(destination)","waypoints":"\(waypoints)","key":Constants.Maps.API_KEY]
        }
        else {
             self.parameters = ["origin":"\(origin)","destination":"\(destination)","key":Constants.Maps.API_KEY]
        }
       
        
        
    }
    
    
}
