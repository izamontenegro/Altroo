//
//  CapsuleView.swift
//  Altroo
//
//  Created by Raissa Parente on 30/09/25.
//
import UIKit

class CapsuleView: UIView {
    
    var iconName: String!
    var text: String!
    var mainColor: UIColor!
    var accentColor: UIColor!
    var buttonIconColor: UIColor = UIColor(resource: .white80)
    var height: CGFloat!
    
    var leadingIconName: String? = nil
    var leadingIconMultiplier: CGFloat = 0.6
    var labelIconSpacing: CGFloat = 12
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(iconName: String,
                     text: String,
                     mainColor: UIColor,
                     accentColor: UIColor,
                     buttonIconColor: UIColor = UIColor(resource: .white80),
                     height: CGFloat,
                     leadingIconName: String? = nil) {
        
        self.init(frame: .zero)
        self.iconName = iconName
        self.text = text
        self.mainColor = mainColor
        self.accentColor = accentColor
        self.buttonIconColor = buttonIconColor
        self.height = height
        self.leadingIconName = leadingIconName
        
        makeCapsule()
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    func makeCapsule() {
        
        var iconPadding: CFloat {
            if let leadingIconName {
                return CFloat(0.0)
            } else {
                return CFloat(height * 0.1)
            }
        }
        
        var iconWidth: CFloat {
            if let leadingIconName {
                return CFloat(height)
            } else {
                return CFloat(height * 0.8)
            }
        }
        
        let capsule = UIView()
        capsule.backgroundColor = mainColor
        capsule.layer.cornerRadius = height / 2
        capsule.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = makeIcon()
        let label = StandardLabel(labelText: text, labelFont: .sfPro, labelType: .subHeadline, labelColor: UIColor.teal20, labelWeight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(capsule)
        capsule.addSubview(icon)
        capsule.addSubview(label)
        
        var previousAnchor: NSLayoutXAxisAnchor = capsule.leadingAnchor
        var constraints = [
            capsule.centerXAnchor.constraint(equalTo: centerXAnchor),
            capsule.centerYAnchor.constraint(equalTo: centerYAnchor),
            capsule.heightAnchor.constraint(equalToConstant: height)
        ]
        
        //optional leading icon
        if let leadingIconName  {
            let leadingIcon = UIImageView(image: UIImage(systemName: leadingIconName))
            leadingIcon.tintColor = accentColor
            leadingIcon.contentMode = .scaleAspectFit
            leadingIcon.translatesAutoresizingMaskIntoConstraints = false
            capsule.addSubview(leadingIcon)
            
            constraints += [
                leadingIcon.leadingAnchor.constraint(equalTo: capsule.leadingAnchor, constant: 12),
                leadingIcon.centerYAnchor.constraint(equalTo: capsule.centerYAnchor),
                leadingIcon.heightAnchor.constraint(equalTo: capsule.heightAnchor, multiplier: leadingIconMultiplier),
                leadingIcon.widthAnchor.constraint(equalTo: leadingIcon.heightAnchor),
                
                label.leadingAnchor.constraint(equalTo: leadingIcon.trailingAnchor, constant: 6)
            ]
            previousAnchor = leadingIcon.trailingAnchor
        } else {
            constraints.append(label.leadingAnchor.constraint(equalTo: capsule.leadingAnchor, constant: 12))
        }
        
        constraints += [
            label.centerYAnchor.constraint(equalTo: capsule.centerYAnchor),
            
            icon.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: labelIconSpacing),
            icon.trailingAnchor.constraint(equalTo: capsule.trailingAnchor, constant: CGFloat(-iconPadding)),
            icon.centerYAnchor.constraint(equalTo: capsule.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: CGFloat(iconWidth)),
            icon.heightAnchor.constraint(equalToConstant: CGFloat(iconWidth))
        ]
        
        NSLayoutConstraint.activate(constraints)
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
    let button = CapsuleView(iconName: "plus", text: "250ml", mainColor: UIColor(resource: .black0), accentColor: UIColor(resource: .teal20), height: 50)
     return button
}
