//
//  UILabel+Extensions.swift
//  Altroo
//
//  Created by Raissa Parente on 22/10/25.
//
import UIKit

extension UIButton {
    func setCustomTitleLabel(_ label: UILabel) {
        self.setTitle(nil, for: .normal)
        self.titleLabel?.isHidden = true

        self.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }

        label.tag = 999
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
