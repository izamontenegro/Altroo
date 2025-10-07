//
//  CapsuleView.swift
//  Altroo
//
//  Created by Raissa Parente on 30/09/25.
//
import UIKit

class CapsuleWithCircleView: UIView {
    
    var iconName: String!
    var text: String!
    var mainColor: UIColor!
    var accentColor: UIColor!
    var buttonIconColor: UIColor = UIColor(resource: .white80)
    
    var labelIconSpacing: CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(iconName: String,
                     text: String,
                     mainColor: UIColor,
                     accentColor: UIColor,
                     buttonIconColor: UIColor = UIColor(resource: .white80)
    ) {
        
        self.init(frame: .zero)
        self.iconName = iconName
        self.text = text
        self.mainColor = mainColor
        self.accentColor = accentColor
        self.buttonIconColor = buttonIconColor
        
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
        
        let icon = makeIcon()
        let label = StandardLabel(labelText: text, labelFont: .sfPro, labelType: .subHeadline, labelColor: UIColor.teal20, labelWeight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6)
        ])
        
        NSLayoutConstraint.activate([
            icon.heightAnchor.constraint(equalTo: label.heightAnchor, multiplier: 1.5),
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor)
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
    let button = CapsuleWithCircleView(iconName: "plus", text: "250ml", mainColor: UIColor(resource: .black0), accentColor: UIColor(resource: .teal20))
    return button
}
