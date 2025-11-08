//
// ProfileCareRecipient.swift
// Altroo
//
// Created by Layza Maria Rodrigues Carneiro on 12/10/25.
//

import UIKit

class CareRecipientCard: UIView {
    let profileName: String
    let notification: String?
    var careRecipient: CareRecipient?
    
    var isPlusButton = false
    var currentCareRecipient = false
    
    init(name: String, notification: String? = nil, careRecipient: CareRecipient? = nil, isPlusButton: Bool = false, currentCareRecipient: Bool = false, frame: CGRect = .zero) {
        self.profileName = name
        self.notification = notification
        self.careRecipient = careRecipient
        self.isPlusButton = isPlusButton
        self.currentCareRecipient = currentCareRecipient
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .pureWhite
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let avatarView = makeAvatarView()
        let contentStack = makeContentStack()

        let checkImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkImageView.tintColor = .blue20
        checkImageView.contentMode = .scaleAspectFit
        checkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        checkImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let arrangedSubviews: [UIView]
        if currentCareRecipient {
            arrangedSubviews = [avatarView, contentStack, checkImageView]
        } else {
            arrangedSubviews = [avatarView, contentStack]
        }
        
        let mainStack = UIStackView(arrangedSubviews: arrangedSubviews)
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainStack)

        NSLayoutConstraint.activate([
           mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
           mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
           mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
           mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    private func makeContentStack() -> UIStackView {
        let label = StandardLabel(labelText: profileName,
                                  labelFont: .comfortaa,
                                  labelType: .title3,
                                  labelColor: isPlusButton ? .teal20 : .blue20,
                                  labelWeight: .bold)
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.addArrangedSubview(label)
        
        if currentCareRecipient {
            let seeMoreLabel = StandardLabel(
                labelText: "Ver mais",
                labelFont: .sfPro,
                labelType: .subHeadline,
                labelColor: .black10,
                labelWeight: .regular
            )

            let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            chevronImageView.tintColor = .black10
            chevronImageView.contentMode = .scaleAspectFit
            chevronImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
            chevronImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true

            let seeMoreStack = UIStackView(arrangedSubviews: [seeMoreLabel, chevronImageView, UIView()])
            seeMoreStack.axis = .horizontal
            seeMoreStack.spacing = 2
            seeMoreStack.alignment = .center
            seeMoreStack.translatesAutoresizingMaskIntoConstraints = false
            seeMoreLabel.alpha = 0.8

            seeMoreStack.setContentHuggingPriority(.required, for: .horizontal)
            seeMoreStack.setContentCompressionResistancePriority(.required, for: .horizontal)

            stack.addArrangedSubview(seeMoreStack)
        }
        
        if let notification {
            let notificationLabel = StandardLabel(labelText: notification, labelFont: .comfortaa, labelType: .title3, labelColor: .black10, labelWeight: .semibold)
            
            stack.addArrangedSubview(notificationLabel)
        }
        
        return stack
    }
    
    private func makeAvatarView() -> UIView {
        let avatar = UIView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.backgroundColor = isPlusButton ? .teal30 : .blue30
        avatar.layer.cornerRadius = 22
        avatar.layer.masksToBounds = true
        avatar.layer.borderColor = isPlusButton ? UIColor.teal20.cgColor : UIColor.blue20.cgColor
        avatar.layer.borderWidth = 2

        let initials = initialsFromName(profileName)
        let initialsLabel = StandardLabel(
            labelText: isPlusButton ? "+" : initials,
            labelFont: .sfPro,
            labelType: isPlusButton ? .largeTitle : .title2,
            labelColor: .pureWhite,
            labelWeight: .medium
        )
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        avatar.addSubview(initialsLabel)

        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 44),
            avatar.heightAnchor.constraint(equalToConstant: 44),
            initialsLabel.centerXAnchor.constraint(equalTo: avatar.centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor)
        ])
        return avatar
    }
    
    func initialsFromName(_ name: String) -> String {
        let comps = name.split(separator: " ")
        let initials = comps
            .prefix(2)
            .compactMap { $0.first?.uppercased() }
            .joined()
        return initials.isEmpty ? "?" : initials
    }
}

//#Preview {
//    CareRecipientCard(name: "Karlisson Oliveira", age: 68, frame: CGRect(x: 0, y: 0, width: 300, height: 90))
//}
