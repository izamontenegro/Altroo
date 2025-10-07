//
//  BedridenButton.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//

import UIKit

class BedriddenButton: UIButton {
    var bedriddenState: BedriddenState
    
    init(frame: CGRect = .zero, bedriddenState: BedriddenState) {
        self.bedriddenState = bedriddenState
        
        super.init(frame: frame)
        
        setupBackground()
    }
    
    convenience override init(frame: CGRect) {
        self.init(frame: frame,
                  bedriddenState: .movement)
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
        let label = StandardLabel(labelText: "Bedridden", labelFont: .sfPro, labelType: .callOut, labelColor: .blue40, labelWeight: .medium)
        
        let icon = PulseIcon(iconName: bedriddenState.iconName, color: UIColor(resource: .blue30), shadowColor: UIColor(resource: .blue60))
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(label)
        
        return stack
    }
    
    //TODO: Take this to the viewmodel
    enum BedriddenState {
        case movement, noMovement
        
        var iconName: String {
            switch self {
            case .movement:
                return "bed.double.fill"
            case .noMovement:
                return "bed.double.fill"
            }
        }
    }
    
}

import SwiftUI
private struct BedriddenButtonPreview: UIViewRepresentable {
    let card: BedriddenButton
    
    func makeUIView(context: Context) -> BedriddenButton {
        return card
    }
    func updateUIView(_ uiView: BedriddenButton, context: Context) {
    }
}

#Preview {
    let card = BedriddenButton(bedriddenState: .movement)
    
    return BedriddenButtonPreview(card: card)
        .frame(width: 120, height: 190)
}
