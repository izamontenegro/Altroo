//
//  StandardLabel.swift
//  Altroo
//
//  Created by Raissa Parente on 29/09/25.
//

import UIKit

enum FontWeight {
    case regular
    case medium
    case semibold
    case bold
}

class StandardLabel: UILabel {
    enum LabelType {
        case largeTitle
        case title1
        case title2
        case title3
        case headline
        case body
        case callOut
        case subHeadline
        case footnote
        case caption1
        case caption2
        
    }
    
    enum FontStyle {
        case sfPro
        case comfortaa
    }
    
    public private(set) var labelText: String
    public private(set) var labelFont: FontStyle
    public private(set) var labelType: LabelType
    public private(set) var labelColor: UIColor
    public private(set) var labelWeight: FontWeight
    
    
    init(labelText: String, labelFont: FontStyle, labelType: LabelType, labelColor: UIColor, labelWeight: FontWeight = .regular) {
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
        self.textColor = labelColor
        
    }
    
    private func configureLabelStyle() {
        let size: CGFloat
        switch labelType {
        case .largeTitle: size = 34
        case .title1: size = 28
        case .title2: size = 22
        case .title3: size = 20
        case .headline: size = 17
        case .body: size = 17
        case .callOut: size = 16
        case .subHeadline: size = 15
        case .footnote: size = 13
        case .caption1: size = 12
        case .caption2: size = 11
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
    let label = StandardLabel(labelText: "Maria Clara", labelFont: .sfPro, labelType: .title3, labelColor: UIColor.black40, labelWeight: .bold)
    return label
}
