//
//  WideRectangleButton.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//
import UIKit

class WideRectangleButton: PrimaryStyleButton {
    
    var title: String
    private var innerShadowView: InnerShadowView?

    init(title: String) {
        self.title = title
        super.init()
        
        setupButton()
        setupInnerShadow()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        innerShadowView?.frame = bounds
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let superview = self.superview else { return }

        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor,
                                          constant: 16),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor,
                                           constant: -16)
        ])
    }

    private func setupButton() {
        backgroundColor = color

        setTitle(title, for: .normal)
        
        setTitleColor(.white, for: .normal)
                
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    private func setupInnerShadow() {
        let shadow = InnerShadowView(frame: bounds, color: UIColor.teal0, opacity: 0.20)
        shadow.isUserInteractionEnabled = false
        shadow.layer.cornerRadius = layer.cornerRadius
        addSubview(shadow)
        innerShadowView = shadow
    }
}

#Preview {
    WideRectangleButton(title: "O dia todo")
}
