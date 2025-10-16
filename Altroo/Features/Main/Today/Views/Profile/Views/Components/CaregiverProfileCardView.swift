//
//  Untitled.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 09/10/25.
//
//
import UIKit
import CloudKit

class CaregiverProfileCardView: UIView {
    let name: String
    let category: String
    let permission: CKShare.Participant.Permission

    init(name: String, category: String, permission: CKShare.Participant.Permission) {
        self.name = name
        self.category = category
        self.permission = permission
        super.init(frame: .zero)
        buildLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildLayout() {
        backgroundColor = UIColor.blue80
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false

        let avatar = makeAvatarView()
        let nameStack = makeNameStack()
        let accessButton = makeAccessButton()

        addSubview(avatar)
        addSubview(nameStack)
        addSubview(accessButton)

        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatar.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 34),
            avatar.heightAnchor.constraint(equalToConstant: 34),

            nameStack.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            nameStack.centerYAnchor.constraint(equalTo: centerYAnchor),

            accessButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            accessButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameStack.trailingAnchor.constraint(lessThanOrEqualTo: accessButton.leadingAnchor, constant: -12),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 54)
        ])
    }

    // MARK: - Subviews
    private func makeAvatarView() -> UIView {
        let avatar = UIView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.backgroundColor = .blue30
        avatar.layer.cornerRadius = 17
        avatar.layer.masksToBounds = true
        avatar.layer.borderColor = UIColor.pureWhite.cgColor
        avatar.layer.borderWidth = 2

        let initials = initialsFromName(name)
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

    private func makeNameStack() -> UIStackView {
        let nameLabel = StandardLabel(
            labelText: name,
            labelFont: .sfPro,
            labelType: .subHeadline,
            labelColor: .black10,
            labelWeight: .medium
        )

       
        let subtitleLabel = StandardLabel(
            labelText: "Cuidador",
            labelFont: .sfPro,
            labelType: .footnote,
            labelColor: .black20,
            labelWeight: .regular
        )

        let stack = UIStackView(arrangedSubviews: [nameLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }

    private func makeAccessButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .blue10
        button.backgroundColor = .clear

        let titleLabel = StandardLabel(
            labelText: permissionLabel(permission),
            labelFont: .sfPro,
            labelType: .subHeadline,
            labelColor: .blue10,
            labelWeight: .medium
        )
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let chevron = UIImageView(image: UIImage(systemName: "chevron.down"))
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.tintColor = .blue10
        chevron.preferredSymbolConfiguration = .init(pointSize: 14, weight: .semibold)
        chevron.layer.opacity = 0.0

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
    }
}

// MARK: - Helpers
private extension CaregiverProfileCardView {
    func didTapAccess() {
        print("tapped")
    }

    func initialsFromName(_ name: String) -> String {
        let comps = name.split(separator: " ")
        let initials = comps.prefix(2).compactMap { $0.first?.uppercased() }.joined()
        return initials.isEmpty ? "?" : initials
    }

    func permissionLabel(_ participantPermission: CKShare.ParticipantPermission) -> String {
        switch participantPermission {
        case .readOnly:  return "Pode visualizar"
        case .readWrite: return "Pode editar"
        case .none:      return "Sem acesso"
        default:         return "Pode visualizar"
        }
    }
}
