//
//  GraphView.swift
//  FloCGDemo
//
//  Created by Junna on 2/15/16.
//  Copyright © 2016 Junna. All rights reserved.
//

import Foundation
import UIKit

class GraphView: UIView {
    
    var graphPoints:[Int16] = [] {
        didSet {
            guard !graphPoints.isEmpty else {
                return
            }
            maxValue = max(graphPoints.maxElement()!, maxValue)
            averageValue = Int16((graphPoints.maxElement()! + graphPoints.minElement()!) / 2)
            setupSubviews()
        }
    }
    
    private var maxValue: Int16 = 8
    private var averageValue: Int16 = 0
    private let margin : CGFloat = 20.0
    private let topBorder: CGFloat = 60.0
    private let bottomBorder: CGFloat = 50.0

    private let startColor = UIColor(red: 250.0/255, green: 183.0/255, blue: 150.0/255, alpha: 1.0)
    private let endColor = UIColor(red: 252.0/255, green: 79.0/255, blue: 8.0/255, alpha: 1.0)
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        let width = rect.width
        let height = rect.height
        
        // clip corner
        let path = UIBezierPath(roundedRect: rect,
            byRoundingCorners: UIRectCorner.AllCorners,
            cornerRadii: CGSizeMake(8.0, 8.0))
        path.addClip()
        
        // draw background color
        let colors = [startColor.CGColor, endColor.CGColor]
        let colorStops: [CGFloat] = [0.0, 1.0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradientCreateWithColors(colorSpace, colors, colorStops)
        var startPoint = CGPoint.zero
        var endPoint = CGPointMake(0, rect.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, .DrawsBeforeStartLocation)
        
        protectDraw(context) { () -> Void in
            // draw count lines
            let graphPath = UIBezierPath()
            graphPath.moveToPoint(CGPointMake(self.columnXPoint(0, width: width), self.columnYPoint(0, height: height)))
            for i in 1 ..< self.graphPoints.count {
                let point = CGPointMake(self.columnXPoint(i, width: width), self.columnYPoint(i, height: height))
                graphPath.addLineToPoint(point)
            }
            UIColor.whiteColor().setStroke()
            graphPath.lineWidth = 2.0
            graphPath.stroke()
            
            // draw gradient graph
            graphPath.addLineToPoint(CGPoint(x: self.columnXPoint(self.graphPoints.count - 1, width: width), y: height - self.bottomBorder))
            graphPath.addLineToPoint(CGPoint(x: self.columnXPoint(0, width: width), y: height - self.bottomBorder))
            graphPath.closePath()
            graphPath.addClip()
            startPoint = CGPoint(x: self.margin, y: self.topBorder)
            endPoint = CGPoint(x: self.margin, y: height)
            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, .DrawsBeforeStartLocation)
        }
        
        // draw point circle
        protectDraw(context) { () -> Void in
            for i in 0 ..< self.graphPoints.count {
                let point = CGPoint(x: self.columnXPoint(i, width: width), y: self.columnYPoint(i, height: height))
                let circle = UIBezierPath(ovalInRect: CGRect(x: point.x - 2.5, y: point.y - 2.5, width: 5.0, height: 5.0))
                UIColor.whiteColor().setFill()
                circle.fill()
            }
        }
        
        protectDraw(context) { () -> Void in
            let linePath = UIBezierPath()
            linePath.moveToPoint(CGPoint(x: self.margin, y: self.topBorder))
            linePath.addLineToPoint(CGPoint(x: width - self.margin, y: self.topBorder))
            let centerY = (height - self.topBorder - self.bottomBorder) / 2 + self.topBorder
            linePath.moveToPoint(CGPoint(x: self.margin, y: centerY))
            linePath.addLineToPoint(CGPoint(x: width - self.margin, y: centerY))
            linePath.moveToPoint(CGPoint(x: self.margin, y: height - self.bottomBorder))
            linePath.addLineToPoint(CGPoint(x: width - self.margin, y: height - self.bottomBorder))
            UIColor(white: 1.0, alpha: 0.3).setStroke()
            linePath.lineWidth = 1.0
            linePath.stroke()
        }
    }
    
    func setupSubviews() {
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(titleLabel)
        self.addSubview(averageLabel)
        self.addSubview(topTagLabel)
        self.addSubview(bottomTagLabel)
        for label in dayLabels {
            self.addSubview(label)
        }
        
        averageLabel.text = "Average: \(averageValue)"
        averageLabel.sizeToFit()
        topTagLabel.text = "\(maxValue)"
        topTagLabel.sizeToFit()
        bottomTagLabel.text = "\(0)"
        bottomTagLabel.sizeToFit()
        
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin: CGFloat = 10
        titleLabel.top = 10
        titleLabel.left = margin
        
        averageLabel.top = titleLabel.bottom + 5
        averageLabel.left = margin
        
        topTagLabel.centerY = topBorder
        topTagLabel.left = self.width - self.margin + 5
        
        bottomTagLabel.centerY = self.height - bottomBorder
        bottomTagLabel.left = topTagLabel.left
        
        for i in 0 ..< dayLabels.count {
            let label = dayLabels[i]
            label.top = self.height - bottomBorder + 10
            label.centerX = self.columnXPoint(i, width: self.width)
        }
    }
    
    private func columnXPoint(column: Int, width: CGFloat) -> CGFloat {
        let space = (width - self.margin * 2) / CGFloat(self.graphPoints.count - 1)
        let x : CGFloat = CGFloat(column) * space + margin
        return x
    }
    
    private func columnYPoint(column: Int, height: CGFloat) -> CGFloat {
        let space = height - topBorder - bottomBorder
        let y : CGFloat =  topBorder + space * (1 - CGFloat(graphPoints[column]) / CGFloat(maxValue))
        return y
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(16)
        label.textColor = UIColor.whiteColor()
        label.text = "Water Drunk"
        label.sizeToFit()
        return label
    }()
    
    lazy var averageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.whiteColor()
        return label
    }()
    
    lazy var topTagLabel: UILabel = {
       return self.tagLabel()
    }()
    
    lazy var bottomTagLabel: UILabel = {
        return self.tagLabel()
    }()
    
    lazy var dayLabels: [UILabel] = {
        var list : [UILabel] = []
        let week = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        for i in 0 ..< week.count {
            let label = self.tagLabel()
            label.text = week[i]
            label.sizeToFit()
            list.append(label)
        }
        return list
    }()
    
    private func tagLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.whiteColor()
        return label
    }
}

extension UIView {
    func protectDraw(context: CGContextRef?,drawContext: () -> Void) {
        CGContextSaveGState(context)
        drawContext()
        CGContextRestoreGState(context)
    }
}