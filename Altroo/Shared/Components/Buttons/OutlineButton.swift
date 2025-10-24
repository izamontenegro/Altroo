//
//  OutlineButton.swift
//  Altroo
//
//  Created by Raissa Parente on 15/10/25.
//
import UIKit

final class OutlineButton: UIButton {
    
    private let label = StandardLabel(
        labelText: "",
        labelFont: .sfPro,
        labelType: .title2,
        labelColor: .teal10,
        labelWeight: .semibold
    )
    
    var color: UIColor
    
    init(title: String, color: UIColor) {
        self.color = color
        super.init(frame: .zero)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        self.color = .teal10
        super.init(coder: coder)
        setupButton(title: "")
    }
    
    private func setupButton(title: String) {
        backgroundColor = .clear
        layer.cornerRadius = 23
        layer.borderWidth = 2
        layer.borderColor = color.cgColor
        
        heightAnchor.constraint(equalToConstant: 46).isActive = true
        widthAnchor.constraint(equalToConstant: 230).isActive = true
        
        label.text = title
        label.labelColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Public funcs
    func updateTitle(_ title: String) {
        label.updateLabelText(title)
    }
    
    func updateColor(_ color: UIColor) {
        self.color = color
        label.labelColor = color
        label.configureLabelColor()
        layer.borderColor = color.cgColor
    }
}

//#Preview {
//    OutlineButton(title: "texto", color: .teal20)
//}
