//
//  CheckOptionButton.swift
//  Altroo
//
//  Created by Raissa Parente on 14/11/25.
//

import UIKit

class CheckOptionButton: PaddedContentIgnoringButton {
    var associatedData: Any?
    let color = UIColor(resource: .teal20)
    private var innerShadowView: InnerShadowView?
    
    var text: String = ""
    var canSelectMultiple: Bool = false
    
    lazy var label = StandardLabel(
        labelText: text,
        labelFont: .sfPro,
        labelType: .callOut,
        labelColor: .blue30,
        labelWeight: .regular
    )
    
    let icon: UIImageView = {
        let icon =  UIImageView(image: UIImage(systemName: "checkmark"))
        icon.tintColor = .blue30
        icon.contentMode = .scaleAspectFit
        icon.setContentHuggingPriority(.required, for: .horizontal)
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        return icon
    }()
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    init(title: String) {
        self.text = title
        super.init(frame: .zero)
        setupBackground()
        setupSelectedContent()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        innerShadowView?.frame = bounds
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        isSelected.toggle()
//    }
    
    override var intrinsicContentSize: CGSize {
        let stackSize = subviews.first(where: { $0 is UIStackView })?.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        ) ?? .zero

        return CGSize(
            width: stackSize.width + contentEdgeInsets.left + contentEdgeInsets.right,
            height: stackSize.height + contentEdgeInsets.top + contentEdgeInsets.bottom
        )
    }

    private func setupBackground() {
        backgroundColor = isSelected ? .blue30 : .clear
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 16,
                                         bottom: 4, right: 0)
        translatesAutoresizingMaskIntoConstraints = false
        
        if isSelected {
            setupInnerShadow()
        }
    }
    
    private func setupSelectedContent() {
        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
    }
    
    private func updateAppearance() {
        backgroundColor = isSelected ? .blue30 : .clear
        layer.borderColor = isSelected ? UIColor.clear.cgColor : UIColor(resource: .blue30).cgColor
        layer.borderWidth = 1
        
        icon.tintColor = isSelected ? .pureWhite : .blue30
        icon.image = UIImage(systemName:  isSelected ? "checkmark" : "square")
        
        label.labelColor = isSelected ? .pureWhite : .blue30
        label.configureLabelColor()
    }
    
    private func setupInnerShadow() {
        let shadow = InnerShadowView(frame: bounds,
                                     color: UIColor.teal0,
                                     opacity: 0.20)
        shadow.isUserInteractionEnabled = false
        shadow.layer.cornerRadius = layer.cornerRadius
        addSubview(shadow)
        innerShadowView = shadow
    }
    
    // animation when clicking the button
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

