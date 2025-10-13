//
//  StandardTextfield.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//
import UIKit

class StandardTextfield: UIView {
    
    var textfieldWidth: CGFloat
    var textfieldHeight: CGFloat
    var textfieldTitle: StandardLabel!
    var textfieldPlaceholder: String
    
    let textField = UITextField()
    
    init(width: CGFloat, height: CGFloat, title: StandardLabel, placeholder: String) {
        self.textfieldWidth = width
        self.textfieldHeight = height
        self.textfieldTitle = title
        self.textfieldPlaceholder = placeholder
        
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setup
    private func setupView() {
        // Title label
        textfieldTitle = StandardLabel(
            labelText: "Nome",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .regular
        )
        textfieldTitle.textAlignment = .left
        textfieldTitle.numberOfLines = 0
        textfieldTitle.lineBreakMode = .byWordWrapping
        textfieldTitle.translatesAutoresizingMaskIntoConstraints = false
        
        // TextField
        textField.placeholder = textfieldPlaceholder
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.borderStyle = .roundedRect
        textField.textColor = UIColor(resource: .black10)
        textField.backgroundColor = UIColor(resource: .white70)
        textField.widthAnchor.constraint(equalToConstant: textfieldWidth).isActive = true
        textField.heightAnchor.constraint(equalToConstant: textfieldHeight).isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textfieldTitle)
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textfieldTitle.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -8),
            textField.topAnchor.constraint(equalTo: textfieldTitle.bottomAnchor, constant: 8)
        ])
    }
}

import SwiftUI

private struct TextfieldPreviewWrapper: UIViewRepresentable {
    func updateUIView(_ uiView: StandardTextfield, context: Context) { }
    
    func makeUIView(context: Context) -> StandardTextfield {
        return StandardTextfield(
            width: 370,
            height: 38,
            title: StandardLabel(labelText: "Nome",
                                 labelFont: .sfPro,
                                 labelType: .title3,
                                 labelColor: UIColor(resource: .black10),
                                 labelWeight: .medium
                                ),
            placeholder: "Maria Clara"
        )
    }
}

#Preview {
    TextfieldPreviewWrapper()
        .padding()
}
