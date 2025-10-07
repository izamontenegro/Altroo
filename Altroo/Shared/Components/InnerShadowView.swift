//
//  InnerShadowView.swift
//  Altroo
//
//  Created by Raissa Parente on 30/09/25.
//
import UIKit

class InnerShadowView: UIView {
    
    private let shadowColor: UIColor

    lazy var innerShadowLayer = CAShapeLayer()

    init(frame: CGRect, color: UIColor) {
        self.shadowColor = color
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.shadowColor = .black
        super.init(coder: aDecoder)
        self.configure()
    }

    private func configure() {
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 6
        self.translatesAutoresizingMaskIntoConstraints = false
        
        innerShadowLayer.shadowColor = shadowColor.cgColor
        innerShadowLayer.shadowOffset = CGSize(width: 0, height: 4)
        innerShadowLayer.shadowOpacity = 0.25
        innerShadowLayer.shadowRadius = 7
        innerShadowLayer.fillRule = .evenOdd
        
        self.layer.addSublayer(self.innerShadowLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shadowPath = CGMutablePath()
        
        let inset = -self.innerShadowLayer.shadowRadius * 2.0
        shadowPath.addRect(self.bounds.insetBy(dx: inset, dy: inset))
        
        shadowPath.addRect(self.bounds)
        
        innerShadowLayer.path = shadowPath
        
        innerShadowLayer.shadowPath = CGPath(rect: CGRect(x: 0, y: bounds.height - 12, width: bounds.width, height: 10 + innerShadowLayer.shadowRadius * 2), transform: nil)
    }

}
