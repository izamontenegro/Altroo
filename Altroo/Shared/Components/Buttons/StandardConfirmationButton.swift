//
//  StandardConfirmationButton.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//

import UIKit

final class StandardConfirmationButton: PrimaryStyleButton {
    
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
    
    private func setupButton() {
        setTitle(title, for: .normal)
        
        setTitleColor(.white, for: .normal)
        
        layer.cornerRadius = 22
        
        contentEdgeInsets = UIEdgeInsets(top: 8,
                                         left: 64,
                                         bottom: 8,
                                         right: 64)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupInnerShadow() {
        let shadow = InnerShadowView(frame: bounds,
                                     color: UIColor.teal0,
                                     opacity: 0.20)
        shadow.isUserInteractionEnabled = false
        shadow.layer.cornerRadius = layer.cornerRadius
        addSubview(shadow)
        innerShadowView = shadow
    }
}

#Preview {
    StandardConfirmationButton(title: "Adicionar")
}
