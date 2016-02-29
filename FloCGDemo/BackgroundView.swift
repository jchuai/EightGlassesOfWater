//
//  BackgroundView.swift
//  FloCGDemo
//
//  Created by Junna on 2/28/16.
//  Copyright © 2016 Junna. All rights reserved.
//

import Foundation
import UIKit

class BackgroundView: UIView {
    
    private let darkColor = UIColor(red: 223/255, green: 1.0, blue: 247/255, alpha: 1.0)
    private let lightColor = UIColor(red: 1.0, green: 1.0, blue: 242/255, alpha: 1.0)
    private let patternSize: CGFloat = 30
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        
        let patternRect = CGSize(width: patternSize, height: patternSize)
        UIGraphicsBeginImageContextWithOptions(patternRect, true, 0.0)
        let imageContext = UIGraphicsGetCurrentContext()
        lightColor.setFill()
        CGContextFillRect(imageContext, CGRect(origin: CGPoint(x: 0, y: 0), size: patternRect))

        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: patternRect.width/2, y: 0.0))
        path.addLineToPoint(CGPoint(x: 0.0, y: patternRect.height/2))
        path.addLineToPoint(CGPoint(x: patternRect.width, y: patternRect.height/2))
        
        path.moveToPoint(CGPoint(x: 0.0, y: patternRect.height/2))
        path.addLineToPoint(CGPoint(x: patternRect.width/2, y: patternRect.height))
        path.addLineToPoint(CGPoint(x: 0, y: patternRect.height))
        
        path.moveToPoint(CGPoint(x: patternRect.width, y: patternRect.height/2))
        path.addLineToPoint(CGPoint(x: patternRect.width/2, y: patternRect.height))
        path.addLineToPoint(CGPoint(x: patternRect.width, y: patternRect.height))

        darkColor.setFill()
        path.fill()
        
        let image =  UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIColor(patternImage: image).setFill()
        CGContextFillRect(context, rect)
        
    }
}