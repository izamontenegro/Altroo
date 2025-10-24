//
//  HistoryService.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/10/25.
//

import Foundation
import CoreData

protocol HistoryServiceProtocol {
    func addHistoryItem(
        title: String,
        author: String?,
        date: Date,
        to careRecipient: CareRecipient
    )

    func deleteHistoryItem(
        _ item: HistoryItem,
        from careRecipient: CareRecipient
    )
}

final class HistoryService: HistoryServiceProtocol {

    func addHistoryItem(
        title: String,
        author: String?,
        date: Date,
        to careRecipient: CareRecipient
    ) {
        guard let context = careRecipient.managedObjectContext else { return }

        let newItem = HistoryItem(context: context)
        newItem.title = title
        newItem.author = author
        newItem.date = date

        newItem.careRecipient = careRecipient
        let historySet = careRecipient.mutableSetValue(forKey: "historyItems")
        historySet.add(newItem)

        do {
            try context.save()
        } catch {
            assertionFailure("Failed to save HistoryItem: \(error)")
        }
    }

    func deleteHistoryItem(
        _ item: HistoryItem,
        from careRecipient: CareRecipient
    ) {
        guard let context = careRecipient.managedObjectContext else { return }

        let historySet = careRecipient.mutableSetValue(forKey: "historyItems")
        historySet.remove(item)
        context.delete(item)

        do {
            try context.save()
        } catch {
            assertionFailure("Failed to delete HistoryItem: \(error)")
        }
    }
}
