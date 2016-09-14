//
//  UIViewToast.swift
//  goeuro_SM
//
//  Created by Sandeep-M on 13/09/16.
//  Copyright © 2016 Sandeep-Mukherjee. All rights reserved.
//

import Foundation
import UIKit

let HRToastHorizontalMargin : CGFloat  =   10.0
let HRToastVerticalMargin   : CGFloat  =   10.0

let HRToastPositionDefault  =   "bottom"
let HRToastPositionTop      =   "top"
let HRToastPositionCenter   =   "center"

// activity
let HRToastActivityWidth  :  CGFloat  = 100.0
let HRToastActivityHeight :  CGFloat  = 100.0
let HRToastActivityPositionDefault    = "center"

// image size
let HRToastImageViewWidth :  CGFloat  = 80.0
let HRToastImageViewHeight:  CGFloat  = 80.0

// label setting
let HRToastMaxWidth       :  CGFloat  = 0.8;      // 80% of parent view width
let HRToastMaxHeight      :  CGFloat  = 0.8;
let HRToastFontSize       :  CGFloat  = 16.0
let HRToastMaxTitleLines              = 0
let HRToastMaxMessageLines            = 0

// shadow appearance
let HRToastShadowOpacity  : CGFloat   = 0.8
let HRToastShadowRadius   : CGFloat   = 6.0
let HRToastShadowOffset   : CGSize    = CGSizeMake(CGFloat(4.0), CGFloat(4.0))

let HRToastOpacity        : CGFloat   = 0.9
let HRToastCornerRadius   : CGFloat   = 10.0

var HRToastActivityView: UnsafePointer<UIView>    =   nil
var HRToastTimer: UnsafePointer<NSTimer>          =   nil
var HRToastView: UnsafePointer<UIView>            =   nil


// Color Scheme
let HRAppColor:UIColor = UIColor.redColor()
let HRAppColor_2:UIColor = UIColor.yellowColor()


let HRToastHidesOnTap       =   true
let HRToastDisplayShadow    =   false

//HRToast (UIView + Toast using Swift)

extension UIView {
    
    //public methods
    func makeToast(message msg: String) {
        self.makeToast(message: msg, duration: 0.7, position: HRToastPositionDefault)
    }
    
    func makeToast(message msg: String, duration: Double, position: AnyObject) {
        let toast = self.viewForMessage(msg, title: nil, image: nil)
        self.showToast(toast: toast!, duration: duration, position: position)
    }
    
    func makeToast(message msg: String, duration: Double, position: AnyObject, title: String) {
        let toast = self.viewForMessage(msg, title: title, image: nil)
        self.showToast(toast: toast!, duration: duration, position: position)
    }
    
    func makeToast(message msg: String, duration: Double, position: AnyObject, image: UIImage) {
        let toast = self.viewForMessage(msg, title: nil, image: image)
        self.showToast(toast: toast!, duration: duration, position: position)
    }
    
    func makeToast(message msg: String, duration: Double, position: AnyObject, title: String, image: UIImage) {
        let toast = self.viewForMessage(msg, title: title, image: image)
        self.showToast(toast: toast!, duration: duration, position: position)
    }
    
    func showToast(toast toast: UIView) {
        self.showToast(toast: toast, duration: 0.7, position: HRToastPositionDefault)
    }
    
