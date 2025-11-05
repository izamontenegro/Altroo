//
//  Reportable.swift
//  Altroo
//
//  Created by Raissa Parente on 05/11/25.
//
import Foundation

protocol Reportable {
    var reportTitle: String { get }
    var reportTime: Date? { get }
    var reportAuthor: String? { get }
    var reportNotes: String? { get }
}

extension StoolRecord: Reportable {
    var reportTitle: String { "Fezes" }
    var reportTime: Date? { self.date }
    var reportAuthor: String? { self.author }
    var reportNotes: String? { self.notes }
}

extension UrineRecord: Reportable {
    var reportTitle: String { "Urina" }
    var reportTime: Date? { self.date }
    var reportAuthor: String? { self.author }
    var reportNotes: String? { self.urineObservation }
}

extension FeedingRecord: Reportable {
    var reportTitle: String { self.mealCategory ?? "Alimentação" }
    var reportTime: Date? { self.date }
    var reportAuthor: String? { self.author }
    var reportNotes: String? { self.notes }
}

extension HydrationRecord: Reportable {
    var reportTitle: String { "\(self.waterQuantity)" }
    var reportTime: Date? { self.date }
    var reportAuthor: String? { self.author }
    var reportNotes: String? { nil }
}

extension TaskInstance: Reportable {
    var reportTitle: String { self.template?.name ?? "Tarefa" }
    var reportTime: Date? { self.time }
    var reportAuthor: String? { self.author }
    var reportNotes: String? { self.template?.note }
}


