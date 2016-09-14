//
//  HelperUtilityClass.swift
//  goeuro_SM
//
//  Created by Sandeep-M on 12/09/16.
//  Copyright © 2016 Sandeep-Mukherjee. All rights reserved.
//

import UIKit
import AFNetworking.AFNetworkReachabilityManager




public class HelperUtilityClass: NSObject {
    
    public class var sharedInstance: HelperUtilityClass {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: HelperUtilityClass? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = HelperUtilityClass()
        }

        return Static.instance!
    }

    public func startMonitoringInternet()
    {
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock { (status: AFNetworkReachabilityStatus) -> Void in
            switch status {
            case .NotReachable:
                print("Not reachable")
                
            case .ReachableViaWiFi, .ReachableViaWWAN:
                print("Reachable")
                NSNotificationCenter.defaultCenter().postNotificationName("ActiveConnectionFound", object: nil)


            case .Unknown:
                print("Unknown")

            }
            
        }
        AFNetworkReachabilityManager.sharedManager().startMonitoring()

    }
    
    
    
    public func stringToDateTransformer(date: String) -> NSDate {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.dateFromString(date)!
    }
    
    public func dateToStringTransformer(date: NSDate) -> String {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(date)
    }
    
    public func getTimeDuration(arrivalTime:NSDate ,departureTime:NSDate)-> NSDate
    {
        let diff: NSTimeInterval = arrivalTime.timeIntervalSinceDate(departureTime)
        return NSDate(timeIntervalSinceReferenceDate: diff)
        
    }
    
    public func getImgURLwithSize(url:NSString, size:Float)-> NSString
    {
        let newString = url.stringByReplacingOccurrencesOfString("{size}", withString:NSString(format: "%.0f", size) as String)
        
        return newString
        
    }
    
   public func showHUD(vw: UIView) {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView.color! =  UIColor.redColor()

        activityView.tag = 999
        activityView.center = vw.center
        activityView.startAnimating()
        vw.addSubview(activityView)
    }
    
   public func removeHUD(vw: UIView) {
        for vw: UIView in vw.subviews {
            if vw.tag == 999 {
                vw.removeFromSuperview()
            }
        }
    }
    
    
}
