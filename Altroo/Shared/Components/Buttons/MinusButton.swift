//
//  MinusButton.swift
//  Altroo
//
//  Created by Raissa Parente on 16/11/25.
//
import UIKit

class MinusButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        let icon = UIImageView(image: UIImage(systemName: "minus.circle.fill"))
        icon.contentMode = .scaleAspectFit
        icon.tintColor = UIColor(resource: .red20)
        icon.translatesAutoresizingMaskIntoConstraints = false
                
        addSubview(icon)

        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: self.topAnchor),
            icon.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            icon.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            icon.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}


