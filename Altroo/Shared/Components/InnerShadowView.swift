//
//  InnerShadowView.swift
//  Altroo
//
//  Created by Raissa Parente on 30/09/25.
//
import UIKit

class InnerShadowView: UIView {

    lazy var innerShadowLayer: CAShapeLayer = {
        let shadowLayer = CAShapeLayer()
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowRadius = 14
        shadowLayer.fillRule = .evenOdd
        return shadowLayer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }

    private func configure() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 6
        self.layer.addSublayer(self.innerShadowLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let shadowPath = CGMutablePath()
        let inset = -self.innerShadowLayer.shadowRadius * 2.0
        shadowPath.addRect(self.bounds.insetBy(dx: inset, dy: inset))
        shadowPath.addRect(self.bounds)
        self.innerShadowLayer.path = shadowPath
    }

}
