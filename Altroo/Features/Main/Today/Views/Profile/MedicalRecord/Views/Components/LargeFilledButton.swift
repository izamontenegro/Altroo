//
//  LargeFilledButton.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 10/11/25.
//

import UIKit

final class LargeFilledButton: UIButton {
    init(
        title: String,
        icon: UIImage? = nil,
        backgroundColor: UIColor = .teal20,
        cornerRadius: CGFloat = 23,
        height: CGFloat = 46
    ) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        let label = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .pureWhite,
            labelWeight: .medium
        )
        
        var arrangedSubviews: [UIView] = []
        
        if let icon = icon {
            let iconImageView = UIImageView(image: icon)
            iconImageView.tintColor = .white
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            arrangedSubviews = [iconImageView, label]
        } else {
            arrangedSubviews = [label]
        }
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = icon != nil ? 8 : 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
