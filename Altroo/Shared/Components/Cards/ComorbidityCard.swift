//
//  ComorbidityCard.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//
import UIKit

class ComorbidityCard: UIButton {
    var comorbidity: Comorbidity
    
    init(frame: CGRect = .zero, comorbidity: Comorbidity) {
        self.comorbidity = comorbidity
        
        super.init(frame: frame)
        
        setupBackground()
    }
    
    convenience override init(frame: CGRect) {
        self.init(frame: frame,
                  comorbidity: .diabetes)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupBackground() {
        backgroundColor = .lightGray
        layer.cornerRadius = 20
        
        let content = makeContent()
        addSubview(content)
        
        NSLayoutConstraint.activate([
            content.centerXAnchor.constraint(equalTo: centerXAnchor),
            content.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func makeContent() -> UIStackView {
        let label = StandardLabel(labelText: comorbidity.name, labelFont: .sfPro, labelType: .h2, labelColor: .blue, labelWeight: .medium)
        
        let icon = PulseIcon(iconName: comorbidity.iconName, color: UIColor(resource: .blue30), shadowColor: UIColor(resource: .blue60))
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(label)
        
        return stack
    }
    
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
                return "Heart Failure"
            case .diabetes:
                return "Diabetes"
            case .hypertension:
                return "Hypertension"

            }
        }
    }
    
}

import SwiftUI
private struct ComorbidityCardPreview: UIViewRepresentable {
    let card: ComorbidityCard
    
    func makeUIView(context: Context) -> ComorbidityCard {
        return card
    }
    func updateUIView(_ uiView: ComorbidityCard, context: Context) {
    }
}

#Preview {
    let card = ComorbidityCard(comorbidity: .hypertension)
    
    return ComorbidityCardPreview(card: card)
        .frame(width: 120, height: 190)
}
