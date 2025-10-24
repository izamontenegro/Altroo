//
// ProfileCareRecipient.swift
// Altroo
//
// Created by Layza Maria Rodrigues Carneiro on 12/10/25.
//

import UIKit

class ProfileCareRecipient: UIView {
    
    private static let defaultColor: UIColor = .teal20
    private static let defaultStrokeColor: UIColor = .blue80
    
    var name: String {
        didSet { updateLabel() }
    }
    
    var color: UIColor {
        didSet {
            backgroundColor = color
        }
    }
    
    var strokeColor: UIColor {
        didSet {
            layer.borderColor = strokeColor.cgColor
        }
    }
    
    private let label = StandardLabel(
        labelText: "",
        labelFont: .sfPro,
        labelType: .title1,
        labelColor: .pureWhite,
        labelWeight: .regular
    )
    
    init(
        name: String,
        color: UIColor = ProfileCareRecipient.defaultColor,
        strokeColor: UIColor = ProfileCareRecipient.defaultStrokeColor,
        frame: CGRect = .zero
    ) {
        self.name = name
        self.color = color
        self.strokeColor = strokeColor
        super.init(frame: frame)
        setupView()
        updateLabel()
    }
    
    required init?(coder: NSCoder) {
        self.name = ""
        self.color = ProfileCareRecipient.defaultColor
        self.strokeColor = ProfileCareRecipient.defaultStrokeColor
        super.init(coder: coder)
        setupView()
        updateLabel()
    }
    
    private func updateLabel() {
        label.text = name
    }
    
    private func setupView() {
        backgroundColor = color
        layer.borderColor = strokeColor.cgColor
        
        layer.borderWidth = 3.0
        layer.cornerRadius = 35
        clipsToBounds = true
        
        addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 70),
            heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}
//
//#Preview {
//    ProfileCareRecipient(name: "Karlisson Oliveira")
//}
