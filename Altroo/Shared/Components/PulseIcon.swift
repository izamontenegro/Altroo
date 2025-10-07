//
//  BasicNeedIcon.swift
//  Altroo
//
//  Created by Raissa Parente on 29/09/25.
//

import UIKit

class PulseIcon: UIView {
    var iconName: String?
    var text: String?
    
    var color: UIColor
    var shadowColor: UIColor
    
    init(frame: CGRect = .zero, iconName: String, color: UIColor, shadowColor: UIColor) {
        self.iconName = iconName
        self.color = color
        self.shadowColor = shadowColor
        super.init(frame: frame)
        setupBackground()
    }
    
    init(frame: CGRect = .zero, text: String, color: UIColor, shadowColor: UIColor) {
        self.text = text
        self.color = color
        self.shadowColor = shadowColor
        super.init(frame: frame)
        setupBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackground() {
        //        backgroundColor = .gray
        
        //top
        let circle1 = CircleView()
        circle1.fillColor = color.withAlphaComponent(0.8)
        circle1.innerShadowColor = shadowColor
        circle1.innerShadowOpacity = 0.5
        circle1.translatesAutoresizingMaskIntoConstraints = false
        
        //middle
        let circle2 = CircleView()
        circle2.fillColor = color.withAlphaComponent(0.5)
        circle2.innerShadowColor = shadowColor
        circle2.innerShadowOpacity = 0.0
        circle2.translatesAutoresizingMaskIntoConstraints = false
        
        //back
        let circle3 = CircleView()
        circle3.fillColor = color.withAlphaComponent(0.3)
        circle3.innerShadowColor = shadowColor
        circle3.innerShadowOpacity = 0.5
        circle3.translatesAutoresizingMaskIntoConstraints = false
        

        
        addSubview(circle3)
        addSubview(circle2)
        addSubview(circle1)
        
        NSLayoutConstraint.activate([
            circle3.centerXAnchor.constraint(equalTo: centerXAnchor),
            circle3.centerYAnchor.constraint(equalTo: centerYAnchor),
            circle3.widthAnchor.constraint(equalTo: widthAnchor),
            circle3.heightAnchor.constraint(equalTo: circle3.widthAnchor),
            
            circle2.centerXAnchor.constraint(equalTo: centerXAnchor),
            circle2.centerYAnchor.constraint(equalTo: centerYAnchor),
            circle2.widthAnchor.constraint(equalTo: circle3.widthAnchor, multiplier: 0.85),
            circle2.heightAnchor.constraint(equalTo: circle2.widthAnchor),
            
            circle1.centerXAnchor.constraint(equalTo: centerXAnchor),
            circle1.centerYAnchor.constraint(equalTo: centerYAnchor),
            circle1.widthAnchor.constraint(equalTo: circle3.widthAnchor, multiplier: 0.65),
            circle1.heightAnchor.constraint(equalTo: circle1.widthAnchor),
            
   
        ])
        
        //icon
        if let iconName {
            let icon = UIImage(systemName: iconName)
            let iconImageView = UIImageView(image: icon)
            iconImageView.tintColor = .white
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(iconImageView)

            NSLayoutConstraint.activate([
                iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                iconImageView.widthAnchor.constraint(equalTo: circle1.widthAnchor, multiplier: 0.95),
                iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
            ])
        }
        
        //text
        if let text {
            let label = StandardLabel(labelText: text, labelFont: .sfPro, labelType: .title2, labelColor: .white)
            addSubview(label)
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: centerXAnchor),
                label.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }
}

#Preview {
//    let iconView = PulseIcon(iconName: "waterbottle.fill", color: UIColor(resource: .blue30), shadowColor: UIColor(resource: .blue60))
    
    let iconView = PulseIcon(text: "3", color: UIColor(resource: .blue30), shadowColor: UIColor(resource: .blue60))
    
    iconView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        iconView.widthAnchor.constraint(equalToConstant: 320),
        iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor)
    ])
    
    return iconView
}
