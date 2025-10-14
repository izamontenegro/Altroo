//
//  InnerShadowView.swift
//  Altroo
//
//  Created by Raissa Parente on 30/09/25.
//

import UIKit

class InnerShadowView: UIView {
    
    private let shadowColor: UIColor
    private let shadowOpacity: Float
    
    private lazy var innerShadowLayer = CAShapeLayer()

    init(
        frame: CGRect,
        color: UIColor = .black,
        opacity: Float = 0.25
    ) {
        self.shadowColor = color
        self.shadowOpacity = opacity
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.shadowColor = .black
        self.shadowOpacity = 0.25
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        self.backgroundColor = .clear
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 6
        self.translatesAutoresizingMaskIntoConstraints = false
        
        innerShadowLayer.shadowColor = shadowColor.cgColor
        innerShadowLayer.shadowOffset = CGSize(width: 0, height: 4)
        innerShadowLayer.shadowOpacity = shadowOpacity
        innerShadowLayer.shadowRadius = 7
        innerShadowLayer.fillRule = .evenOdd
        innerShadowLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(innerShadowLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shadowPath = CGMutablePath()
        let inset = -innerShadowLayer.shadowRadius * 2.0
        
        shadowPath.addRect(bounds.insetBy(dx: inset, dy: inset))
        shadowPath.addRect(bounds)
        
        innerShadowLayer.path = shadowPath
        innerShadowLayer.shadowPath = CGPath(
            rect: CGRect(
                x: 0,
                y: bounds.height - 12,
                width: bounds.width,
                height: 10 + innerShadowLayer.shadowRadius * 2
            ),
            transform: nil
        )
    }
}