    func showToast(toast toast: UIView, duration: Double, position: AnyObject) {
        let existToast = objc_getAssociatedObject(self, &HRToastView) as! UIView?
        if existToast != nil {
            if let timer: NSTimer = objc_getAssociatedObject(existToast, &HRToastTimer) as? NSTimer {
                timer.invalidate();
            }
            self.hideToast(toast: existToast!, force: false);
        }
        
        toast.center = self.centerPointForPosition(position, toast: toast)
        toast.alpha = 0.0
        
        if HRToastHidesOnTap {
            let tapRecognizer = UITapGestureRecognizer(target: toast, action: #selector(UIView.handleToastTapped(_:)))
            toast.addGestureRecognizer(tapRecognizer)
            toast.userInteractionEnabled = true;
            toast.exclusiveTouch = true;
        }
        
        self.addSubview(toast)
        objc_setAssociatedObject(self, &HRToastView, toast, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        UIView.animateWithDuration(0.7,
                                   delay: 0.0, options: ([.CurveEaseOut, .AllowUserInteraction]),
                                   animations: {
                                    toast.alpha = 1.0
            },
                                   completion: { (finished: Bool) in
                                    let timer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(UIView.toastTimerDidFinish(_:)), userInfo: toast, repeats: false)
                                    objc_setAssociatedObject(toast, &HRToastTimer, timer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        })
    }
    
    func makeToastActivity() {
        self.makeToastActivity(position: HRToastActivityPositionDefault)
    }
    
    func showToastActivity() {
        self.userInteractionEnabled = false
        self.makeToastActivity()
    }
    
    func removeToastActivity() {
        self.userInteractionEnabled = true
        self.hideToastActivity()
        
    }
    
    func makeToastActivityWithMessage(message msg: String){
        self.makeToastActivity(position: HRToastActivityPositionDefault, message: msg)
    }
    func makeToastActivityWithMessage(message msg: String,addOverlay: Bool){
        
        self.makeToastActivity(position: HRToastActivityPositionDefault, message: msg,addOverlay: true)
    }
    
    func makeToastActivity(position pos: AnyObject, message msg: String = "",addOverlay overlay: Bool = false) {
        let existingActivityView: UIView? = objc_getAssociatedObject(self, &HRToastActivityView) as? UIView
        if existingActivityView != nil { return }
        
        let activityView = UIView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        activityView.center = self.centerPointForPosition(pos, toast: activityView)
        activityView.alpha = 0.0
        activityView.autoresizingMask = ([.FlexibleLeftMargin, .FlexibleTopMargin, .FlexibleRightMargin, .FlexibleBottomMargin])
        activityView.layer.cornerRadius = HRToastCornerRadius
        
        if HRToastDisplayShadow {
            activityView.layer.shadowColor = UIColor.blackColor().CGColor
            activityView.layer.shadowOpacity = Float(HRToastShadowOpacity)
            activityView.layer.shadowRadius = HRToastShadowRadius
            activityView.layer.shadowOffset = HRToastShadowOffset
        }
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2)
        activityIndicatorView.color = HRAppColor
        activityView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        if (!msg.isEmpty){
            activityIndicatorView.frame.origin.y -= 10
            let activityMessageLabel = UILabel(frame: CGRectMake(activityView.bounds.origin.x, (activityIndicatorView.frame.origin.y + activityIndicatorView.frame.size.height + 10), activityView.bounds.size.width, 20))
            activityMessageLabel.textColor = UIColor.whiteColor()
            activityMessageLabel.font = (msg.characters.count<=10) ? UIFont(name:activityMessageLabel.font.fontName, size: 16) : UIFont(name:activityMessageLabel.font.fontName, size: 16)
            activityMessageLabel.textAlignment = .Center
            activityMessageLabel.text = msg + ".."
            if overlay {
                activityMessageLabel.textColor = UIColor.whiteColor()
                activityView.backgroundColor = HRAppColor.colorWithAlphaComponent(HRToastOpacity)
                activityIndicatorView.color = UIColor.whiteColor()
            }
            else {
                activityMessageLabel.textColor = HRAppColor
                activityView.backgroundColor = UIColor.clearColor()
                activityIndicatorView.color = HRAppColor
            }
            
            activityView.addSubview(activityMessageLabel)
            
        }
        
        self.addSubview(activityView)
        
        // associate activity view with self
        objc_setAssociatedObject(self, &HRToastActivityView, activityView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        UIView.animateWithDuration(0.7,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.CurveEaseOut,
                                   animations: {
                                    activityView.alpha = 1.0
            },
                                   completion: nil)
        self.userInteractionEnabled = false
    }
    
    func hideToastActivity() {
        self.userInteractionEnabled = true
        let existingActivityView = objc_getAssociatedObject(self, &HRToastActivityView) as! UIView?
        if existingActivityView == nil { return }
        UIView.animateWithDuration(0.7,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.CurveEaseOut,
                                   animations: {
                                    existingActivityView!.alpha = 0.0
            },
                                   completion: { (finished: Bool) in
                                    existingActivityView!.removeFromSuperview()
                                    objc_setAssociatedObject(self, &HRToastActivityView, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        })
    }
    
    /*
     *  private methods (helper)
     */
    func hideToast(toast toast: UIView) {
        self.userInteractionEnabled = true
        self.hideToast(toast: toast, force: false);
    }
    
    func hideToast(toast toast: UIView, force: Bool) {
        let completeClosure = { (finish: Bool) -> () in
            toast.removeFromSuperview()
            objc_setAssociatedObject(self, &HRToastTimer, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        if force {
            completeClosure(true)
        } else {
            UIView.animateWithDuration(0.7,
                                       delay: 0.0,
                                       options: ([.CurveEaseIn, .BeginFromCurrentState]),
                                       animations: {
                                        toast.alpha = 0.0
                },
                                       completion:completeClosure)
        }
    }
    
    func toastTimerDidFinish(timer: NSTimer) {
        self.hideToast(toast: timer.userInfo as! UIView)
    }
    
    func handleToastTapped(recognizer: UITapGestureRecognizer) {
        
        // var timer = objc_getAssociatedObject(self, &HRToastTimer) as! NSTimer
        // timer.invalidate()
        
        self.hideToast(toast: recognizer.view!)
    }
    
    func centerPointForPosition(position: AnyObject, toast: UIView) -> CGPoint {
        if position is String {
            let toastSize = toast.bounds.size
            let viewSize  = self.bounds.size
            if position.lowercaseString == HRToastPositionTop {
                return CGPointMake(viewSize.width/2, toastSize.height/2 + HRToastVerticalMargin)
            } else if position.lowercaseString == HRToastPositionDefault {
                return CGPointMake(viewSize.width/2, viewSize.height - toastSize.height - 15 - HRToastVerticalMargin)
            } else if position.lowercaseString == HRToastPositionCenter {
                return CGPointMake(viewSize.width/2, viewSize.height/2)
            }
        } else if position is NSValue {
            return position.CGPointValue
        }
        
        print("Warning: Invalid position for toast.")
        return self.centerPointForPosition(HRToastPositionDefault, toast: toast)
    }
    
    func viewForMessage(msg: String?, title: String?, image: UIImage?) -> UIView? {
        if msg == nil && title == nil && image == nil { return nil }
        
        var msgLabel: UILabel?
        var titleLabel: UILabel?
        var imageView: UIImageView?
        
        let wrapperView = UIView()
        wrapperView.autoresizingMask = ([.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleBottomMargin])
        wrapperView.layer.cornerRadius = HRToastCornerRadius
        wrapperView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(HRToastOpacity)
        
        if HRToastDisplayShadow {
            wrapperView.layer.shadowColor = UIColor.blackColor().CGColor
            wrapperView.layer.shadowOpacity = Float(HRToastShadowOpacity)
            wrapperView.layer.shadowRadius = HRToastShadowRadius
            wrapperView.layer.shadowOffset = HRToastShadowOffset
        }
        
        if image != nil {
            imageView = UIImageView(image: image)
            imageView!.contentMode = .ScaleAspectFit
            imageView!.frame = CGRectMake(HRToastHorizontalMargin, HRToastVerticalMargin, CGFloat(HRToastImageViewWidth), CGFloat(HRToastImageViewHeight))
        }
        
        var imageWidth: CGFloat, imageHeight: CGFloat, imageLeft: CGFloat
        if imageView != nil {
            imageWidth = imageView!.bounds.size.width
            imageHeight = imageView!.bounds.size.height
            imageLeft = HRToastHorizontalMargin
        } else {
            imageWidth  = 0.0; imageHeight = 0.0; imageLeft   = 0.0
        }
        
        if title != nil {
            titleLabel = UILabel()
            titleLabel!.numberOfLines = HRToastMaxTitleLines
            titleLabel!.font = UIFont.boldSystemFontOfSize(HRToastFontSize)
            titleLabel!.textAlignment = .Center
            titleLabel!.lineBreakMode = .ByWordWrapping
            titleLabel!.textColor = UIColor.whiteColor()
            titleLabel!.backgroundColor = UIColor.clearColor()
            titleLabel!.alpha = 1.0
            titleLabel!.text = title
            
            // size the title label according to the length of the text
            let maxSizeTitle = CGSizeMake((self.bounds.size.width * HRToastMaxWidth) - imageWidth, self.bounds.size.height * HRToastMaxHeight);
            let expectedHeight = title!.stringHeightWithFontSize(HRToastFontSize, width: maxSizeTitle.width)
            titleLabel!.frame = CGRectMake(0.0, 0.0, maxSizeTitle.width, expectedHeight)
        }
        
        if msg != nil {
            msgLabel = UILabel();
            msgLabel!.numberOfLines = HRToastMaxMessageLines
            msgLabel!.font = UIFont.systemFontOfSize(HRToastFontSize)
            msgLabel!.lineBreakMode = .ByWordWrapping
            msgLabel!.textAlignment = .Center
            msgLabel!.textColor = UIColor.whiteColor()
            msgLabel!.backgroundColor = UIColor.clearColor()
            msgLabel!.alpha = 1.0
            msgLabel!.text = msg
            
            let maxSizeMessage = CGSizeMake((self.bounds.size.width * HRToastMaxWidth) - imageWidth, self.bounds.size.height * HRToastMaxHeight)
            let expectedHeight = msg!.stringHeightWithFontSize(HRToastFontSize, width: maxSizeMessage.width)
            msgLabel!.frame = CGRectMake(0.0, 0.0, maxSizeMessage.width, expectedHeight)
        }
        
        var titleWidth: CGFloat, titleHeight: CGFloat, titleTop: CGFloat, titleLeft: CGFloat
        if titleLabel != nil {
            titleWidth = titleLabel!.bounds.size.width
            titleHeight = titleLabel!.bounds.size.height
            titleTop = HRToastVerticalMargin
            titleLeft = imageLeft + imageWidth + HRToastHorizontalMargin
        } else {
            titleWidth = 0.0; titleHeight = 0.0; titleTop = 0.0; titleLeft = 0.0
        }
        
        var msgWidth: CGFloat, msgHeight: CGFloat, msgTop: CGFloat, msgLeft: CGFloat
        if msgLabel != nil {
            msgWidth = msgLabel!.bounds.size.width
            msgHeight = msgLabel!.bounds.size.height
            msgTop = titleTop + titleHeight + HRToastVerticalMargin
            msgLeft = imageLeft + imageWidth + HRToastHorizontalMargin
        } else {
            msgWidth = 0.0; msgHeight = 0.0; msgTop = 0.0; msgLeft = 0.0
        }
        
        let largerWidth = max(titleWidth, msgWidth)
        let largerLeft  = max(titleLeft, msgLeft)
        
        // set wrapper view's frame
        let wrapperWidth  = max(imageWidth + HRToastHorizontalMargin * 2, largerLeft + largerWidth + HRToastHorizontalMargin)
        let wrapperHeight = max(msgTop + msgHeight + HRToastVerticalMargin, imageHeight + HRToastVerticalMargin * 2)
        wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight)
        
        // add subviews
        if titleLabel != nil {
            titleLabel!.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight)
            wrapperView.addSubview(titleLabel!)
        }
        if msgLabel != nil {
            msgLabel!.frame = CGRectMake(msgLeft, msgTop, msgWidth, msgHeight)
            wrapperView.addSubview(msgLabel!)
        }
        if imageView != nil {
            wrapperView.addSubview(imageView!)
        }
        
        return wrapperView
    }
    
}

extension String {
    
    func stringHeightWithFontSize(fontSize: CGFloat,width: CGFloat) -> CGFloat {
        let font = UIFont.systemFontOfSize(fontSize)
        let size = CGSizeMake(width, CGFloat.max)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        let attributes = [NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
    
}