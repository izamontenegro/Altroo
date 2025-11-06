//
//  UIButton+Extensions.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 05/11/25.
//

import UIKit

extension UIButton {

    //  Enables a smooth press animation with scale and alpha feedback.
    //  Call this once after button initialization (e.g., in `viewDidLoad`).
    func enablePressAnimation(withHaptics: Bool = false) {
        addTarget(self, action: #selector(pressDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(pressUp), for: [.touchUpInside, .touchCancel, .touchDragExit])

        if withHaptics {
            addTarget(self, action: #selector(triggerHapticFeedbackButton), for: .touchUpInside)
        }
    }

    @objc private func pressDown() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction]) {
            self.alpha = 0.85
            self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }
    }

    @objc private func pressUp() {
        UIView.animate(
            withDuration: 0.22,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 3,
            options: [.curveEaseOut, .allowUserInteraction]
        ) {
            self.alpha = 1
            self.transform = .identity
        }
    }

    @objc private func triggerHapticFeedbackButton() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    // Enables a smooth highlight effect when the button is pressed.
    // No scaling or bounce — only visual feedback.
    func enableHighlightEffect() {
        addTarget(self, action: #selector(applyHighlight), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(removeHighlight), for: [.touchUpInside, .touchCancel, .touchDragExit])
    }
    
    @objc private func applyHighlight() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction]) {
            self.alpha = 0.6
        }
    }
    
    @objc private func removeHighlight() {
        UIView.animate(withDuration: 0.15, delay: 0, options: [.allowUserInteraction]) {
            self.alpha = 1
        }
    }
}

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
