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
        emergencyContact: String,
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
        emergencyContact: String,
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

        let nameRow: InformationRow = ("Nome", name)
        let nameSubsection = MedicalRecordSubsectionView(
            row: nameRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )
        
        let birthRow: InformationRow = ("Data de Nascimento", birthDate)
        let weightRow: InformationRow = ("Peso", weight)
        let heightRow: InformationRow = ("Altura", height)

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
        let addressRow: InformationRow = ("Endereço", addressText.isEmpty ? "Sem registro" : addressText)
        let addressSubsection = MedicalRecordSubsectionView(
            row: addressRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        let contactText = emergencyContact.trimmingCharacters(in: .whitespacesAndNewlines)
        let contactRow: InformationRow = ("Contato de Emergência", contactText.isEmpty ? "Sem registro" : contactText)
        let contactSubsection = MedicalRecordSubsectionView(
            row: contactRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: copyTarget,
            copyAction: copyAction
        )

        bodyStackView.addArrangedSubview(nameSubsection)
        bodyStackView.addArrangedSubview(topHStack)
        bodyStackView.addArrangedSubview(addressSubsection)
        bodyStackView.addArrangedSubview(contactSubsection)

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
