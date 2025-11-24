//
//  icon+title+arrow.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 24/11/25.
//

import UIKit

class IconTitleArrowButton: UIButton {
    
    private let leftIconView = UIImageView()
    
    private let titleLabelView = StandardLabel(
        labelText: "",
        labelFont: .sfPro,
        labelType: .callOut,
        labelColor: .pureWhite,
        labelWeight: .medium
    )
    
    private let rightArrowView = UIImageView(
        image: UIImage(systemName: "chevron.right")
    )
    
    private let contentStack = UIStackView()
    private var innerShadowView: InnerShadowView?
        
    var icon: UIImage? {
        didSet { leftIconView.image = icon }
    }
    var titleText: String = "" {
        didSet { titleLabelView.text = titleText }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBase()
        setupContent()
        setupInnerShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBase()
        setupContent()
        setupInnerShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        innerShadowView?.frame = bounds
    }
}

// MARK: - Setup
extension IconTitleArrowButton {
    private func setupBase() {
        backgroundColor = UIColor(resource: .teal20)
        layer.cornerRadius = 8
        clipsToBounds = true
        
        setTitle("", for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupContent() {
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
        
        // Left Icon
        leftIconView.tintColor = .pureWhite
        leftIconView.contentMode = .scaleAspectFit
        leftIconView.setContentHuggingPriority(.required, for: .horizontal)
                
        // Right Arrow
        rightArrowView.tintColor = .pureWhite
        rightArrowView.contentMode = .scaleAspectFit
        rightArrowView.setContentHuggingPriority(.required, for: .horizontal)
        
        contentStack.addArrangedSubview(leftIconView)
        contentStack.addArrangedSubview(titleLabelView)
        contentStack.addArrangedSubview(rightArrowView)
    }
    
//    private func setupInnerShadow() {
//        let shadow = InnerShadowView(
//            frame: bounds,
//            color: UIColor.teal0,
//            opacity: 0.20
//        )
//        shadow.isUserInteractionEnabled = false
//        shadow.layer.cornerRadius = 8
//
//        insertSubview(shadow, at: 0)
//        innerShadowView = shadow
//    }
    
    private func setupInnerShadow() {
        let shadow = InnerShadowView(frame: bounds,
                                     color: UIColor.teal0,
                                     opacity: 0.20)
        shadow.isUserInteractionEnabled = false
        shadow.layer.cornerRadius = layer.cornerRadius
        addSubview(shadow)
        innerShadowView = shadow
    }
    
    // MARK: - Highlight Animation
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.transform = self.isHighlighted
                    ? CGAffineTransform(scaleX: 0.97, y: 0.97)
                    : .identity
            }
        }
    }
}

#Preview {
    let button = IconTitleArrowButton()
    button.icon = UIImage(systemName: "person.fill")
    button.titleText = "Meu Perfil"
    return button
}
