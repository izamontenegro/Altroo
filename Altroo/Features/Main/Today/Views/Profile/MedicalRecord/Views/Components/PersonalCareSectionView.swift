//
//  PersonalCareSectionView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/11/25.
//
import UIKit

final class PersonalCareSectionView: UIView {

    init(
        bath: String,
        hygiene: String,
        excretion: String,
        feeding: String,
        equipment: String,
        editTarget: AnyObject?,
        editAction: Selector?
    ) {
        super.init(frame: .zero)
        setupView()
        buildLayout(
            bath: bath,
            hygiene: hygiene,
            excretion: excretion,
            feeding: feeding,
            equipment: equipment,
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
        bath: String,
        hygiene: String,
        excretion: String,
        feeding: String,
        equipment: String,
        editTarget: AnyObject?,
        editAction: Selector?
    ) {
        let headerView = MedicalRecordSectionHeader(
            title: "Cuidados Pessoais",
            icon: "hand.raised.fill",
            editTarget: editTarget,
            editAction: editAction
        )

        let bodyStackView = UIStackView()
        bodyStackView.axis = .vertical
        bodyStackView.spacing = 12
        bodyStackView.translatesAutoresizingMaskIntoConstraints = false

        // Coluna esquerda: Banho + Excreção
        let bathRow: InformationRow = ("Banho", bath)
        let bathSubsection = MedicalRecordSubsectionView(
            row: bathRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        let excretionRow: InformationRow = ("Excreção", excretion)
        let excretionSubsection = MedicalRecordSubsectionView(
            row: excretionRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        let leftColumn = UIStackView(arrangedSubviews: [bathSubsection, excretionSubsection])
        leftColumn.axis = .vertical
        leftColumn.spacing = 12
        leftColumn.translatesAutoresizingMaskIntoConstraints = false

        // Coluna direita: Higiene Pessoal + Alimentação
        let hygieneRow: InformationRow = ("Higiene Pessoal", hygiene)
        let hygieneSubsection = MedicalRecordSubsectionView(
            row: hygieneRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        let feedingRow: InformationRow = ("Alimentação", feeding)
        let feedingSubsection = MedicalRecordSubsectionView(
            row: feedingRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        let rightColumn = UIStackView(arrangedSubviews: [hygieneSubsection, feedingSubsection])
        rightColumn.axis = .vertical
        rightColumn.spacing = 12
        rightColumn.translatesAutoresizingMaskIntoConstraints = false

        let topColumns = UIStackView(arrangedSubviews: [leftColumn, rightColumn])
        topColumns.axis = .horizontal
        topColumns.spacing = 30
        topColumns.distribution = .fillEqually
        topColumns.translatesAutoresizingMaskIntoConstraints = false

        // Equipamentos
        let equipmentRow: InformationRow = ("Equipamentos", equipment)
        let equipmentSubsection = MedicalRecordSubsectionView(
            row: equipmentRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        bodyStackView.addArrangedSubview(topColumns)
        bodyStackView.addArrangedSubview(equipmentSubsection)

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
