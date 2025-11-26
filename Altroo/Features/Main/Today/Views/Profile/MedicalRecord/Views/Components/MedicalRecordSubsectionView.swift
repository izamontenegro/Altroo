//
//  MedicalRecordSubsectionView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/11/25.
//
import UIKit

enum MedicalRecordSubsectionType {
    case surgeries
    case contact
    case normal
}

final class MedicalRecordSubsectionView: UIView {
    
    private let row: InformationRow
    private let surgeryDisplayItems: [SurgeryDisplayItem]
    private let contactDisplayItems: [ContactDisplayItem]
    private let copyTarget: AnyObject?
    private let copyAction: Selector?
    
    init(
        row: InformationRow,
        surgeryDisplayItems: [SurgeryDisplayItem],
        contactDisplayItems: [ContactDisplayItem],
        copyTarget: AnyObject?,
        copyAction: Selector?
    ) {
        self.row = row
        self.surgeryDisplayItems = surgeryDisplayItems
        self.contactDisplayItems = contactDisplayItems
        self.copyTarget = copyTarget
        self.copyAction = copyAction
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let type: MedicalRecordSubsectionType
        let headerTitle: String
        
        print(row.value)
        
        if row.title == "Cirurgias",
           row.value.isEmpty,
           !surgeryDisplayItems.isEmpty {
            type = .surgeries
            headerTitle = "Cirurgias"
        } else if row.title == "emergency_contact".localized,
                  row.value.isEmpty,
                  !contactDisplayItems.isEmpty {
            type = .contact
            headerTitle = "emergency_contact".localized
        } else {
            type = .normal
            headerTitle = row.title
        }
        
        let titleLabel = StandardLabel(
            labelText: headerTitle,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .blue20,
            labelWeight: .regular
        )

        let headerStack = UIStackView(arrangedSubviews: [titleLabel])
        headerStack.axis = .vertical
        headerStack.spacing = 2
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 2
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .normal:
            let valueLabel = StandardLabel(
                labelText: row.value,
                labelFont: .sfPro,
                labelType: .body,
                labelColor: .black10,
                labelWeight: .regular
            )
            if row.value.first == "•" {
                valueLabel.numberOfLines = 0
            } else {
                valueLabel.numberOfLines = 2
            }
            
            contentStack.addArrangedSubview(valueLabel)
            
        case .surgeries:
            for surgery in surgeryDisplayItems {
                let itemView = MedicalRecordInfoItemView(
                    infotitle: "",
                    primaryText: surgery.primary,
                    secondaryText: surgery.secondary
                )
                contentStack.addArrangedSubview(itemView)
            }
            
        case .contact:
            for contact in contactDisplayItems {
                let cardView = ContactCardView(
                    name: contact.name,
                    relation: contact.relationship,
                    phone: contact.phone,
                    copyTarget: copyTarget,
                    copyAction: copyAction ?? #selector(UIView.didMoveToSuperview)
                )
                contentStack.addArrangedSubview(cardView)
            }
        }
        
        let wrapperStack = UIStackView(arrangedSubviews: [headerStack, contentStack])
        wrapperStack.axis = .vertical
        wrapperStack.spacing = 4
        wrapperStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(wrapperStack)
        
        NSLayoutConstraint.activate([
            wrapperStack.topAnchor.constraint(equalTo: topAnchor),
            wrapperStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            wrapperStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            wrapperStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
