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

    var labelIconSpacing: CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(iconName: String,
                     text: String,
                     mainColor: UIColor = UIColor(resource: .teal20),
                     accentColor: UIColor = UIColor(.white)
    ) {
        
        self.init(frame: .zero)
        self.iconName = iconName
        self.text = text
        self.mainColor = mainColor
        self.accentColor = accentColor
        
        makeCapsule()
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    func makeCapsule() {
        self.backgroundColor = mainColor
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
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
        let label = StandardLabel(labelText: text, labelFont: .sfPro, labelType: .callOut, labelColor: UIColor.teal20, labelWeight: .bold)
        label.textColor = accentColor
        stackView.addArrangedSubview(label)
        
    }
    
}

#Preview {
//    let button = CapsuleIconView(iconName: "drop.fill", text: "250ml", mainColor: UIColor(resource: .black0), accentColor: UIColor(resource: .teal20))
    let button = CapsuleIconView(iconName: "drop.fill", text: "250ml")
    return button
}
