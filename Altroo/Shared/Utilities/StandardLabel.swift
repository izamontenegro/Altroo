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
        case blue
    }
    
    enum FontStyle {
        case sfPro
        case comfortaa
    }
    
    public private(set) var labelText: String
    public private(set) var labelFont: FontStyle
    public private(set) var labelType: LabelType
    public private(set) var labelColor: ColorStyle
    
    init(labelText: String, labelFont: FontStyle, labelType: LabelType, labelColor: ColorStyle) {
        self.labelText = labelText
        self.labelFont = labelFont
        self.labelType = labelType
        self.labelColor = labelColor
        
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
        switch labelColor {
        case .black:
            self.textColor = UIColor(named: "black0")
        case .blue:
            self.textColor = UIColor(named: "blue0")
        }
    }
    
    private func configureLabelStyle() {
        let size: CGFloat
        switch labelType {
        case .h1:
            size = 24
        case .h2:
            size = 16
        case .h3:
            size = 12
        }
        
        switch labelFont {
        case .sfPro:
            let systemFont = UIFont.systemFont(ofSize: size)
            if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
                self.font = UIFont(descriptor: descriptor, size: size)
            } else {
                self.font = systemFont
            }
        case .comfortaa:
            self.font = UIFont(name: "Comfortaa", size: size)
        }
        
    }
}
