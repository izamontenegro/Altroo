//
//  UIDatePickerWrapper.swift
//  Altroo
//
//  Created by Raissa Parente on 06/11/25.
//
import UIKit
import SwiftUI

struct UIDatePickerWrapper: UIViewRepresentable {
    @Binding var date: Date
    var type: UIDatePicker.Mode
    
    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = type
        picker.locale = Locale(identifier: "pt_BR")
        picker.preferredDatePickerStyle = .compact
        picker.contentHorizontalAlignment = .leading
        picker.addTarget(context.coordinator, action: #selector(Coordinator.updateDate(_:)), for: .valueChanged)
        return picker
    }
    
    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = date
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: UIDatePickerWrapper
        init(_ parent: UIDatePickerWrapper) { self.parent = parent }
        
        @objc func updateDate(_ sender: UIDatePicker) {
            parent.date = sender.date
        }
    }
}
