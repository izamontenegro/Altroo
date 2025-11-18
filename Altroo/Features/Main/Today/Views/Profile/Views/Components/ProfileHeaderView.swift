//
//  ProfileHeader.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 08/10/25.
//

import CoreData
import UIKit
import SwiftUI

final class ProfileHeader: InnerShadowView {
    var careRecipient: CareRecipient
    let percent: Double
    
    init(careRecipient: CareRecipient, percent: Double) {
        self.careRecipient = careRecipient
        self.percent = percent
        super.init(frame: .zero, color: UIColor.blue70)
        setupUI()
    }

    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init?(coder: NSCoder, careRecipient: CareRecipient, percent: Double) {
        self.careRecipient = careRecipient
        self.percent = percent
        super.init(coder: coder)
    }
}

private extension ProfileHeader {
    func setupUI() {
        backgroundColor = .white70
        layer.cornerRadius = 8

        let headerStack = setupHeaderSection()
        addSubview(headerStack)

        let medicalRecordCard = setupMedicalRecordCard()
        addSubview(medicalRecordCard)

        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            headerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            headerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),

            medicalRecordCard.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 10),
            medicalRecordCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            medicalRecordCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            medicalRecordCard.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupHeaderSection() -> UIStackView {
        let avatar = setupAvatarView()
        let infoStack = setupInfoStack()

        let horizontalStack = UIStackView(arrangedSubviews: [avatar, infoStack])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.spacing = 15
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false

        return horizontalStack
    }

    func setupAvatarView() -> UIView {
        let avatar = CareRecipientInitialsCircleView(careRecipientName: careRecipient.personalData?.name ?? "Sem nome").setupLayout()

        return avatar
    }

    func setupInfoStack() -> UIStackView {
        let data = careRecipient.personalData

        let nameText = data?.name?.abbreviatedName ?? "Nome não informado"
        let birthText = DateFormatterHelper.birthDateFormatter(from: data?.dateOfBirth)
        let weightText = formattedWeight(from: data?.weight)
        let heightText = formattedHeight(from: data?.height)

        let nameLabel = StandardLabel(
            labelText: nameText,
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .blue20,
            labelWeight: .semibold
        )
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let birthTitle = StandardLabel(labelText: "Nascimento", labelFont: .sfPro, labelType: .subHeadline, labelColor: .black20, labelWeight: .semibold)
        let birthValue = StandardLabel(labelText: birthText, labelFont: .sfPro, labelType: .subHeadline, labelColor: .black20, labelWeight: .regular)
        let birthRow = horizontalRow([birthTitle, birthValue])

        let weightTitle = StandardLabel(labelText: "weight".localized, labelFont: .sfPro, labelType: .subHeadline, labelColor: .black20, labelWeight: .semibold)
        let weightValue = StandardLabel(labelText: weightText, labelFont: .sfPro, labelType: .subHeadline, labelColor: .black20, labelWeight: .regular)
        let weightRow = horizontalRow([weightTitle, weightValue])

        let heightTitle = StandardLabel(labelText: "Altura", labelFont: .sfPro, labelType: .subHeadline, labelColor: .black20, labelWeight: .semibold)
        let heightValue = StandardLabel(labelText: heightText, labelFont: .sfPro, labelType: .subHeadline, labelColor: .black20, labelWeight: .regular)
        let heightRow = horizontalRow([heightTitle, heightValue])

        let bottomRow = UIStackView(arrangedSubviews: [weightRow, UIView(), heightRow])
        bottomRow.axis = .horizontal
        bottomRow.alignment = .firstBaseline
        bottomRow.spacing = 12
        bottomRow.translatesAutoresizingMaskIntoConstraints = false

        let verticalStack = UIStackView(arrangedSubviews: [nameLabel, birthRow, bottomRow])
        verticalStack.axis = .vertical
        verticalStack.alignment = .leading
        verticalStack.spacing = 3
        verticalStack.translatesAutoresizingMaskIntoConstraints = false

        return verticalStack
    }

    func horizontalRow(_ views: [UIView]) -> UIStackView {
        let row = UIStackView(arrangedSubviews: views)
        row.axis = .horizontal
        row.alignment = .firstBaseline
        row.spacing = 4
        row.translatesAutoresizingMaskIntoConstraints = false
        return row
    }

    func setupMedicalRecordCard() -> UIView {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .blue20
        card.layer.cornerRadius = 8

        let label = StandardLabel(
            labelText: "Ficha médica",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .pureWhite,
            labelWeight: .medium
        )

        let track = UIView()
        track.translatesAutoresizingMaskIntoConstraints = false
        track.backgroundColor = .blue60
        track.layer.cornerRadius = 5

        let fill = UIView()
        fill.translatesAutoresizingMaskIntoConstraints = false
        fill.backgroundColor = .pureWhite
        fill.layer.cornerRadius = 5
        track.addSubview(fill)
        
        let percentageLabel = StandardLabel(
            labelText: "\(Int(round(percent * 100)))%",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .pureWhite,
            labelWeight: .medium
        )

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.tintColor = .pureWhite

        let stack = UIStackView(arrangedSubviews: [label, track, percentageLabel, chevron])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),

            track.heightAnchor.constraint(equalToConstant: 8),
            track.widthAnchor.constraint(greaterThanOrEqualToConstant: 110),
            fill.leadingAnchor.constraint(equalTo: track.leadingAnchor),
            fill.centerYAnchor.constraint(equalTo: track.centerYAnchor),
            fill.heightAnchor.constraint(equalTo: track.heightAnchor),
            fill.widthAnchor.constraint(equalTo: track.widthAnchor, multiplier: percent),

            chevron.widthAnchor.constraint(equalToConstant: 10),
            chevron.heightAnchor.constraint(equalToConstant: 16)
        ])

        return card
    }
}

// MARK: - Helpers
private extension ProfileHeader {

    func formattedWeight(from weight: Double?) -> String {
        guard let weight else { return "—" }
        return String(format: "%.1f kg", weight)
    }

    func formattedHeight(from height: Double?) -> String {
        guard let height else { return "—" }
        return String(format: "%.0f cm", height)
    }
}
