//
//  Untitled.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 09/10/25.
//
//
import UIKit
import CloudKit
import CoreData

class CaregiverProfileCardView: UIView {
    let coreDataService: CoreDataService

    let name: String
    let category: String
    let permission: CKShare.Participant.Permission
    let isOwner: Bool
    
    let participant: CKShare.Participant
    let parentObject: NSManagedObject

    init(coreDataService: CoreDataService,
         participant: CKShare.Participant,
         parentObject: NSManagedObject,
         name: String,
         category: String,
         permission: CKShare.Participant.Permission,
         isOwner: Bool) {

        self.coreDataService = coreDataService
        self.participant = participant
        self.parentObject = parentObject
        self.name = name
        self.category = category
        self.permission = permission
        self.isOwner = isOwner
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

        let initialsLabel = StandardLabel(
            labelText: name.getInitials(),
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
            labelText: participant.role == .owner ? "Criador" : "Cuidador",
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
        chevron.isHidden = (!isOwner) || (participant.role == .owner)
        
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

        if isOwner && participant.role != .owner {
            button.menu = makeOwnerMenu()
            button.showsMenuAsPrimaryAction = true
            button.enableHighlightEffect()
        }

        return button
    }
}

// MARK: - Helpers
private extension CaregiverProfileCardView {

    func initialsFromName(_ name: String) -> String {
        let comps = name.split(separator: " ")
        let initials = comps.prefix(2).compactMap { $0.first?.uppercased() }.joined()
        return initials.isEmpty ? "?" : initials
    }

    func permissionLabel(_ participantPermission: CKShare.ParticipantPermission) -> String {
        switch participantPermission {
        case .readOnly:  return "Pode Visualizar"
        case .readWrite: return "Pode Editar"
        case .none:      return "Sem Acesso"
        default:         return "Pode Visualizar"
        }
    }
    
    func setPermission(_ newPermission: CKShare.ParticipantPermission) {
        coreDataService.updateParticipantPermission(
            for: parentObject,
            participant: participant,
            to: newPermission
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Permissão alterada para \(newPermission)")
                case .failure(let error):
                    print("Erro ao atualizar permissão:", error)
                }
            }
        }
    }

    func removeCaregiver() {
        coreDataService.removeParticipant(
            participant,
            from: parentObject
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Cuidador removido!")
                case .failure(let error):
                    print("Erro ao remover cuidador:", error)
                }
            }
        }
    }
    
    private func makeOwnerMenu() -> UIMenu {
        let current = permission

        let edit = UIAction(
            title: "Pode Editar",
            image: UIImage(systemName: current == .readWrite ? "checkmark" : "")
        ) { [weak self] _ in
            self?.setPermission(.readWrite)
        }

        let viewOnly = UIAction(
            title: "Pode Visualizar",
            image: UIImage(systemName: current == .readOnly ? "checkmark" : "")
        ) { [weak self] _ in
            self?.setPermission(.readOnly)
        }

        let remove = UIAction(
            title: "Remover Cuidador",
            image: UIImage(systemName: "xmark"),
            attributes: .destructive
        ) { [weak self] _ in
            self?.removeCaregiver()
        }

        return UIMenu(
            title: "",
            options: [.displayInline],
            children: [edit, viewOnly, remove]
        )
    }

}
