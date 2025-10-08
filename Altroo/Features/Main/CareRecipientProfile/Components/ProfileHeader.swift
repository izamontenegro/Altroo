//
//  ProfileHeader.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 08/10/25.
//

import UIKit

final class ProfileCardView: InnerShadowView {
    init() {
        super.init(frame: .zero, color: UIColor.blue70)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension ProfileCardView {
    func setupUI() {
        backgroundColor = .white70
        layer.cornerRadius = 8

        let avatar = UIView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.backgroundColor = .blue30
        avatar.layer.cornerRadius = 35
        avatar.layer.masksToBounds = true
        avatar.layer.borderColor = UIColor.pureWhite.cgColor
        avatar.layer.borderWidth = 4

        let initialsLabel = StandardLabel(labelText: "KO", labelFont: .sfPro, labelType: .title1, labelColor: .pureWhite, labelWeight: .regular)
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        avatar.addSubview(initialsLabel)

        let nameLabel = StandardLabel(labelText: "Karlison Oliveira", labelFont: .sfPro, labelType: .title2, labelColor: .blue20, labelWeight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        func title(_ text: String) -> UILabel {
            let l = UILabel()
            l.translatesAutoresizingMaskIntoConstraints = false
            l.font = .systemFont(ofSize: 18, weight: .semibold)
            l.textColor = .label
            l.text = text
            return l
        }
        func value() -> UILabel {
            let l = UILabel()
            l.translatesAutoresizingMaskIntoConstraints = false
            l.font = .systemFont(ofSize: 18, weight: .regular)
            l.textColor = .label
            return l
        }

        let nascimentoTitle = StandardLabel(labelText: "Nascimento", labelFont: .sfPro, labelType: .subHeadline, labelColor: .black20, labelWeight: .semibold)
        
        let nascimentoValue = StandardLabel(labelText: "03/03/1993 (86 anos)", labelFont: .sfPro, labelType: .subHeadline, labelColor: .black20, labelWeight: .regular)
        
        let pesoTitle = StandardLabel(labelText: "Peso", labelFont: .sfPro, labelType: .subHeadline, labelColor: .black20, labelWeight: .semibold)
        
        let pesoValue = StandardLabel(labelText: "45kg", labelFont: .sfPro, labelType: .subHeadline, labelColor: .black20, labelWeight: .regular)
        
        let alturaTitle = StandardLabel(labelText: "Altura", labelFont: .sfPro, labelType: .subHeadline, labelColor: .black20, labelWeight: .semibold)
        
        let alturaValue = StandardLabel(labelText: "1,98m", labelFont: .sfPro, labelType: .subHeadline, labelColor: .black20, labelWeight: .regular)

        let nascimentoRow = UIStackView(arrangedSubviews: [nascimentoTitle, nascimentoValue])
        nascimentoRow.axis = .horizontal
        nascimentoRow.alignment = .firstBaseline
        nascimentoRow.spacing = 4

        let pesoRow = UIStackView(arrangedSubviews: [pesoTitle, pesoValue])
        pesoRow.axis = .horizontal
        pesoRow.alignment = .firstBaseline
        pesoRow.spacing = 4

        let alturaRow = UIStackView(arrangedSubviews: [alturaTitle, alturaValue])
        alturaRow.axis = .horizontal
        alturaRow.alignment = .firstBaseline
        alturaRow.spacing = 4

        let bottomRow = UIStackView(arrangedSubviews: [pesoRow, UIView(), alturaRow])
        bottomRow.axis = .horizontal
        bottomRow.alignment = .firstBaseline
        bottomRow.spacing = 12
        bottomRow.translatesAutoresizingMaskIntoConstraints = false

        let vStack = UIStackView(arrangedSubviews: [nameLabel, nascimentoRow, bottomRow])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 3
        vStack.translatesAutoresizingMaskIntoConstraints = false

        let hStack = UIStackView(arrangedSubviews: [avatar, vStack])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 15
        hStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(hStack)

        let medicalRecordProgressCard = UIView()
        medicalRecordProgressCard.translatesAutoresizingMaskIntoConstraints = false
        medicalRecordProgressCard.backgroundColor = .blue20
        medicalRecordProgressCard.layer.cornerRadius = 8

        let medicalRecordLabel = StandardLabel(
            labelText: "Ficha médica",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .pureWhite,
            labelWeight: .medium
        )

        let progressTrack = UIView()
        progressTrack.translatesAutoresizingMaskIntoConstraints = false
        progressTrack.backgroundColor = .blue60
        progressTrack.layer.cornerRadius = 5

        let progressFill = UIView()
        progressFill.translatesAutoresizingMaskIntoConstraints = false
        progressFill.backgroundColor = .pureWhite
        progressFill.layer.cornerRadius = 5

        progressTrack.addSubview(progressFill)

        let percentageLabel = StandardLabel(
            labelText: "80%",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .pureWhite,
            labelWeight: .medium
        )

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.tintColor = .pureWhite

        let medicalRecordHStack = UIStackView(arrangedSubviews: [medicalRecordLabel, progressTrack, percentageLabel, chevron])
        medicalRecordHStack.translatesAutoresizingMaskIntoConstraints = false
        medicalRecordHStack.axis = .horizontal
        medicalRecordHStack.alignment = .center
        medicalRecordHStack.spacing = 12
        medicalRecordHStack.distribution = .fill

        medicalRecordProgressCard.addSubview(medicalRecordHStack)
        addSubview(medicalRecordProgressCard)

        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 70),
            avatar.heightAnchor.constraint(equalToConstant: 70),
            initialsLabel.centerXAnchor.constraint(equalTo: avatar.centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),

            hStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),

            medicalRecordProgressCard.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 10),
            medicalRecordProgressCard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            medicalRecordProgressCard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            medicalRecordProgressCard.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),

            medicalRecordHStack.topAnchor.constraint(equalTo: medicalRecordProgressCard.topAnchor, constant: 16),
            medicalRecordHStack.leadingAnchor.constraint(equalTo: medicalRecordProgressCard.leadingAnchor, constant: 16),
            medicalRecordHStack.trailingAnchor.constraint(equalTo: medicalRecordProgressCard.trailingAnchor, constant: -16),
            medicalRecordHStack.bottomAnchor.constraint(equalTo: medicalRecordProgressCard.bottomAnchor, constant: -16),

            progressTrack.heightAnchor.constraint(equalToConstant: 8),
            progressTrack.widthAnchor.constraint(greaterThanOrEqualToConstant: 110),

            progressFill.leadingAnchor.constraint(equalTo: progressTrack.leadingAnchor),
            progressFill.centerYAnchor.constraint(equalTo: progressTrack.centerYAnchor),
            progressFill.heightAnchor.constraint(equalTo: progressTrack.heightAnchor),
            progressFill.widthAnchor.constraint(equalTo: progressTrack.widthAnchor, multiplier: 0.70),

            chevron.widthAnchor.constraint(equalToConstant: 10),
            chevron.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
}

//private func previewContextViaContainer() -> NSManagedObjectContext {
//    let container = NSPersistentContainer(name: "AltrooDataModel")
//    let desc = NSPersistentStoreDescription()
//    desc.type = NSInMemoryStoreType
//    container.persistentStoreDescriptions = [desc]
//    container.loadPersistentStores { _, error in
//        if let error { assertionFailure("Preview Core Data error: \(error)") }
//    }
//    return container.viewContext
//}
//
//#Preview {
//    let ctx = previewContextViaContainer()
//    let recipient = CareRecipient(context: ctx)
//
//    ProfileHeader(careRecipient: recipient)
//}

#Preview {
    ProfileCardView()
}
