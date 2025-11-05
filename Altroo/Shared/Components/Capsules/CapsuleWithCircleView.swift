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
    
    var onTap: (() -> Void)?
    var isTapEnabled: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
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
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        ])
        
        //label
        let label = StandardLabel(labelText: text,
                                  labelFont: .sfPro,
                                  labelType: .subHeadline,
                                  labelColor: textColor,
                                  labelWeight: .medium)
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.95
        label.lineBreakMode = .byTruncatingTail
        stackView.addArrangedSubview(label)
        
        //circle
        let circle = CircleView()
        circle.fillColor = circleIconColor
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.widthAnchor.constraint(equalToConstant: 26).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
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
            container.widthAnchor.constraint(equalToConstant: 21),
            container.heightAnchor.constraint(equalToConstant: 21),
            
            circle.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            icon.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        stackView.addArrangedSubview(container)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isTapEnabled else { return }
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0.85
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isTapEnabled else { return }
        super.touchesEnded(touches, with: event)

        UIView.animate(
            withDuration: 0.22,
            delay: 0,
            usingSpringWithDamping: 0.55,
            initialSpringVelocity: 4,
            animations: {
                self.alpha = 1
                self.transform = .identity
            },
            completion: { _ in
                self.onTap?()
            }
        )
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
            self.transform = .identity
        }
    }
}

//#Preview {
//    let button = CapsuleWithCircleView(text: "Editar",
//                                       textColor: .teal20,
//                                       nameIcon: "pencil",
//                                       nameIconColor: .pureWhite,
//                                       circleIconColor: .teal20)
//    return button
//}
