//
//  OverlayView.swift
//  MeasureMash
//
//  Created by Frank Gao on 4/8/23.
//

import UIKit

class OverlayView: UIView {
    private var drawOnce = false
    var location: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            drawOnce = true
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        // remove previous drawings
        if drawOnce {
            guard let sublayers = layer.sublayers else { return }
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
        
        // draw point
        let dotRadius: CGFloat = 5.0
        let dotRect = CGRect(x: location.x - dotRadius, y: location.y - dotRadius, width: dotRadius * 2, height: dotRadius * 2)
        
        let pointLayer = CAShapeLayer()
        let dotPath = UIBezierPath(ovalIn: dotRect)
        pointLayer.path = dotPath.cgPath
        pointLayer.lineWidth = 1.0
        pointLayer.strokeColor = UIColor.black.cgColor
        layer.addSublayer(pointLayer)
    }
}
