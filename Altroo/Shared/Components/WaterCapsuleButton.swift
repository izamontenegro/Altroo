//
//  WaterCapsuleButton.swift
//  Altroo
//
//  Created by Raissa Parente on 30/09/25.
//

import UIKit
import SwiftUI

class WaterCapsuleButton: UIView {
    
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
        
        let leadingIcon = UIImageView(image: UIImage(systemName: "drop.fill"))
        leadingIcon.tintColor = accentColor
        leadingIcon.contentMode = .scaleAspectFit
        leadingIcon.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(capsule)
        capsule.addSubview(icon)
        capsule.addSubview(leadingIcon)
        capsule.addSubview(label)
        
        NSLayoutConstraint.activate([
            capsule.centerXAnchor.constraint(equalTo: centerXAnchor),
            capsule.centerYAnchor.constraint(equalTo: centerYAnchor),
            capsule.heightAnchor.constraint(equalToConstant: height),
            
            leadingIcon.leadingAnchor.constraint(equalTo: capsule.leadingAnchor, constant: 12),
            leadingIcon.centerYAnchor.constraint(equalTo: capsule.centerYAnchor),
            leadingIcon.heightAnchor.constraint(equalTo: capsule.heightAnchor, multiplier: 0.6),
            leadingIcon.widthAnchor.constraint(equalTo: leadingIcon.heightAnchor),
            
            label.leadingAnchor.constraint(equalTo: leadingIcon.trailingAnchor, constant: 6),
            label.centerYAnchor.constraint(equalTo: capsule.centerYAnchor),
            
            icon.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 12),
            icon.trailingAnchor.constraint(equalTo: capsule.trailingAnchor),
            icon.centerYAnchor.constraint(equalTo: capsule.centerYAnchor),
            icon.widthAnchor.constraint(equalTo: capsule.heightAnchor),
            icon.heightAnchor.constraint(equalTo: icon.widthAnchor),
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
    let button = WaterCapsuleButton(iconName: "plus", text: "250ml", mainColor: UIColor(resource: .black0), accentColor: UIColor(resource: .teal20), height: 50)
     return button
}
