//
//  HealthProblemsSectionView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/11/25.
//

import UIKit

final class HealthProblemsSectionView: UIView {

    init(
        diseasesText: String,
        surgeryItems: [SurgeryDisplayItem],
        allergiesText: String,
        observationText: String,
        editTarget: AnyObject?,
        editAction: Selector?
    ) {
        super.init(frame: .zero)
        setupView()
        buildLayout(
            diseasesText: diseasesText,
            surgeryItems: surgeryItems,
            allergiesText: allergiesText,
            observationText: observationText,
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
        diseasesText: String,
        surgeryItems: [SurgeryDisplayItem],
        allergiesText: String,
        observationText: String,
        editTarget: AnyObject?,
        editAction: Selector?
    ) {
        let headerView = MedicalRecordSectionHeader(
            title: "Problemas de Saúde",
            icon: "heart.fill",
            editTarget: editTarget,
            editAction: editAction
        )

        let bodyStackView = UIStackView()
        bodyStackView.axis = .vertical
        bodyStackView.spacing = 12
        bodyStackView.translatesAutoresizingMaskIntoConstraints = false

        let diseasesRow: InformationRow = ("Doenças", diseasesText)
        let diseasesSubsection = MedicalRecordSubsectionView(
            row: diseasesRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        let surgeriesRow: InformationRow = surgeryItems.isEmpty
            ? ("Cirurgias", "Sem registro")
            : ("Cirurgias", "")
        let surgeriesSubsection = MedicalRecordSubsectionView(
            row: surgeriesRow,
            surgeryDisplayItems: surgeryItems,
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        let allergiesRow: InformationRow = ("Alergias", allergiesText)
        let allergiesSubsection = MedicalRecordSubsectionView(
            row: allergiesRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        let observationRow: InformationRow = ("Observação", observationText)
        let observationSubsection = MedicalRecordSubsectionView(
            row: observationRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        bodyStackView.addArrangedSubview(diseasesSubsection)
        bodyStackView.addArrangedSubview(surgeriesSubsection)
        bodyStackView.addArrangedSubview(allergiesSubsection)
        bodyStackView.addArrangedSubview(observationSubsection)

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
