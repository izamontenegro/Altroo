//
//  StandardTextfield.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//
import UIKit

class StandardTextfield: UITextField {
    
    private var textfieldWidth: CGFloat
    private var textfieldHeight: CGFloat
    private var textfieldTitle: StandardLabel
    private var containerView = UIView()
    
    init(width: CGFloat, height: CGFloat, title: StandardLabel, placeholder: String) {
        self.textfieldWidth = width
        self.textfieldHeight = height
        self.textfieldTitle = title
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setup
    private func setupView() {

        self.textAlignment = .left
        self.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.borderStyle = .roundedRect
        self.textColor = UIColor(resource: .black10)
        self.backgroundColor = UIColor(resource: .white70)
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: textfieldWidth),
            self.heightAnchor.constraint(equalToConstant: textfieldHeight)
        ])
        
        textfieldTitle.translatesAutoresizingMaskIntoConstraints = false

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textfieldTitle)
        containerView.addSubview(self)
        
        NSLayoutConstraint.activate([
            textfieldTitle.topAnchor.constraint(equalTo: containerView.topAnchor),
            textfieldTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            textfieldTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            self.topAnchor.constraint(equalTo: textfieldTitle.bottomAnchor, constant: 8),
            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    func asView() -> UIView {
        return containerView
    }
}

import SwiftUI

private struct TextfieldPreviewWrapper: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let title = StandardLabel(
            labelText: "Nome",
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: UIColor(resource: .black10),
            labelWeight: .semibold
        )
        
        let field = StandardTextfield(
            width: 370,
            height: 38,
            title: title,
            placeholder: "Maria Clara"
        )
        
        return field.asView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    TextfieldPreviewWrapper()
        .padding()
}
