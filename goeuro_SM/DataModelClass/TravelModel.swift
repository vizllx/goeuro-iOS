//
//  TravelModel.swift
//  goeuro_SM
//
//  Created by Sandeep-M on 12/09/16.
//  Copyright © 2016 Sandeep-Mukherjee. All rights reserved.
//

import UIKit
import JSONModel

class TravelModel: JSONModel {
    var id: NSString?
    var provider_logo: NSString?
    var price_in_euros: NSString?
    var departure_time: NSString?
    var arrival_time: NSString?
    var number_of_stops: NSString?
    var duration: NSString?

    
    
    
    override class func propertyIsOptional(propertyName: String!) -> Bool {
        return true
    }
    

}
