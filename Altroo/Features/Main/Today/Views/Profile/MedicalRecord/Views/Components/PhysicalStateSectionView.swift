//
//  PhysicalStateSectionView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/11/25.
//
import UIKit

final class PhysicalStateSectionView: UIView {

    init(
        vision: String,
        hearing: String,
        mobility: String,
        oralHealth: String,
        editTarget: AnyObject?,
        editAction: Selector?
    ) {
        super.init(frame: .zero)
        setupView()
        buildLayout(
            vision: vision,
            hearing: hearing,
            mobility: mobility,
            oralHealth: oralHealth,
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
        vision: String,
        hearing: String,
        mobility: String,
        oralHealth: String,
        editTarget: AnyObject?,
        editAction: Selector?
    ) {
        let headerView = MedicalRecordSectionHeader(
            title: "Estado físico",
            icon: "figure",
            editTarget: editTarget,
            editAction: editAction
        )

        let bodyStackView = UIStackView()
        bodyStackView.axis = .vertical
        bodyStackView.spacing = 12
        bodyStackView.translatesAutoresizingMaskIntoConstraints = false

        let visionRow: InformationRow = ("Visão", vision)
        let visionSubsection = MedicalRecordSubsectionView(
            row: visionRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        let mobilityRow: InformationRow = ("Locomoção", mobility)
        let mobilitySubsection = MedicalRecordSubsectionView(
            row: mobilityRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        let leftColumn = UIStackView(arrangedSubviews: [visionSubsection, mobilitySubsection])
        leftColumn.axis = .vertical
        leftColumn.spacing = 12
        leftColumn.translatesAutoresizingMaskIntoConstraints = false

        let hearingRow: InformationRow = ("Audição", hearing)
        let hearingSubsection = MedicalRecordSubsectionView(
            row: hearingRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        let oralRow: InformationRow = ("Saúde bucal", oralHealth)
        let oralSubsection = MedicalRecordSubsectionView(
            row: oralRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        let rightColumn = UIStackView(arrangedSubviews: [hearingSubsection, oralSubsection])
        rightColumn.axis = .vertical
        rightColumn.spacing = 12
        rightColumn.translatesAutoresizingMaskIntoConstraints = false

        let columnsStack = UIStackView(arrangedSubviews: [leftColumn, rightColumn])
        columnsStack.axis = .horizontal
        columnsStack.spacing = 30
        columnsStack.distribution = .fillEqually
        columnsStack.translatesAutoresizingMaskIntoConstraints = false

        bodyStackView.addArrangedSubview(columnsStack)

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
