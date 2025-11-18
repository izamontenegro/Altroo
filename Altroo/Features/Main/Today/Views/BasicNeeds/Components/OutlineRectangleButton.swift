//
//  OutlineRectangleButton.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 18/11/25.
//
import UIKit

final class OutlineRectangleButton: UIButton {
    
    private let label: StandardLabel
    
    private let selectedBackground = UIColor.blue40
    private let unselectedBackground = UIColor.clear
    private let borderColor = UIColor.blue40
    private let selectedTextColor = UIColor.pureWhite
    private let unselectedTextColor = UIColor.blue40
    
    init(title: String) {
        self.label = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .blue40,
            labelWeight: .regular
        )
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.label = StandardLabel(
            labelText: "",
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .blue20,
            labelWeight: .regular
        )
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 24
        layer.borderWidth = 2
        layer.borderColor = borderColor.cgColor
        backgroundColor = unselectedBackground
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
        
        updateAppearance()
    }
    
    override var isSelected: Bool {
        didSet { updateAppearance() }
    }
    
    private func updateAppearance() {
        if isSelected {
            backgroundColor = selectedBackground
            label.labelColor = selectedTextColor
            label.labelWeight = .medium

        } else {
            backgroundColor = unselectedBackground
            label.labelColor = unselectedTextColor
            label.labelWeight = .regular
        }
        label.configureLabelColor()   // aplica internamente a cor
    }
}
