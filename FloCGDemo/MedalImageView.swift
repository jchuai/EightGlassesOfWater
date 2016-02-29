//
//  MedalImageView.swift
//  FloCGDemo
//
//  Created by Junna on 2/28/16.
//  Copyright © 2016 Junna. All rights reserved.
//

import Foundation
import UIKit

let size = CGSize(width: 120, height: 200)
let darkGoldColor = UIColor(red: 0.6, green: 0.5, blue: 0.15, alpha: 1.0)
let midGoldColor = UIColor(red: 0.86, green: 0.73, blue: 0.3, alpha: 1.0)
let lightGoldColor = UIColor(red: 1.0, green: 0.98, blue: 0.9, alpha: 1.0)

let beltWidth   : CGFloat = 40
let beltHeight  : CGFloat = 70
let beltSlope   : CGFloat = 38

let medalCenterX: CGFloat = beltWidth / 2 + beltSlope

let radius : CGFloat = 50
let roundX : CGFloat = medalCenterX - radius
let roundY : CGFloat = beltHeight + 2

class MedalImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .ScaleAspectFit
        self.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.0)
    }
    
    func showMedal(show: Bool) {
        if show {
            self.image = getMedalImage()
        } else {
            self.image = nil
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getMedalImage() -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        let shadow : UIColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        let shadowOffset = CGSize(width: 2.0, height: 2.0)
        let shadowBlurRadius : CGFloat = 5.0
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor)
        
        CGContextBeginTransparencyLayer(context, nil)
        protectDraw(context) { () -> Void in
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: 0, y: 0))
            path.addLineToPoint(CGPoint(x: beltWidth, y: 0))
            path.addLineToPoint(CGPoint(x: beltSlope + beltWidth, y: beltHeight))
            path.addLineToPoint(CGPoint(x: beltSlope, y: beltHeight))
            path.closePath()
            UIColor.redColor().setFill()
            path.fill()
        }
        
        protectDraw(context) { () -> Void in
            let offsetX : CGFloat = 25
            let cornerRadius: CGFloat = 4
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: roundX + offsetX, y: roundY + 8))
            path.addLineToPoint(CGPoint(x: roundX + offsetX, y: roundY - 10 + cornerRadius))
            path.addArcWithCenter(CGPoint(x: roundX + offsetX + cornerRadius, y: roundY - 10 + cornerRadius), radius: cornerRadius, startAngle: PI, endAngle: 1.5 * PI, clockwise: true)
            path.addLineToPoint(CGPoint(x: roundX + offsetX + (radius - offsetX) * 2 - cornerRadius, y: roundY - 10))
            path.addArcWithCenter(CGPoint(x: roundX + offsetX + (radius - offsetX) * 2 - cornerRadius, y: roundY - 10 + cornerRadius), radius: cornerRadius, startAngle: -0.5 * PI, endAngle: 0.0, clockwise: true)
            path.addLineToPoint(CGPoint(x: roundX + offsetX + (radius - offsetX) * 2, y: roundY + 8))
            path.lineWidth = 5.0
            darkGoldColor.setStroke()
            path.stroke()
        }
        
        protectDraw(context) { () -> Void in
            let path = UIBezierPath(ovalInRect: CGRect(x: roundX, y: roundY, width: radius * 2, height: radius * 2))
            path.addClip()
            let colors = [darkGoldColor.CGColor, midGoldColor.CGColor, lightGoldColor.CGColor]
            let space = CGColorSpaceCreateDeviceRGB()
            let stops : [CGFloat] = [0.0, 0.51, 1.0]
            let gradient = CGGradientCreateWithColors(space, colors, stops)
            CGContextDrawLinearGradient(context, gradient, CGPoint(x: roundX, y: roundY), CGPoint(x: roundX + 50, y: roundY + radius * 2 + 20), .DrawsBeforeStartLocation)
            var transform = CGAffineTransformMakeScale(0.8, 0.8)
            transform = CGAffineTransformTranslate(transform, 15, 30)
            path.lineWidth = 2.0
            path.applyTransform(transform)
            
            darkGoldColor.setStroke()
            path.stroke()
            
        }
        
        protectDraw(context) { () -> Void in
            let path = UIBezierPath()
            let pointX = medalCenterX + beltSlope - beltWidth / 2
            path.moveToPoint(CGPoint(x: pointX, y: 0.0))
            path.addLineToPoint(CGPoint(x: pointX + beltWidth, y: 0.0))
            path.addLineToPoint(CGPoint(x: beltSlope + beltWidth, y: beltHeight))
            path.addLineToPoint(CGPoint(x: beltSlope, y: beltHeight))
            path.closePath()
            UIColor.blueColor().setFill()
            path.fill()
        }
        
        protectDraw(context) { () -> Void in
            var numberRect = CGRect(x: 0, y: 0, width: 50, height: 50)
            numberRect.centerX = medalCenterX
            numberRect.centerY = roundY + radius
            let numberStr = "1"
            let font = UIFont(name: "Academy Engraved LET", size: 60)
            let textStyle = NSMutableParagraphStyle()
            textStyle.alignment = .Center
            let numberOneAttributes = [
                NSFontAttributeName: font!,
                NSForegroundColorAttributeName: darkGoldColor,
                NSParagraphStyleAttributeName: textStyle]
            (numberStr as NSString).drawInRect(numberRect, withAttributes: numberOneAttributes)
            
        }
        CGContextEndTransparencyLayer(context)
                
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}