//
//  MockCareRecipientBuilder.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 12/10/25.
//


import Foundation

final class MockCareRecipientBuilder {
    func build() -> CareRecipient {
        let stack = CoreDataStack.shared
        let service = CoreDataService(stack: stack)

        let personalData = PersonalData(context: stack.context)
        personalData.name = "Raissa Parente"
        personalData.address = "Rua das Acácias, 123 - Fortaleza, CE"
        personalData.gender = "Feminino"
        personalData.dateOfBirth = Calendar.current.date(from: DateComponents(year: 1957, month: 8, day: 15))
        personalData.height = 1.62
        personalData.weight = 64.5

        let health = HealthProblems(context: stack.context)
        health.allergies = ["Pólen", "Poeira (Rinite)"]
        health.surgery = ["Redução de Estômago — 12/06/2003"]
        health.observation = "Queda em 21/03/2021, fraturou o braço"

        let mental = MentalState(context: stack.context)
        mental.cognitionState = "Baixa capacidade"
        mental.memoryState = "Esquecimento frequente"
        mental.emotionalState = "Deprimido | Calmo"
        mental.orientationState = "Desorientação em espaço, tempo, pessoas"

        let physical = PhysicalState(context: stack.context)
        physical.mobilityState = "Acamado sem movimentação"
        physical.hearingState = "Comprometida"
        physical.visionState = "Completa"
        physical.oralHealthState = "Uso de prótese dentária"

        let care = PersonalCare(context: stack.context)
        care.bathState = "Ajuda parcial"
        care.hygieneState = "Baixa dependência"
        care.excretionState = "Usa fralda"
        care.feedingState = "Alimentação pastosa"
        care.equipmentState = "Sonda, Bolsa de colostomia, Soro intravenoso"

        let recipient = CareRecipient(context: stack.context)
        recipient.personalData = personalData
        recipient.healthProblems = health
        recipient.mentalState = mental
        recipient.physicalState = physical
        recipient.personalCare = care

        health.careRecipient = recipient
        mental.careRecipient = recipient
        physical.careRecipient = recipient
        care.careRecipient = recipient
        personalData.careRecipient = recipient

        service.save()
        return recipient
    }
}