//
//  UIButton+Extensions.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 05/11/25.
//

import UIKit

extension UIButton {

    func enablePressAnimation() {
        addTarget(self, action: #selector(pressDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(pressUp), for: [.touchUpInside, .touchCancel, .touchDragExit])
    }

    @objc private func pressDown() {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0.85
            self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }
    }

    @objc private func pressUp() {
        UIView.animate(
            withDuration: 0.22,
            delay: 0,
            usingSpringWithDamping: 0.55,
            initialSpringVelocity: 4,
            options: [.curveEaseOut],
            animations: {
                self.alpha = 1
                self.transform = .identity
            }
        )
    }
}
