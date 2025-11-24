//
//  CapsuleIconView.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//

import UIKit

class CapsuleIconView: InnerShadowView {
    
    var iconName: String!
    var text: String!
    var mainColor: UIColor = UIColor(resource: .teal20)
    var accentColor: UIColor = UIColor(.white)
    var iconSize: CGFloat = 18
    
    var onTap: (() -> Void)?
    var isTapEnabled: Bool = true
    
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
    
    init(frame: CGRect) {
        super.init(frame: frame)
        setupTapGesture()
    }
    
    convenience init(
        iconName: String,
        text: String,
        mainColor: UIColor = UIColor(resource: .teal20),
        accentColor: UIColor = UIColor(.pureWhite),
        iconSize: CGFloat = 18,
        contentInsets: UIEdgeInsets? = nil
    ) {
        self.init(frame: .zero)
        self.iconName = iconName
        self.text = text
        self.mainColor = mainColor
        self.accentColor = accentColor
        self.iconSize = iconSize
        if let insets = contentInsets {
            self.contentInsets = insets
        }
        
       
            makeCapsule()
        
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    private func makeCapsule() {
        self.backgroundColor = mainColor
        self.translatesAutoresizingMaskIntoConstraints = false

        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = labelIconSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .center

        addSubview(stackView)

        topConstraint = stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInsets.top)
        bottomConstraint = stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInsets.bottom)
        leadingConstraint = stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8)
        trailingConstraint = stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)

        NSLayoutConstraint.activate([topConstraint!, bottomConstraint!, leadingConstraint!, trailingConstraint!])

        let icon = UIImageView(image: UIImage(systemName: iconName))
        icon.tintColor = accentColor
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(icon)

        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: iconSize),
            icon.heightAnchor.constraint(equalToConstant: iconSize)
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

        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)

        stackView.addArrangedSubview(label)

        let intrinsicWidth = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
        self.widthAnchor.constraint(equalToConstant: intrinsicWidth + 8 + contentInsets.right).isActive = true
    }

    private func updateConstraintsForInsets() {
        topConstraint?.constant = contentInsets.top
        bottomConstraint?.constant = -contentInsets.bottom
        leadingConstraint?.constant = contentInsets.left
        trailingConstraint?.constant = -contentInsets.right
        layoutIfNeeded()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        guard isTapEnabled else { return }
        onTap?()
    }
}

//#Preview {
//    CapsuleIconView(
//        iconName: "circle.fill",
//        text: "Compacto",
//        contentInsets: UIEdgeInsets(top: 3.5, left: 6, bottom: 3.5, right: 6)
//    )
//}
