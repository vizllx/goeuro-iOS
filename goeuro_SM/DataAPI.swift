//
//  DataAPI.swift
//  goeuro_SM
//
//  Created by Sandeep-M on 12/09/16.
//  Copyright © 2016 Sandeep-Mukherjee. All rights reserved.
//
//#pragma GCC diagnostic ignored "-Wdeprecated-declarations"


import UIKit
import AFNetworking


@objc public class DataAPI: NSObject {
    public func makeGet(urlString:NSString , completionHandler: (NSArray , Bool) -> Void)
    {
        

      
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.cachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        
        manager.GET(urlString as String, parameters: nil, success:
            { (operation, responseObject) -> Void in


                
                completionHandler(responseObject! as! NSArray,true)
                
            },failure: { (operation,error: NSError!) in
                
                  let iArray = []
                  completionHandler(iArray , false)
                
        })
        
    }
}
