//
//  ComorbidityCard.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//
import UIKit

class ComorbidityButton: UIButton {
    
    var comorbidity: Comorbidity
    
    private(set) var isSelectedState = false
    private var innerShadowView: InnerShadowView?

    private lazy var circleIcon = PulseIcon(iconName: comorbidity.iconName, color: .blue30, iconColor: .pureWhite, shadowColor: .clear)
    private lazy var label = StandardLabel(
        labelText: comorbidity.name,
        labelFont: .sfPro,
        labelType: .callOut,
        labelColor: .blue30,
        labelWeight: .regular
    )
    
    init(frame: CGRect = .zero, comorbidity: Comorbidity) {
        self.comorbidity = comorbidity
        super.init(frame: frame)
        
        setupBackground()
        setupInnerShadow()
    }
    
    convenience override init(frame: CGRect) {
        self.init(frame: frame, comorbidity: .diabetes)
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
    @objc func toggleState() {
        isSelectedState.toggle()
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut]) {
            
            self.backgroundColor = self.isSelectedState ? UIColor(resource: .blue40)
                                                        : UIColor(resource: .white70)
            
            let tint = self.isSelectedState ? UIColor(resource: .pureWhite)
                                            : UIColor(resource: .blue30)
            self.label.textColor = tint
            self.circleIcon.color = self.isSelectedState ? .pureWhite : .blue30
            self.circleIcon.iconColor = self.isSelectedState ? .blue40 : .white70
        }
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
            circleIcon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.55),
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

        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(circleIcon)
        stack.addArrangedSubview(label)
        
        return stack
    }
    
    //TODO: Take this to the viewmodel
    enum Comorbidity {
        case circulatory, diabetes, cognition
        
        var iconName: String {
            switch self {
            case .circulatory:
                return "stethoscope"
            case .diabetes:
                return "syringe.fill"
            case .cognition:
                return "brain.fill"
            }
        }
        var name: String {
            switch self {
            case .circulatory:
                return "Doenças Circulatórias"
            case .diabetes:
                return "Diabetes"
            case .cognition:
                return "Alterações Cognitivas"

            }
        }
    }
}

import SwiftUI

private struct ComorbidityCardPreview: UIViewRepresentable {
    let card: ComorbidityButton
    
    func makeUIView(context: Context) -> ComorbidityButton {
        return card
    }
    
    func updateUIView(_ uiView: ComorbidityButton, context: Context) { }
}
