//
//  ComorbidityCard.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//
import UIKit

class ComorbidityButton: UIButton {
    
    var comorbidity: Comorbidity
    
    private var isSelectedState = false
    private var innerShadowView: InnerShadowView?
    private var iconView: PulseIcon!
    private var label: StandardLabel!
    
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
    }
    
    // MARK: - click to change color
    @objc private func toggleState() {
        isSelectedState.toggle()
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut]) {
            
            self.backgroundColor = self.isSelectedState ? UIColor(resource: .blue40)
                                                        : UIColor(resource: .white70)
            
            let tint = self.isSelectedState ? UIColor(resource: .pureWhite)
                                            : UIColor(resource: .blue30)
            self.label.textColor = tint
        }
    }
    // MARK: - Setup
    private func setupBackground() {
        backgroundColor = UIColor(resource: .white70)
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addTarget(self, action: #selector(toggleState), for: .touchUpInside)
        
        let content = makeContent()
        addSubview(content)
        
        NSLayoutConstraint.activate([
            content.centerXAnchor.constraint(equalTo: centerXAnchor),
            content.centerYAnchor.constraint(equalTo: centerYAnchor)
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
        
        iconView = PulseIcon(iconName: comorbidity.iconName,
                             color: UIColor(resource: .blue30),
                             iconColor: UIColor(resource: .pureWhite),
                             shadowColor: UIColor(resource: .blue60))
        iconView.heightAnchor.constraint(equalToConstant: 74).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 74).isActive = true
        
        label = StandardLabel(
            labelText: comorbidity.name,
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .blue30,
            labelWeight: .regular
        )
        label.textAlignment = .center
        label.numberOfLines = 0 // ← allows multiple lines
        label.lineBreakMode = .byWordWrapping // ← break between words
        label.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [iconView, label])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }
    
    //TODO: Take this to the viewmodel
    enum Comorbidity {
        case heartFailure, diabetes, hypertension
        
        var iconName: String {
            switch self {
            case .heartFailure:
                return "stethoscope"
            case .diabetes:
                return "syringe.fill"
            case .hypertension:
                return "cross.vial.fill"
            }
        }
        var name: String {
            switch self {
            case .heartFailure:
                return "Insuficiência Cardíaca"
            case .diabetes:
                return "Diabetes"
            case .hypertension:
                return "Hipertensão"

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

#Preview {
    let card = ComorbidityButton(comorbidity: .heartFailure)
    
    return ComorbidityCardPreview(card: card)
        .frame(width: 115, height: 190)
        .padding()
}
