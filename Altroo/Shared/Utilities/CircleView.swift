//
//  CircleView.swift
//  Altroo
//
//  Created by Raissa Parente on 29/09/25.
//

import UIKit

import UIKit

class CircleView: UIView {
    private let shapeLayer = CAShapeLayer()
    private let innerShadowLayer = CAShapeLayer()
    
    var fillColor: UIColor = .gray {
        didSet { shapeLayer.fillColor = fillColor.cgColor }
    }
    
    var strokeColor: UIColor = .clear {
        didSet { shapeLayer.strokeColor = strokeColor.cgColor }
    }
    
    var lineWidth: CGFloat = 0 {
        didSet { shapeLayer.lineWidth = lineWidth }
    }
    
    //inner shadow properties
    var innerShadowColor: UIColor = .black {
        didSet { innerShadowLayer.shadowColor = innerShadowColor.cgColor }
    }
    
    var innerShadowOpacity: Float = 0 {
        didSet { innerShadowLayer.shadowOpacity = innerShadowOpacity }
    }
    
    var innerShadowRadius: CGFloat = 0 {
        didSet { innerShadowLayer.shadowRadius = innerShadowRadius }
    }
    
    var innerShadowOffset: CGSize = .zero {
        didSet { innerShadowLayer.shadowOffset = innerShadowOffset }
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        //base circle
        layer.addSublayer(shapeLayer)
        shapeLayer.fillColor = fillColor.cgColor
        
        //inner shadow setup
        layer.addSublayer(innerShadowLayer)
        innerShadowLayer.fillRule = .evenOdd
        innerShadowLayer.shadowColor = innerShadowColor.cgColor
        innerShadowLayer.shadowOpacity = innerShadowOpacity
        innerShadowLayer.shadowRadius = innerShadowRadius
        innerShadowLayer.shadowOffset = innerShadowOffset
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //circle path
        let radius = min(bounds.width, bounds.height) / 2
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat.pi * 2,
            clockwise: true
        )
        shapeLayer.path = circlePath.cgPath
        
        //mask entire view so only circle area is visible
        let maskLayer = CAShapeLayer()
        maskLayer.path = circlePath.cgPath
        layer.mask = maskLayer
        
        //inner shadow path (inverted)
        let outerPath = UIBezierPath(rect: bounds.insetBy(dx: -bounds.width, dy: -bounds.height))

        outerPath.append(circlePath)
        outerPath.usesEvenOddFillRule = true
        
        innerShadowLayer.path = outerPath.cgPath
        innerShadowRadius = radius * 0.3
    }
}


#Preview {
    let circle = CircleView()
    circle.innerShadowColor = .black
    circle.innerShadowOpacity = 0.9
    circle.innerShadowRadius = 30
    
    return circle
}
