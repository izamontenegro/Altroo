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
    var customCornerRadius: CGFloat?
    
    init(title: String, color: UIColor, cornerRadius: CGFloat? = nil) {
        self.color = color
        self.customCornerRadius = cornerRadius
        super.init(frame: .zero)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        self.color = .teal10
        self.customCornerRadius = nil
        super.init(coder: coder)
        setupButton(title: "")
    }
    
    private func setupButton(title: String) {
        backgroundColor = .clear
        layer.cornerRadius = customCornerRadius ?? 23
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
    
    func updateTitle(_ title: String) {
        label.updateLabelText(title)
    }
    
    func updateColor(_ color: UIColor) {
        self.color = color
        label.labelColor = color
        label.configureLabelColor()
        layer.borderColor = color.cgColor
    }
    
    func updateCornerRadius(_ radius: CGFloat) {
        customCornerRadius = radius
        layer.cornerRadius = radius
    }
}

//#Preview {
//    OutlineButton(title: "texto", color: .teal20)
//}
