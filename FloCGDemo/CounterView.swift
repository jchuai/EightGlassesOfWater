//
//  CounterView.swift
//  FloCGDemo
//
//  Created by Junna on 2/15/16.
//  Copyright © 2016 Junna. All rights reserved.
//

import Foundation
import UIKit

let PI : CGFloat = CGFloat(M_PI)

class CounterView: UIView {
    
    var counter : Int16 {
        didSet {
            if counter > maxCount {
                counter = maxCount
                return
            }
            
            if counter < 0 {
                counter = 0
                return
            }
            
            label.text = "\(counter)"
            var plusAngel = CGFloat(counter) * 1.5 * PI / 8
            plusAngel = plusAngel < minAngel ? minAngel : plusAngel
            outlineEndAngle = outlineStartAngle + plusAngel
            medal.showMedal(counter == 8)
            setNeedsDisplay()
        }
    }
    
    private let maxCount: Int16 = 8
    private let minAngel: CGFloat = 0.01
    private let arcColor = UIColor(red: 87.0/255, green: 218.0/255, blue: 213.0/255, alpha: 1.0)
    private let outlineColor = UIColor(red: 34.0/255, green: 110.0/255, blue: 100.0/255, alpha: 1.0)
    
    private var outlineStartAngle : CGFloat
    private var outlineEndAngle : CGFloat
    private let arcWidth: CGFloat = 76
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let center = rect.center
        let radius = min(rect.width, rect.height) / 2
        let startAngle : CGFloat = 3 * PI / 4
        let endAngle : CGFloat = PI / 4
        let arcPath = UIBezierPath(arcCenter: center, radius: radius - arcWidth / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        arcPath.lineWidth = arcWidth
        arcColor.setStroke()
        arcPath.stroke()
        
        let outlinePath = UIBezierPath(arcCenter: center, radius: radius - 2.5, startAngle: outlineStartAngle, endAngle: outlineEndAngle, clockwise: true)
        outlinePath.addArcWithCenter(center, radius: radius - arcWidth + 2.5, startAngle: outlineEndAngle, endAngle: outlineStartAngle, clockwise: false)
        outlinePath.lineWidth = 5.0
        outlinePath.closePath()
        outlineColor.setStroke()
        outlinePath.stroke()
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        outlineColor.setFill()
        let markerWidth: CGFloat = 5.0
        let markerHeight: CGFloat = 10.0
        let markerPath = UIBezierPath(rect: CGRect(x: rect.width/2 - markerHeight, y: -markerWidth/2, width: markerHeight, height: markerWidth))
        CGContextTranslateCTM(context, rect.width / 2, rect.height / 2)
        let perAngel = 3 * PI / 16
        for i in 0 ..< maxCount {
            CGContextSaveGState(context)
            let angel = PI / 4 - perAngel * CGFloat(i)
            CGContextRotateCTM(context, angel)
            markerPath.fill()
            CGContextRestoreGState(context)
        }
        CGContextRestoreGState(context)
    }
    
    override init(frame: CGRect) {
        counter = 0
        outlineStartAngle = 3 * PI / 4
        outlineEndAngle = outlineStartAngle + minAngel
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(label)
        self.addSubview(medal)
        medal.showMedal(false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.center = CGPointMake(self.width / 2, self.height / 2)
        medal.centerX = label.centerX
        medal.top = label.centerY + min(self.width, self.height) / 2 - arcWidth
    }
    
    lazy var label : UILabel = {
        let label = UILabel(frame: CGRectMake(0, 0, 44, 44))
        label.font = UIFont.systemFontOfSize(18)
        label.textAlignment = .Center
        label.text = "0"
        return label
    }()
    
    lazy var medal: MedalImageView = {
        let view = MedalImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        return view
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}