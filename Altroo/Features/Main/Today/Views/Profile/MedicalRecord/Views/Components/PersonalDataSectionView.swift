//
//  PersonalDataSectionView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/11/25.
//
import UIKit

final class PersonalDataSectionView: UIView {

    init(
        name: String,
        birthDate: String,
        weight: String,
        height: String,
        address: String,
        emergencyContact: ContactDisplayItem?,
        copyTarget: AnyObject?,
        copyAction: Selector,
        editTarget: AnyObject?,
        editAction: Selector?
    ) {
        super.init(frame: .zero)
        setupView()
        buildLayout(
            name: name,
            birthDate: birthDate,
            weight: weight,
            height: height,
            address: address,
            emergencyContact: emergencyContact,
            copyTarget: copyTarget,
            copyAction: copyAction,
            editTarget: editTarget,
            editAction: editAction
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .blue80
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func buildLayout(
        name: String,
        birthDate: String,
        weight: String,
        height: String,
        address: String,
        emergencyContact: ContactDisplayItem?,
        copyTarget: AnyObject?,
        copyAction: Selector,
        editTarget: AnyObject?,
        editAction: Selector?
    ) {
        let headerView = MedicalRecordSectionHeader(
            title: "Dados Pessoais",
            icon: "person.fill",
            editTarget: editTarget,
            editAction: editAction
        )

        let bodyStackView = UIStackView()
        bodyStackView.axis = .vertical
        bodyStackView.spacing = 12
        bodyStackView.translatesAutoresizingMaskIntoConstraints = false

        let nameRow: InformationRow = ("name".localized, name)
        let nameSubsection = MedicalRecordSubsectionView(
            row: nameRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )
        
        let birthRow: InformationRow = ("birth_date".localized, birthDate)
        let weightRow: InformationRow = ("weight".localized, weight)
        let heightRow: InformationRow = ("height".localized, height)

        let birthSubsection = MedicalRecordSubsectionView(
            row: birthRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )
        let weightSubsection = MedicalRecordSubsectionView(
            row: weightRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )
        
        let heightSubsection = MedicalRecordSubsectionView(
            row: heightRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        let topHStack = UIStackView(arrangedSubviews: [birthSubsection, weightSubsection, heightSubsection])
        topHStack.axis = .horizontal
        topHStack.distribution = .fillProportionally
        topHStack.alignment = .top
        topHStack.translatesAutoresizingMaskIntoConstraints = false

        let addressText = address.trimmingCharacters(in: .whitespacesAndNewlines)
        let addressRow: InformationRow = ("address".localized, addressText.isEmpty ? "no_register".localized : addressText)
        let addressSubsection = MedicalRecordSubsectionView(
            row: addressRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        bodyStackView.addArrangedSubview(nameSubsection)
        bodyStackView.addArrangedSubview(topHStack)
        bodyStackView.addArrangedSubview(addressSubsection)

        if let contact = emergencyContact {
            let contactTitleLabel = StandardLabel(
                labelText: "Contato de Emergência",
                labelFont: .sfPro,
                labelType: .body,
                labelColor: .blue20,
                labelWeight: .regular
            )

            let contactCard = ContactCardView(
                name: contact.name,
                relation: contact.relationship,
                phone: contact.phone,
                copyTarget: copyTarget,
                copyAction: copyAction
            )
            contactCard.translatesAutoresizingMaskIntoConstraints = false

            let container = UIStackView(arrangedSubviews: [contactTitleLabel, contactCard])
            container.axis = .vertical
            container.spacing = 4
            container.translatesAutoresizingMaskIntoConstraints = false

            bodyStackView.addArrangedSubview(container)
        } else {
            let contactRow: InformationRow = ("Contato de Emergência", "no_register".localized)
            let contactSubsection = MedicalRecordSubsectionView(
                row: contactRow,
                surgeryDisplayItems: [],
                contactDisplayItems: [],
                copyTarget: nil,
                copyAction: nil
            )
            bodyStackView.addArrangedSubview(contactSubsection)
        }

        addSubview(headerView)
        addSubview(bodyStackView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 36),

            bodyStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            bodyStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            bodyStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            bodyStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}
