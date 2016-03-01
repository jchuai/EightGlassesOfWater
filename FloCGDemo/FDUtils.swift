//
//  FDUtils.swift
//  FloCGDemo
//
//  Created by Junna on 2/29/16.
//  Copyright © 2016 Junna. All rights reserved.
//

import Foundation
import UIKit

class FDUtils {
    
    class func schedulLocalNotification() {
        if let appDel =  UIApplication.sharedApplication().delegate as? AppDelegate {
            UIApplication.sharedApplication().cancelLocalNotification(appDel.localNotification)
            UIApplication.sharedApplication().scheduleLocalNotification(appDel.localNotification)
        }
    }
    
}

extension NSDate {
    func localDate() -> NSDate {
        let tz = NSTimeZone.defaultTimeZone()
        let seconds = tz.secondsFromGMTForDate(self)
        return NSDate(timeInterval: Double(seconds), sinceDate: self)
    }
}