//
//  OverlayView.swift
//  MeasureMash
//
//  Created by Frank Gao on 4/8/23.
//

import UIKit

class OverlayView: UIView {
    var points: [CGPoint] = [] {
        didSet {
            if points.count > 2 {
                points.remove(at: 0)
            }
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let sublayers = layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
        
        for p in points {
            drawDot(location: p)
        }
        
        if points.count == 2 {
            drawLine(start: points[0], toPoint: points[1])
        }
    }
    
    private func drawDot(location: CGPoint) {
        let dotRadius: CGFloat = 10.0
        let dotRect = CGRect(x: location.x - dotRadius, y: location.y - dotRadius, width: dotRadius * 2, height: dotRadius * 2)
        
        let pointLayer = CAShapeLayer()
        let dotPath = UIBezierPath(ovalIn: dotRect)
        pointLayer.path = dotPath.cgPath
        pointLayer.lineWidth = 1.0
        pointLayer.strokeColor = UIColor.white.cgColor
        layer.addSublayer(pointLayer)
    }
    
    private func drawLine(start: CGPoint, toPoint end: CGPoint) {
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2.0
        
        layer.addSublayer(shapeLayer)
    }
}
