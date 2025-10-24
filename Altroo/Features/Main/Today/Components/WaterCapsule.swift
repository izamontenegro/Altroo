//
//  WaterCapsule.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 20/10/25.
//

import UIKit

class WaterCapsule: InnerShadowView {
    
    var text: String
    
    init(frame: CGRect) {
        self.text = ""
        super.init(frame: frame, color: .teal50.withAlphaComponent(0.85))
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(text: String) {
        self.init(frame: .zero)
        self.text = text
        
        makeCapsule()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    func makeCapsule() {
        self.backgroundColor = UIColor(resource: .teal80)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4)
        ])
        
        let leftIcon = UIImageView(image: UIImage(systemName: "drop.fill"))
        leftIcon.tintColor = .teal20
        leftIcon.contentMode = .scaleAspectFit
        leftIcon.translatesAutoresizingMaskIntoConstraints = false
        leftIcon.widthAnchor.constraint(equalToConstant: 18).isActive = true
        leftIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        stackView.addArrangedSubview(leftIcon)
        stackView.setCustomSpacing(6, after: leftIcon)
        
        //label
        let label = StandardLabel(labelText: text,
                                  labelFont: .sfPro,
                                  labelType: .subHeadline,
                                  labelColor: .teal20,
                                  labelWeight: .regular)
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.lineBreakMode = .byTruncatingTail
        stackView.addArrangedSubview(label)
        
        //circle
        let circle = CircleView()
        circle.fillColor = .teal20
        circle.translatesAutoresizingMaskIntoConstraints = false
        
        //icon
        let icon = UIImageView(image: UIImage(systemName: "plus"))
        icon.tintColor = .pureWhite
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        // Container for circle+icon
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(circle)
        container.addSubview(icon)
        
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 21),
            container.heightAnchor.constraint(equalToConstant: 21),
            
            circle.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 1.3),
            circle.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 1.3),
            
            circle.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            icon.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        stackView.addArrangedSubview(container)
    }
}

//#Preview {
//    let button = WaterCapsule(text: "250ml")
//    return button
//}
