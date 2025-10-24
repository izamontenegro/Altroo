//
//  HistoryDaySection.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/10/25.
//


import Foundation
import Combine
import CoreData
import CloudKit

// MARK: - Section model for UI
struct HistoryDaySection: Identifiable, Equatable {
    let id = UUID()
    let day: Date
    var items: [HistoryItem]
    var isExpanded: Bool = true
}

final class HistoryViewModel: ObservableObject {

    let userService: UserServiceProtocol
    let coreDataService: CoreDataService
    let historyService: HistoryServiceProtocol

    @Published var sections: [HistoryDaySection] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published var selectedItem: HistoryItem?

    // MARK: - Init
    init(userService: UserServiceProtocol,
         coreDataService: CoreDataService,
         historyService: HistoryServiceProtocol) {
        self.userService = userService
        self.coreDataService = coreDataService
        self.historyService = historyService
    }

    // MARK: - Accessors

    func currentCareRecipient() -> CareRecipient? {
        userService.fetchCurrentPatient()
    }

    func participantsForCurrentRecipient() -> [ParticipantsAccess] {
        guard let recipient = currentCareRecipient() else { return [] }
        return coreDataService.participantsWithCategory(for: recipient)
    }

    func currentShare() -> CKShare? {
        guard let recipient = currentCareRecipient() else { return nil }
        return coreDataService.getShare(recipient)
    }

    // MARK: - Loading

    func reloadHistory(limit: Int? = nil) {
        guard let recipient = currentCareRecipient() else {
            sections = []
            return
        }
        isLoading = true
        errorMessage = nil
        let items = historyService.fetchHistoryItems(for: recipient, limit: limit)
        sections = Self.buildSections(from: items)
        // optional: start older days collapsed
        if sections.indices.count > 1 {
            for idx in sections.indices.dropFirst() { sections[idx].isExpanded = false }
        }
        isLoading = false
    }

    // MARK: - Write: History

    func addHistory(title: String, date: Date = Date()) {
        guard let recipient = currentCareRecipient() else { return }
        // prefer a real performer name (never "You")
        let author = coreDataService.currentPerformerName(for: recipient)
        historyService.addHistoryItem(title: title, author: author, date: date, to: recipient)
        reloadHistory()
    }

    func deleteHistory(_ item: HistoryItem) {
        guard let recipient = currentCareRecipient() else { return }
        historyService.deleteHistoryItem(item, from: recipient)
        reloadHistory()
    }

    // MARK: - Helpers

    static func buildSections(from items: [HistoryItem]) -> [HistoryDaySection] {
        let cal = Calendar.current
        let grouped = Dictionary(grouping: items) { item -> Date in
            let base = item.date ?? Date.distantPast
            let comps = cal.dateComponents([.year, .month, .day], from: base)
            return cal.date(from: comps) ?? base
        }

        return grouped
            .map { (day, bucket) in
                HistoryDaySection(
                    day: day,
                    items: bucket.sorted(by: { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }),
                    isExpanded: true
                )
            }
            .sorted(by: { $0.day > $1.day })
    }

    private func makeUrineHistoryTitle(period: PeriodEnum,
                                       color: String,
                                       characteristics: [UrineCharacteristicsEnum],
                                       observation: String?) -> String {
        var parts: [String] = []
        parts.append("Urine recorded")
        parts.append("Period: \(period.rawValue)")
        parts.append("Color: \(color)")
        if !characteristics.isEmpty {
            let tags = characteristics.map(\.rawValue).joined(separator: ", ")
            parts.append("Characteristics: \(tags)")
        }
        if let text = observation, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            parts.append("Note: \(text)")
        }
        return parts.joined(separator: " • ")
    }
}
