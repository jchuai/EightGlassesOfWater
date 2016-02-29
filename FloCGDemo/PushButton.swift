//
//  PushButton.swift
//  FloCGDemo
//
//  Created by Junna on 2/15/16.
//  Copyright © 2016 Junna. All rights reserved.
//

import Foundation
import UIKit

class PushButton: UIButton {
    enum Type {
        case Plus, Subtract
    }
    
    private var type: Type
    private var bgColor : UIColor
    
    override var highlighted: Bool {
        didSet {
            super.highlighted  = highlighted
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let path = UIBezierPath(ovalInRect: rect)
        bgColor.setFill()
        path.fill()
        
        let plusHeight: CGFloat = 3.0
        let plusWidth: CGFloat = min(rect.width, rect.height) * 0.6
        let plusPath = UIBezierPath()
        plusPath.lineWidth = plusHeight
        plusPath.moveToPoint(CGPointMake((rect.width - plusWidth) / 2, rect.height / 2))
        plusPath.addLineToPoint(CGPointMake(rect.width / 2 + plusWidth / 2, rect.height / 2))
        if type == .Plus {
            plusPath.moveToPoint(CGPointMake(rect.width / 2, rect.height / 2 - plusWidth / 2))
            plusPath.addLineToPoint(CGPointMake(rect.width / 2, rect.height / 2 + plusWidth / 2))
        }
        UIColor.whiteColor().setStroke()
        plusPath.stroke()
        
        if self.state == .Highlighted {
            let context = UIGraphicsGetCurrentContext()
            let startColor = UIColor.clearColor()
            let endColor = UIColor.blackColor().colorWithAlphaComponent(0.15)
            let colors = [startColor.CGColor, endColor.CGColor]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colorLocations : [CGFloat] = [0.0, 1.0]
            let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations)
            CGContextSetBlendMode(context, .Darken)
            CGContextDrawRadialGradient(context, gradient, rect.center, 0.0, rect.center, rect.width/2, [])
        }
    }
    
    init(frame: CGRect, type: Type = .Plus) {
        self.type = type
        switch type {
        case .Plus:
            bgColor = UIColor(red: 69.0/255, green: 169.0/255, blue: 165.0/255, alpha: 1.0)
        case .Subtract:
            bgColor = UIColor(red: 238.0/255, green: 77.0/255, blue: 77.0/255, alpha: 1.0)
        }
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}