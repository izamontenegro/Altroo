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
    
    init(name: String, notification: String? = nil, careRecipient: CareRecipient? = nil, isPlusButton: Bool = false, frame: CGRect = .zero) {
        self.profileName = name
        self.notification = notification
        self.careRecipient = careRecipient
        self.isPlusButton = isPlusButton
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
           
           let mainStack = UIStackView(arrangedSubviews: [avatarView, contentStack])
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
