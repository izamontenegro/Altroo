//
//  SwiftUIStandardLabel.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 24/10/25.
//

import SwiftUI
import UIKit

struct StandardLabelRepresentable: UIViewRepresentable {
    let labelFont: StandardLabel.FontStyle
    let labelType: StandardLabel.LabelType
    let labelWeight: FontWeight
    
    var text: String
    var color: UIColor
    
    var numberOfLines: Int = 0
    var alignment: NSTextAlignment = .natural
    var lineBreakMode: NSLineBreakMode = .byWordWrapping

    func makeUIView(context: Context) -> StandardLabel {
        let label = StandardLabel(
            labelText: text,
            labelFont: labelFont,
            labelType: labelType,
            labelColor: color,
            labelWeight: labelWeight
        )
        label.numberOfLines = numberOfLines
        label.textAlignment  = alignment
        label.lineBreakMode  = lineBreakMode
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }

    func updateUIView(_ uiView: StandardLabel, context: Context) {
        if uiView.text != text {
            uiView.updateLabelText(text)
        }
        if uiView.labelColor != color {
            uiView.textColor = color
        }
    }
}
