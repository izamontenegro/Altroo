//
//  Untitled.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 09/10/25.
//

import UIKit

class CaregiverProfileCardView: UIView {
    
    private func avatarView() -> UIView {
        let avatar = UIView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.backgroundColor = .blue30
        avatar.layer.cornerRadius = 17
        avatar.layer.masksToBounds = true
        avatar.layer.borderColor = UIColor.pureWhite.cgColor
        avatar.layer.borderWidth = 2

        let initials = initialsFromName("joana")
        let initialsLabel = StandardLabel(
            labelText: initials,
            labelFont: .sfPro,
            labelType: .subHeadline,
            labelColor: .pureWhite,
            labelWeight: .medium
        )
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        avatar.addSubview(initialsLabel)

        NSLayoutConstraint.activate([
            initialsLabel.centerXAnchor.constraint(equalTo: avatar.centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor)
        ])
        return avatar
    }
    
    private let nameLabel = StandardLabel(
        labelText: "Nome cuidador",
        labelFont: .sfPro,
        labelType: .subHeadline,
        labelColor: .black10,
        labelWeight: .medium
    )
    
    private let subtitleLabel = StandardLabel(
        labelText: "Categoria do cuidador",
        labelFont: .sfPro,
        labelType: .footnote,
        labelColor: .black20,
        labelWeight: .regular
    )
    
    private lazy var accessButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .blue10
        button.backgroundColor = .clear
        
        let titleLabel = StandardLabel(
            labelText: "Acesso",
            labelFont: .sfPro,
            labelType: .subHeadline,
            labelColor: .blue10,
            labelWeight: .medium
        )
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let chevron = UIImageView(image: UIImage(systemName: "chevron.down"))
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.tintColor = .blue10
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        chevron.preferredSymbolConfiguration = symbolConfig
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, chevron])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.isUserInteractionEnabled = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: button.leadingAnchor),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: button.trailingAnchor)
        ])
        
        button.addAction(UIAction { [weak self] _ in
            self?.didTapAccess()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var nameStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.blue80
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false
        
        let avatarView = avatarView()
        addSubview(avatarView)
        addSubview(nameStack)
        addSubview(accessButton)
        
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 34),
            avatarView.heightAnchor.constraint(equalToConstant: 34),
            
            nameStack.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            nameStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            accessButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            accessButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameStack.trailingAnchor.constraint(lessThanOrEqualTo: accessButton.leadingAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CaregiverProfileCardView {
    func didTapAccess() {
        print("oi")
    }
    
    func initialsFromName(_ name: String) -> String {
        let comps = name.split(separator: " ")
        let initials = comps.prefix(2).compactMap { $0.first?.uppercased() }.joined()
        return initials.isEmpty ? "?" : initials
    }
}

#Preview {
    CaregiverProfileCardView()
}
