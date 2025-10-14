//
//  PrimaryStyleButton.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//

import UIKit

//Mother class to setup basic button style - color, shadow, cornerradius etc
class PrimaryStyleButton: UIButton {

    var associatedData: Any?
    let color = UIColor(resource: .teal20)
    
    private var innerShadowView: InnerShadowView?
    
    init() {
        super.init(frame: .zero)
        setupBackground()
        setupLabel()
        setupInnerShadow()
    }
    
    convenience init(title: String) {
        self.init()
        self.setTitle(title, for: .normal)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBackground()
        setupLabel()
        setupInnerShadow()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        innerShadowView?.frame = bounds
        bringSubviewToFront(titleLabel ?? UIView())
    }

    private func setupBackground() {
        backgroundColor = color
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLabel() {
        setTitleColor(.white, for: .normal)
    }
    
    private func setupInnerShadow() {
        let shadow = InnerShadowView(frame: bounds, color: UIColor.teal0, opacity: 0.2)
        shadow.isUserInteractionEnabled = false
        shadow.layer.cornerRadius = layer.cornerRadius
        addSubview(shadow)
        innerShadowView = shadow
    }
    
    override var isHighlighted: Bool {
        didSet {
//            UIView.animate(withDuration: 0.15) {
//                self.backgroundColor = self.isHighlighted
//                ? self.color.withAlphaComponent(0.8)
//                : self.color
//            }
            
            UIView.animate(withDuration: 0.1) {
                self.transform = self.isHighlighted
                    ? CGAffineTransform(scaleX: 0.97, y: 0.97)
                    : .identity
            }
        }
    }


}

#Preview {
    let bt = PrimaryStyleButton()
    bt.setTitle("Default", for: .normal)
    
    return bt
}
