//
//  CapsuleIconView.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//

import UIKit

class CapsuleIconView: UIView {
    
    var iconName: String!
    var text: String!
    var mainColor: UIColor = UIColor(resource: .teal20)
    var accentColor: UIColor = UIColor(.white)

    var labelIconSpacing: CGFloat = 8
    
    private var innerShadowView: InnerShadowView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(iconName: String,
                     text: String,
                     mainColor: UIColor = UIColor(resource: .teal20),
                     accentColor: UIColor = UIColor(.pureWhite)
    ) {
        
        self.init(frame: .zero)
        self.iconName = iconName
        self.text = text
        self.mainColor = mainColor
        self.accentColor = accentColor
        
        makeCapsule()
        setupInnerShadow()
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        innerShadowView?.frame = bounds
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    func makeCapsule() {
        self.backgroundColor = mainColor
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        //left icon
        let icon = UIImageView(image: UIImage(systemName: iconName))
        icon.tintColor = accentColor
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(icon)
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor)
        ])
        
        //label
        let label = StandardLabel(labelText: text, labelFont: .sfPro, labelType: .subHeadline, labelColor: UIColor.teal20, labelWeight: .medium)
        label.textColor = accentColor
        stackView.addArrangedSubview(label)
    }
    
    private func setupInnerShadow() {
        let shadow = InnerShadowView(frame: bounds,
                                     color: UIColor.blue40,
                                     opacity: 0.15)
        shadow.isUserInteractionEnabled = false
        shadow.layer.cornerRadius = layer.cornerRadius
        addSubview(shadow)
        innerShadowView = shadow
    }
}

#Preview {
    let button = CapsuleIconView(iconName: "cloud.moon.fill", text: "Madrugada")
    return button
}
