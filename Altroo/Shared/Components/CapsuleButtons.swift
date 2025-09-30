//
//  CapsuleButtons.swift
//  Altroo
//
//  Created by Raissa Parente on 30/09/25.
//

import UIKit
import SwiftUI

class EditButton: UIView {
//    struct Style {
//        let iconPadding: Bool
//        let leadingIcon: UIImage?
//        let iconIsCircle: Bool
//    }
//    
//    enum Variant {
//        case edit, water, timePeriod
//        case custom(Style)
//        
//        var style: Style {
//            switch self {
//            case .edit:
//                return Style(iconPadding: true, leadingIcon: nil, iconIsCircle: true)
//            case .water:
//                return Style(iconPadding: false, leadingIcon: UIImage(systemName: "water"),  iconIsCircle: true)
//            case .timePeriod:
//                return Style(iconPadding: true, leadingIcon: nil, iconIsCircle: false)
//            case .custom(let s):
//                return s
//            }
//        }
//    }
    
    var iconName: String!
    var text: String!
    var mainColor: UIColor!
    var accentColor: UIColor!
    var buttonIconColor: UIColor = UIColor(resource: .white80)
    
    var height: CGFloat!
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(iconName: String, text: String, mainColor: UIColor, accentColor: UIColor, buttonIconColor: UIColor = UIColor(resource: .white80), height: CGFloat) {
        self.init(frame: .zero)
        self.iconName = iconName
        self.text = text
        self.mainColor = mainColor
        self.accentColor = accentColor
        self.buttonIconColor = buttonIconColor
        self.height = height

        makeCapsule()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func makeCapsule() {
        let capsule = UIView()
        capsule.backgroundColor = mainColor
        capsule.layer.cornerRadius = height/2
        capsule.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = makeIcon()
        let label = StandardLabel(labelText: text, labelFont: .sfPro, labelType: .h2, labelColor: .teal, labelWeight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(capsule)
        capsule.addSubview(icon)
        capsule.addSubview(label)
        
        NSLayoutConstraint.activate([
            capsule.centerXAnchor.constraint(equalTo: centerXAnchor),
            capsule.centerYAnchor.constraint(equalTo: centerYAnchor),
            capsule.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -12),
            capsule.trailingAnchor.constraint(equalTo: icon.trailingAnchor, constant: height * 0.1),
            capsule.heightAnchor.constraint(equalToConstant: height),
            
            icon.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 12),
            icon.trailingAnchor.constraint(equalTo: capsule.trailingAnchor),
            icon.centerYAnchor.constraint(equalTo: capsule.centerYAnchor),
            icon.widthAnchor.constraint(equalTo: capsule.heightAnchor, multiplier: 0.8),
            icon.heightAnchor.constraint(equalTo: icon.widthAnchor),
            
            label.leadingAnchor.constraint(equalTo: capsule.leadingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: capsule.centerYAnchor),
        ])
    }
    
    func makeIcon() -> UIView {
        let circle = CircleView()
        circle.fillColor = accentColor
        circle.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView(image: UIImage(systemName: iconName))
        icon.contentMode = .scaleAspectFit
        icon.tintColor = buttonIconColor
        icon.translatesAutoresizingMaskIntoConstraints = false
                
        circle.addSubview(icon)

        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
            icon.widthAnchor.constraint(equalTo: circle.widthAnchor, multiplier: 0.75),
            icon.heightAnchor.constraint(equalTo: icon.widthAnchor)
        ])
        
        return circle
    }
}

#Preview {
    let button = EditButton(iconName: "pencil", text: "Editar Seções", mainColor: UIColor(resource: .black0), accentColor: UIColor(resource: .teal20), height: 50)
     return button
}
