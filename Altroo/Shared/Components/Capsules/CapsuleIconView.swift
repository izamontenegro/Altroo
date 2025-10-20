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
    
    var labelIconSpacing: CGFloat = 6
    
    var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16) {
        didSet {
            updateConstraintsForInsets()
        }
    }
    
    private var innerShadowView: InnerShadowView?
    private var stackView: UIStackView!
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(
        iconName: String,
        text: String,
        mainColor: UIColor = UIColor(resource: .teal20),
        accentColor: UIColor = UIColor(.pureWhite),
        contentInsets: UIEdgeInsets? = nil
    ) {
        self.init(frame: .zero)
        self.iconName = iconName
        self.text = text
        self.mainColor = mainColor
        self.accentColor = accentColor
        
        if let insets = contentInsets {
            self.contentInsets = insets
        }
        
        makeCapsule()
        setupInnerShadow()
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        innerShadowView?.frame = bounds
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    private func makeCapsule() {
        self.backgroundColor = mainColor
        self.translatesAutoresizingMaskIntoConstraints = false
        
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = labelIconSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        topConstraint = stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInsets.top)
        bottomConstraint = stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInsets.bottom)
        leadingConstraint = stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: contentInsets.left)
        trailingConstraint = stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -contentInsets.right)
        
        NSLayoutConstraint.activate([topConstraint!, bottomConstraint!, leadingConstraint!, trailingConstraint!])
        
        let icon = UIImageView(image: UIImage(systemName: iconName))
        icon.tintColor = accentColor
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(icon)
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor)
        ])
        
        let label = StandardLabel(
            labelText: text,
            labelFont: .sfPro,
            labelType: .subHeadline,
            labelColor: UIColor.teal20,
            labelWeight: .medium
        )
        label.textColor = accentColor
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.85
        
        stackView.addArrangedSubview(label)
    }
    
    private func updateConstraintsForInsets() {
        topConstraint?.constant = contentInsets.top
        bottomConstraint?.constant = -contentInsets.bottom
        leadingConstraint?.constant = contentInsets.left
        trailingConstraint?.constant = -contentInsets.right
        layoutIfNeeded()
    }
    
    private func setupInnerShadow() {
        let shadow = InnerShadowView(
            frame: bounds,
            color: UIColor.blue40,
            opacity: 0.15
        )
        shadow.isUserInteractionEnabled = false
        shadow.layer.cornerRadius = layer.cornerRadius
        addSubview(shadow)
        innerShadowView = shadow
    }
}

#Preview {
    CapsuleIconView(
        iconName: "circle.fill",
        text: "Compacto",
        contentInsets: UIEdgeInsets(top: 3.5, left: 6, bottom: 3.5, right: 6)
    )
}
