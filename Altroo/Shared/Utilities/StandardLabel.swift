//
//  StandardLabel.swift
//  Altroo
//
//  Created by Raissa Parente on 29/09/25.
//

import UIKit

class StandardLabel: UILabel {
    enum LabelType {
        case h1
        case h2
        case h3
    }
    
    enum ColorStyle {
        case black
        case white
        case blue
        case teal
    }
    
    enum FontStyle {
        case sfPro
        case comfortaa
    }
    
    enum FontWeight {
        case regular
        case medium
        case semibold
        case bold
    }
    public private(set) var labelText: String
    public private(set) var labelFont: FontStyle
    public private(set) var labelType: LabelType
    public private(set) var labelColor: ColorStyle
    public private(set) var labelWeight: FontWeight
    
    
    init(labelText: String, labelFont: FontStyle, labelType: LabelType, labelColor: ColorStyle, labelWeight: FontWeight = .regular) {
        self.labelText = labelText
        self.labelFont = labelFont
        self.labelType = labelType
        self.labelColor = labelColor
        self.labelWeight = labelWeight
        
        super.init(frame: .zero)
        self.configureLabelColor()
        self.configureLabelStyle()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSMutableAttributedString(string: labelText)
        self.attributedText = attributedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabelColor() {
        var colorName: String
        
        switch labelColor {
        case .black:
            colorName = "black10"
        case .blue:
            colorName = "blue40"
        case .white:
            colorName = "white80"
        case .teal:
            colorName = "teal20"
        }
        
        self.textColor = UIColor(named: colorName)
        
    }
    
    private func configureLabelStyle() {
        let size: CGFloat
        switch labelType {
        case .h1: size = 24
        case .h2: size = 16
        case .h3: size = 12
        }
        
        let weight: UIFont.Weight
        switch labelWeight {
        case .regular: weight = .regular
        case .medium:  weight = .medium
        case .semibold: weight = .semibold
        case .bold: weight = .bold
        }
        
        switch labelFont {
        case .sfPro:
            let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
            if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
                self.font = UIFont(descriptor: descriptor, size: size)
            } else {
                self.font = systemFont
            }
        case .comfortaa:
            if let baseFont = UIFont(name: "Comfortaa", size: size) {
                let descriptor = baseFont.fontDescriptor.addingAttributes([
                    UIFontDescriptor.AttributeName.traits: [
                        UIFontDescriptor.TraitKey.weight: weight
                    ]
                ])
                self.font = UIFont(descriptor: descriptor, size: size)
            } else {
                self.font = UIFont.systemFont(ofSize: size, weight: weight)
            }
        }
        
    }
}

#Preview {
    let label = StandardLabel(labelText: "Maria Clara", labelFont: .sfPro, labelType: .h1, labelColor: .teal, labelWeight: .bold)
    return label
}
