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
        color: UIColor = .teal0,
        opacity: Float = 0.20
    ) {
        self.shadowColor = color
        self.shadowOpacity = opacity
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.shadowColor = .teal0
        self.shadowOpacity = 0.20
        super.init(coder: aDecoder)
        self.configure()
    }

    private func configure() {
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        self.translatesAutoresizingMaskIntoConstraints = false
        
        innerShadowLayer.shadowColor = shadowColor.cgColor
        innerShadowLayer.shadowOffset = CGSize(width: 0, height: 5)
        innerShadowLayer.shadowOpacity = shadowOpacity
        innerShadowLayer.shadowRadius = 5
        innerShadowLayer.fillRule = .evenOdd
        
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

import SwiftUI

private struct InnerShadowViewPreview: UIViewRepresentable {
    func makeUIView(context: Context) -> InnerShadowView {
        // Cria a view UIKit
        let view = InnerShadowView(
            frame: CGRect(x: 0, y: 0, width: 200, height: 100),
            color: UIColor(resource: .teal0),
            opacity: 0.2
        )
        return view
    }
    
    func updateUIView(_ uiView: InnerShadowView, context: Context) { }
}

#Preview {
    InnerShadowViewPreview()
        .frame(width: 350, height: 200)
        .padding()
        .background(Color.black)
}
