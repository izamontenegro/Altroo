//
//  UIStackView+Extensions.swift
//  Altroo
//
//  Created by Raissa Parente on 22/11/25.
//

import UIKit

extension UIStackView {
    func clearContent() {
        self.arrangedSubviews.forEach { view in
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
