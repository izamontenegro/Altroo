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
        characteristics: [UrineCharacteristicsEnum],
        observation: String?,
        to careRecipient: CareRecipient
    ) -> UrineRecord?

    func updateUrineRecord(
        _ record: UrineRecord,
        period: PeriodEnum?,
        date: Date?,
        color: String?,
        characteristics: [UrineCharacteristicsEnum]?,
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
        characteristics: [UrineCharacteristicsEnum],
        observation: String?,
        to careRecipient: CareRecipient
    ) -> UrineRecord? {
        guard let context = careRecipient.managedObjectContext else { return nil }

        let record = UrineRecord(context: context)
        record.id = UUID()
        record.color = color
        record.date = date
        record.period = period.rawValue
        record.urineCharacteristics = encode(characteristics)
        record.urineObservation = observation

        if let basicNeeds = careRecipient.basicNeeds {
            let set = basicNeeds.mutableSetValue(forKey: "urine")
            set.add(record)
        }
        return record
    }

    // MARK: - Update
    func updateUrineRecord(
        _ record: UrineRecord,
        period: PeriodEnum? = nil,
        date: Date? = nil,
        color: String? = nil,
        characteristics: [UrineCharacteristicsEnum]? = nil,
        observation: String? = nil
    ) {
        if let period { record.period = period.rawValue }
        if let date { record.date = date }
        if let color { record.color = color }
        if let characteristics { record.urineCharacteristics = encode(characteristics) }
        if let observation { record.urineObservation = observation }
    }

    // MARK: - Delete (remove só do relacionamento, igual seu padrão)
    func deleteUrineRecord(_ record: UrineRecord, from careRecipient: CareRecipient) {
        guard let basicNeeds = careRecipient.basicNeeds else { return }
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

// MARK: - Encoding helpers
private extension UrineService {
    func encode(_ list: [UrineCharacteristicsEnum]) -> String {
        list.map(\.rawValue).joined(separator: ",")
    }

    func decode(_ string: String?) -> [UrineCharacteristicsEnum] {
        guard let string, !string.isEmpty else { return [] }
        return string
            .split(separator: ",")
            .compactMap { UrineCharacteristicsEnum(rawValue: String($0)) }
    }
}
