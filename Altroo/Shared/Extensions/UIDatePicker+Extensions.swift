//
//  UIDatePicker+Extensions.swift
//  Altroo
//
//  Created by Raissa Parente on 09/10/25.
//
import UIKit

extension UIDatePicker {
    static func make(style: UIDatePickerStyle = .compact, mode: UIDatePicker.Mode, tint: UIColor = .teal50) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = style
        picker.datePickerMode = mode
        picker.tintColor = tint        
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.setContentHuggingPriority(.required, for: .horizontal)
        picker.setContentCompressionResistancePriority(.required, for: .horizontal)
        picker.contentHorizontalAlignment = .leading
        picker.widthAnchor.constraint(equalToConstant: 120).isActive = true

        return picker
    }
}



