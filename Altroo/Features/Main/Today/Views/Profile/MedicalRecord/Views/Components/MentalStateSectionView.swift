//
//  MentalStateSectionView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/11/25.
//
import UIKit

final class MentalStateSectionView: UIView {

    init(
        emotionalState: String,
        orientationState: String,
        memoryState: String,
        editTarget: AnyObject?,
        editAction: Selector?
    ) {
        super.init(frame: .zero)
        setupView()
        buildLayout(
            emotionalState: emotionalState,
            orientationState: orientationState,
            memoryState: memoryState,
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
        emotionalState: String,
        orientationState: String,
        memoryState: String,
        editTarget: AnyObject?,
        editAction: Selector?
    ) {
        let headerView = MedicalRecordSectionHeader(
            title: "Estado Mental",
            icon: "brain.head.profile.fill",
            editTarget: editTarget,
            editAction: editAction
        )

        let bodyStackView = UIStackView()
        bodyStackView.axis = .vertical
        bodyStackView.spacing = 12
        bodyStackView.translatesAutoresizingMaskIntoConstraints = false

        let emotionalRow: InformationRow = ("Estado Emocional", emotionalState)
        let emotionalSubsection = MedicalRecordSubsectionView(
            row: emotionalRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        let orientationRow: InformationRow = ("Orientação", orientationState)
        let orientationSubsection = MedicalRecordSubsectionView(
            row: orientationRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        let memoryRow: InformationRow = ("Memória", memoryState)
        let memorySubsection = MedicalRecordSubsectionView(
            row: memoryRow,
            surgeryDisplayItems: [],
            contactDisplayItems: [],
            copyTarget: nil,
            copyAction: nil
        )

        bodyStackView.addArrangedSubview(emotionalSubsection)
        bodyStackView.addArrangedSubview(orientationSubsection)
        bodyStackView.addArrangedSubview(memorySubsection)

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
