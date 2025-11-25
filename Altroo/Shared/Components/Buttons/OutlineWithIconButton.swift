//
//  OutlineWithIconButton.swift
//  Altroo
//
//  Created by Raissa Parente on 17/11/25.
//
import UIKit

class OutlineWithIconButton: PaddedContentIgnoringButton {
    var associatedData: Any?
    let color = UIColor(resource: .blue30)
    
    var text: String
    var iconName: String
    
    lazy var label = StandardLabel(
        labelText: text,
        labelFont: .sfPro,
        labelType: .callOut,
        labelColor: .blue30,
        labelWeight: .regular
    )
    
    lazy var icon: UIImageView = {
        let icon =  UIImageView(image: UIImage(systemName: iconName))
        icon.tintColor = .blue30
        icon.contentMode = .scaleAspectFit
        icon.setContentHuggingPriority(.required, for: .horizontal)
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        return icon
    }()
    

    init(title: String, iconName: String) {
        self.text = title
        self.iconName = iconName
        super.init(frame: .zero)
        setupBackground()
        setupSelectedContent()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
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
        backgroundColor = .clear
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        layer.borderColor = UIColor(resource: .blue30).cgColor
        layer.borderWidth = 1
        
        
        contentEdgeInsets = UIEdgeInsets(top: 6, left: 16,
                                         bottom: 6, right: 0)
        translatesAutoresizingMaskIntoConstraints = false
        
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
