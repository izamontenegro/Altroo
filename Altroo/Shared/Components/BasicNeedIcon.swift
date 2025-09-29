//
//  BasicNeedIcon.swift
//  Altroo
//
//  Created by Raissa Parente on 29/09/25.
//

import UIKit

class BasicNeedIcon: UIView {
    enum BasicNeedType {
        case feeding
        case hydration
        case stool
        case urine
        
        var icon: String {
            switch self {
            case .feeding:
                return "waterbottle.fill"
            case .hydration:
                return "waterbottle.fill"
            case .stool:
                return "toilet.fill"
            case .urine:
                return "toilet.fill"
            }
        }
    }
    
    var basicNeed: BasicNeedType
    var color: UIColor

    override init(frame: CGRect) {
        self.basicNeed = .feeding
        self.color = .systemBlue
        super.init(frame: frame)
        setupBackground()
    }

    convenience init(basicNeed: BasicNeedType, color: UIColor) {
        self.init(frame: .zero)
        self.basicNeed = basicNeed
        self.color = color
        setupBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackground() {
        backgroundColor = .gray

        //top
        let circle1 = CircleView()
        circle1.fillColor = color.withAlphaComponent(0.8)
        circle1.innerShadowColor = UIColor(resource: .blue60)
        circle1.innerShadowOpacity = 0.5
        circle1.translatesAutoresizingMaskIntoConstraints = false
        
        //middle
        let circle2 = CircleView()
        circle2.fillColor = color.withAlphaComponent(0.5)
        circle2.innerShadowColor = UIColor(resource: .blue60)
        circle2.innerShadowOpacity = 0.5
        circle2.translatesAutoresizingMaskIntoConstraints = false
        
        //back
        let circle3 = CircleView()
        circle3.fillColor = color.withAlphaComponent(0.3)
        circle3.innerShadowColor = UIColor(resource: .blue60)
        circle3.innerShadowOpacity = 0.5
        circle3.translatesAutoresizingMaskIntoConstraints = false
        
        //icon
        let icon = UIImage(systemName: basicNeed.icon)
        let iconImageView = UIImageView(image: icon)
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(circle3)
        addSubview(circle2)
        addSubview(circle1)
        addSubview(iconImageView)
        
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
            
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: circle1.widthAnchor, multiplier: 0.75),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
        ])

    }
}

#Preview {
    let iconView = BasicNeedIcon(basicNeed: .hydration, color: .systemBlue)
    iconView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        iconView.widthAnchor.constraint(equalToConstant: 320),
        iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor)
    ])
    
    return iconView
}
