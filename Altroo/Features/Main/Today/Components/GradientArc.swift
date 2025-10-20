//
//  GradientArc.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 15/10/25.
//

import UIKit

class GradientArcView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradient()
    }
    
    private func setupGradient() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let width = bounds.width
        let height: CGFloat = 160
        let curveHeight: CGFloat = 15
        
        // Arc path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height - curveHeight))
        path.addCurve(
            to: CGPoint(x: 0, y: height - curveHeight),
            controlPoint1: CGPoint(x: width * 0.75, y: height + curveHeight),
            controlPoint2: CGPoint(x: width * 0.25, y: height + curveHeight)
        )
        path.close()
        
        // Shadow layer
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = path.cgPath
        shadowLayer.fillColor = UIColor.blue50.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowOffset = CGSize(width: 0, height: 5)
        shadowLayer.shadowRadius = 10
        layer.addSublayer(shadowLayer)
        
        // Gradient layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [
            UIColor.blue10.cgColor,
            UIColor.blue50.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.mask = shapeLayer
        
        layer.addSublayer(gradient)
    }
}
