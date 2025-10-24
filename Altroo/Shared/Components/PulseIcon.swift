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
    
    var color: UIColor {
        didSet { updateColors() }
    }
    var iconColor: UIColor {
        didSet { updateColors() }
    }
    var shadowColor: UIColor {
        didSet { updateColors() }
    }

    private let circle1 = CircleView()
    private let circle2 = CircleView()
    private let circle3 = CircleView()
    private var iconImageView: UIImageView?
    private var label: UILabel?


    init(frame: CGRect = .zero, iconName: String, color: UIColor, iconColor: UIColor, shadowColor: UIColor) {
        self.iconName = iconName
        self.color = color
        self.iconColor = iconColor
        self.shadowColor = shadowColor
        super.init(frame: frame)
        setupBackground()
    }

    init(frame: CGRect = .zero, text: String, color: UIColor, iconColor: UIColor, shadowColor: UIColor) {
        self.text = text
        self.color = color
        self.iconColor = iconColor
        self.shadowColor = shadowColor
        super.init(frame: frame)
        setupBackground()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBackground() {
        [circle1, circle2, circle3].forEach { circle in
            circle.translatesAutoresizingMaskIntoConstraints = false
            addSubview(circle)
        }

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
            circle1.heightAnchor.constraint(equalTo: circle1.widthAnchor)
        ])

        if let iconName {
            let icon = UIImage(systemName: iconName)
            let imageview = UIImageView(image: icon?.withRenderingMode(.alwaysTemplate))
            imageview.tintColor = iconColor
            imageview.contentMode = .scaleAspectFit
            imageview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageview)
            NSLayoutConstraint.activate([
                imageview.centerXAnchor.constraint(equalTo: centerXAnchor),
                imageview.centerYAnchor.constraint(equalTo: centerYAnchor),
                imageview.widthAnchor.constraint(equalTo: circle1.widthAnchor, multiplier: 0.95),
                imageview.heightAnchor.constraint(equalTo: imageview.widthAnchor)
            ])
            self.iconImageView = imageview
        }

        if let text {
            let label = StandardLabel(labelText: text,
                                      labelFont: .sfPro,
                                      labelType: .title1,
                                      labelColor: iconColor,
                                      labelWeight: .semibold)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: centerXAnchor),
                label.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
            self.label = label
        }

        updateColors()
    }

    private func updateColors() {
        circle1.fillColor = color.withAlphaComponent(0.8)
        circle2.fillColor = color.withAlphaComponent(0.5)
        circle3.fillColor = color.withAlphaComponent(0.3)

        circle1.innerShadowColor = shadowColor
        circle2.innerShadowColor = shadowColor
        circle3.innerShadowColor = shadowColor

        iconImageView?.tintColor = iconColor
        label?.textColor = iconColor
    }
}
//
//#Preview {
//    let iconView = PulseIcon(text: "1",
//                             color: UIColor(resource: .teal10),
//                             iconColor: UIColor(resource: .pureWhite),
//                             shadowColor: UIColor(resource: .teal80))
//    
//    iconView.translatesAutoresizingMaskIntoConstraints = false
//    
//    NSLayoutConstraint.activate([
//        iconView.widthAnchor.constraint(equalToConstant: 55),
//        iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor)
//    ])
//    
//    return iconView
//}
