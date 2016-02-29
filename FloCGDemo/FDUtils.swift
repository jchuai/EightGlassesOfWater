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