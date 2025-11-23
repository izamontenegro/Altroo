//
//  MedicalRecordSectionView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/11/25.
//
import UIKit

final class MedicalRecordSectionView: UIView {

    init(
        title: String,
        iconSystemName: String,
        rows: [InformationRow],
        surgeryDisplayItems: [SurgeryDisplayItem],
        contactDisplayItems: [ContactDisplayItem],
        copyTarget: AnyObject?,
        copyAction: Selector
    ) {
        super.init(frame: .zero)
        setupView()
        buildLayout(
            title: title,
            iconSystemName: iconSystemName,
            rows: rows,
            surgeryDisplayItems: surgeryDisplayItems,
            contactDisplayItems: contactDisplayItems,
            copyTarget: copyTarget,
            copyAction: copyAction
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
        title: String,
        iconSystemName: String,
        rows: [InformationRow],
        surgeryDisplayItems: [SurgeryDisplayItem],
        contactDisplayItems: [ContactDisplayItem],
        copyTarget: AnyObject?,
        copyAction: Selector
    ) {
        let headerView = MedicalRecordSectionHeader(title: title, icon: iconSystemName)

        let bodyStackView = UIStackView()
        bodyStackView.axis = .vertical
        bodyStackView.spacing = 10
        bodyStackView.translatesAutoresizingMaskIntoConstraints = false

        for row in rows {
            let subsection = MedicalRecordSubsectionView(
                row: row,
                surgeryDisplayItems: surgeryDisplayItems,
                contactDisplayItems: contactDisplayItems,
                copyTarget: copyTarget,
                copyAction: copyAction
            )
            bodyStackView.addArrangedSubview(subsection)
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
