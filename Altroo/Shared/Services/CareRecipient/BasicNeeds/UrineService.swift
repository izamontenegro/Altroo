//
//  UrineService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/09/25.
//

import Foundation
import CoreData

protocol UrineServiceProtocol {
    @discardableResult
    func addUrineRecord(
        period: PeriodEnum,
        date: Date,
        color: String,
        characteristic: UrineCharacteristicsEnum?,
        observation: String?,
        to careRecipient: CareRecipient
    ) -> UrineRecord?

    func updateUrineRecord(
        _ record: UrineRecord,
        period: PeriodEnum?,
        date: Date?,
        color: String?,
        characteristic: UrineCharacteristicsEnum?,
        observation: String?
    )

    func deleteUrineRecord(_ record: UrineRecord, from careRecipient: CareRecipient)

    func urineRecord(with id: UUID, for careRecipient: CareRecipient) -> UrineRecord?
}

final class UrineService: UrineServiceProtocol {

    // MARK: - Create
    @discardableResult
    func addUrineRecord(
        period: PeriodEnum,
        date: Date,
        color: String,
        characteristic: UrineCharacteristicsEnum?,
        observation: String?,
        to careRecipient: CareRecipient
    ) -> UrineRecord? {

        guard let context = careRecipient.managedObjectContext else { return nil }
        let newUrineRecord = UrineRecord(context: context)

        newUrineRecord.id = UUID()
        newUrineRecord.color = color
        newUrineRecord.date = date
        newUrineRecord.period = period.rawValue
        newUrineRecord.urineCharacteristics = characteristic?.rawValue
        newUrineRecord.urineObservation = observation

        if let basicNeeds = careRecipient.basicNeeds {
            let set = basicNeeds.mutableSetValue(forKey: "urine")
            set.add(newUrineRecord)
        }
        return newUrineRecord
    }

    // MARK: - Update
    func updateUrineRecord(
        _ record: UrineRecord,
        period: PeriodEnum? = nil,
        date: Date? = nil,
        color: String? = nil,
        characteristic: UrineCharacteristicsEnum? = nil,
        observation: String? = nil
    ) {
        guard let context = record.managedObjectContext else { return }

        if let period { record.period = period.rawValue }
        if let date { record.date = date }
        if let color { record.color = color }
        if let characteristic { record.urineCharacteristics = characteristic.rawValue }
        if let observation { record.urineObservation = observation }
    }

    // MARK: - Delete
    func deleteUrineRecord(_ record: UrineRecord, from careRecipient: CareRecipient) {
        guard let basicNeeds = careRecipient.basicNeeds
        else { return }

        let set = basicNeeds.mutableSetValue(forKey: "urine")
        set.remove(record)
    }
    

    // MARK: - Fetch by id
    func urineRecord(with id: UUID, for careRecipient: CareRecipient) -> UrineRecord? {
        guard let urine = careRecipient.basicNeeds?.value(forKey: "urine") as? Set<UrineRecord> else {
            return nil
        }
        return urine.first(where: { $0.id == id })
    }
}
