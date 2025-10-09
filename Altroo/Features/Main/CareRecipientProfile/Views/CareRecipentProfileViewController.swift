//
//  CareRecipentProfileViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 08/10/25.
//

import UIKit
import CoreData
import SwiftUI

class CareRecipientProfileViewController: GradientNavBarViewController {
    let caregivers: [Int] = [1, 2, 3]
    var careRecipient: CareRecipient

    required init?(coder: NSCoder, careRecipient: CareRecipient) {
        self.careRecipient = careRecipient
        super.init(coder: coder)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(careRecipient: CareRecipient) {
        self.careRecipient = careRecipient
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileHeader()
        caregiversSection()
    }

    private func setupProfileHeader() {
        let header = ProfileHeader(careRecipient: careRecipient)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
       
    }
    
    private func caregiversSection() {
        let caregiversSectionLabel = StandardLabel(
            labelText: "Cuidadores",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        caregiversSectionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(caregiversSectionLabel)

        let cardsStack = UIStackView()
        cardsStack.axis = .vertical
        cardsStack.spacing = 12
        cardsStack.alignment = .fill
        cardsStack.distribution = .fill
        cardsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardsStack)

        NSLayoutConstraint.activate([
            caregiversSectionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 180), 
            caregiversSectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            cardsStack.topAnchor.constraint(equalTo: caregiversSectionLabel.bottomAnchor, constant: 12),
            cardsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardsStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        for _ in caregivers {
            let card = CaregiverProfileCardView()
            card.translatesAutoresizingMaskIntoConstraints = false
            cardsStack.addArrangedSubview(card)

            card.heightAnchor.constraint(equalToConstant: 72).isActive = true
        }
    }
}

private func makePreviewRecipient() -> CareRecipient {
    let ctx = previewContextViaContainer()

    let recipient = CareRecipient(context: ctx)
    let personal = PersonalData(context: ctx)

    personal.name = "Karlison Oliveira"
    personal.dateOfBirth = Calendar.current.date(byAdding: .year, value: -86, to: Date())
    personal.height = 1.98
    personal.weight = 45

    recipient.personalData = personal
    personal.careRecipient = recipient
    
    try? ctx.save()
    ctx.processPendingChanges()

    return recipient
}

#Preview() {
    UINavigationController(rootViewController:  CareRecipientProfileViewController(careRecipient: makePreviewRecipient()))
   
}

private func previewContextViaContainer() -> NSManagedObjectContext {
    let container = NSPersistentContainer(name: "AltrooDataModel")
    let desc = NSPersistentStoreDescription()
    desc.type = NSInMemoryStoreType
    container.persistentStoreDescriptions = [desc]
    container.loadPersistentStores { _, error in
        if let error { assertionFailure("Preview Core Data error: \(error)") }
    }
    return container.viewContext
}


