//
//  KeyboardHandler.swift
//  Altroo
//
//  Created by Raissa Parente on 28/10/25.
//
import UIKit

final class KeyboardHandler {
    
    private weak var viewController: UIViewController?
    private var keyboardOffset: CGFloat = 0

    init(viewController: UIViewController) {
        self.viewController = viewController
        setupObservers()
    }

    deinit {
        removeObservers()
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let vc = viewController,
              let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentField = UIResponder.currentFirst() as? UIView else { return }

        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedFrame = vc.view.convert(currentField.frame, from: currentField.superview)
        let textFieldBottomY = convertedFrame.origin.y + convertedFrame.height

        if textFieldBottomY > keyboardTopY {
            let offset = textFieldBottomY - keyboardTopY + 10
            UIView.animate(withDuration: 0.3) {
                vc.view.frame.origin.y = -offset
            }
            keyboardOffset = offset
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let vc = viewController else { return }
        UIView.animate(withDuration: 0.3) {
            vc.view.frame.origin.y = 0
        }
        keyboardOffset = 0
    }
}
