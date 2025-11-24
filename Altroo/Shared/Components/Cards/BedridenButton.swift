//
//  BedridenButton.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//

import UIKit

class BedriddenButton: UIButton {
    
    var bedriddenState: BedriddenState
    
    var isSelectedState = false
    
    private var innerShadowView: InnerShadowView?
    
    private lazy var circleIcon = PulseIcon(iconName: bedriddenState.iconName, color: .blue30, iconColor: .pureWhite, shadowColor: .clear)

    private var checkIconView: UIImageView!
    
    private lazy var label = StandardLabel(
        labelText: (bedriddenState == .movement ? "Acamado Com Movimento" :"Acamado Sem Movimento"),
        labelFont: .sfPro,
        labelType: .callOut,
        labelColor: .blue30,
        labelWeight: .regular
    )
    
    init(frame: CGRect = .zero, bedriddenState: BedriddenState) {
        self.bedriddenState = bedriddenState
        super.init(frame: frame)
        
        setupBackground()
        setupInnerShadow()
    }
    
    convenience override init(frame: CGRect) {
        self.init(frame: frame, bedriddenState: .movement)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        innerShadowView?.frame = bounds
        
        for subview in subviews {
            subview.isUserInteractionEnabled = false
        }
    }
    // MARK: - click to change color
    func setSelectedState(_ selected: Bool) {
        isSelectedState = selected
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = selected ? UIColor(resource: .blue40) : UIColor(resource: .white70)
            let tint = selected ? UIColor(resource: .pureWhite) : UIColor(resource: .blue30)
            self.label.textColor = tint
            self.checkIconView.tintColor = tint
            self.circleIcon.color = selected ? UIColor(resource: .pureWhite) : .blue30
            self.circleIcon.iconColor = selected ? .blue40 : .white70
        }
    }
    
    @objc func toggleState() {
        setSelectedState(!isSelectedState)
    }
    
    // MARK: - Setup
    private func setupBackground() {
        backgroundColor = UIColor(resource: .white70)
        layer.cornerRadius = 8
        clipsToBounds = true
        
        let content = makeContent()
        addSubview(content)
        
        NSLayoutConstraint.activate([
            content.centerXAnchor.constraint(equalTo: centerXAnchor),
            content.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleIcon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            circleIcon.heightAnchor.constraint(equalTo: circleIcon.widthAnchor),
        ])
    }
    
    private func setupInnerShadow() {
        let shadow = InnerShadowView(frame: bounds,
                                     color: UIColor(resource: .blue70),
                                     opacity: 0.20)
        shadow.isUserInteractionEnabled = false
        shadow.layer.cornerRadius = layer.cornerRadius
        insertSubview(shadow, at: 0)
        innerShadowView = shadow
    }
    
    // MARK: - UI Construction
    private func makeContent() -> UIStackView {
        checkIconView = UIImageView(image: UIImage(systemName: bedriddenState.iconCheck))
        checkIconView.tintColor = UIColor(resource: .blue30)
        checkIconView.contentMode = .scaleAspectFit
        checkIconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkIconView.heightAnchor.constraint(equalToConstant: 27),
            checkIconView.widthAnchor.constraint(equalToConstant: 27)
        ])
        
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [circleIcon, checkIconView, label])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }
}

import SwiftUI

private struct BedriddenButtonPreview: UIViewRepresentable {
    let card: BedriddenButton
    
    func makeUIView(context: Context) -> BedriddenButton {
        return card
    }
    
    func updateUIView(_ uiView: BedriddenButton, context: Context) { }
}
