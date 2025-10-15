//
//  CapsuleView.swift
//  Altroo
//
//  Created by Raissa Parente on 30/09/25.
//
import UIKit

class CapsuleWithCircleView: UIView {
    
    var text: String!
    var textColor: UIColor = UIColor(resource: .teal20)
   
    var nameIcon: String!
    var nameIconColor: UIColor = UIColor(resource: .pureWhite)
    var circleIconColor: UIColor = UIColor(resource: .teal20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(text: String, textColor: UIColor, nameIcon: String, nameIconColor: UIColor, circleIconColor: UIColor) {
        
        self.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        self.nameIcon = nameIcon
        self.nameIconColor = nameIconColor
        self.circleIconColor = circleIconColor
        
        makeCapsule()
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
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
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4)
        ])
        
        //label
        let label = StandardLabel(labelText: text,
                                  labelFont: .sfPro,
                                  labelType: .subHeadline,
                                  labelColor: textColor,
                                  labelWeight: .medium)
        stackView.addArrangedSubview(label)
        
        //circle
        let circle = CircleView()
        circle.fillColor = circleIconColor
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.widthAnchor.constraint(equalToConstant: 30).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //icon
        let icon = UIImageView(image: UIImage(systemName: nameIcon))
        icon.tintColor = nameIconColor
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Container for circle+icon
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(circle)
        container.addSubview(icon)
        
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 30),
            container.heightAnchor.constraint(equalToConstant: 30),
            
            circle.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            icon.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        stackView.addArrangedSubview(container)
    }
    
//    private func setupInnerShadow() {
//        let shadow = InnerShadowView(frame: bounds,
//                                     color: UIColor.blue40,
//                                     opacity: 0.15)
//        shadow.isUserInteractionEnabled = false
//        shadow.layer.cornerRadius = layer.cornerRadius
//        addSubview(shadow)
//        innerShadowView = shadow
//    }
}

#Preview {
    let button = CapsuleWithCircleView(text: "Editar Seções",
                                       textColor: .teal20,
                                       nameIcon: "pencil",
                                       nameIconColor: .pureWhite,
                                       circleIconColor: .teal20)
    return button
}
