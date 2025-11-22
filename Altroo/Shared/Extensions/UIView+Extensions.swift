//
//  UIView+Extensions.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 05/11/25.
//

import UIKit

extension UIView {

    // Enables a press highlight effect on any UIView.
    // Ideal for cards or custom components using UITapGestureRecognizer.
    func enablePressEffect(withHaptics: Bool = false) {
        let pressDown = UILongPressGestureRecognizer(target: self, action: #selector(handlePressGesture(_:)))
        pressDown.minimumPressDuration = 0
        pressDown.cancelsTouchesInView = false
        pressDown.name = withHaptics ? "withHaptics" : nil
        pressDown.delegate = PressEffectGestureDelegate.shared  // ✅ isolado
        addGestureRecognizer(pressDown)
        isUserInteractionEnabled = true
    }

    @objc private func handlePressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction]) {
                self.alpha = 0.85
                self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            }

            if gesture.name == "withHaptics" {
                triggerHapticFeedback()
            }

        case .ended, .cancelled, .failed:
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

        default:
            break
        }
    }
    
    func enableHighlightEffect(withHaptics: Bool = false) {
        if withHaptics {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
        
        UIView.animate(withDuration: 0.08, delay: 0, options: [.allowUserInteraction]) {
            self.alpha = 0.7
        } completion: { _ in
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                options: [.curveEaseOut, .allowUserInteraction]
            ) {
                self.alpha = 1
            }
        }
    }

    private func triggerHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func pinToEdges(of other: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: other.topAnchor),
            bottomAnchor.constraint(equalTo: other.bottomAnchor),
            leadingAnchor.constraint(equalTo: other.leadingAnchor),
            trailingAnchor.constraint(equalTo: other.trailingAnchor)
        ])
    }
}

private class PressEffectGestureDelegate: NSObject, UIGestureRecognizerDelegate {
    static let shared = PressEffectGestureDelegate()
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
