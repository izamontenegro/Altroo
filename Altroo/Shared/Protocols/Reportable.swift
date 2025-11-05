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

extension Symptom: Reportable {
    var reportTitle: String { self.name ?? "Intercorrência"}
    var reportTime: Date? { self.date }
    var reportAuthor: String? { self.author }
    var reportNotes: String? { self.symptomDescription }
}

enum ReportItem: Identifiable {
    case stool(StoolRecord)
    case urine(UrineRecord)
    case feeding(FeedingRecord)
    case hydration(HydrationRecord)
    case task(TaskInstance)
    case symptom(Symptom)
    
    var id: String {
        switch self {
        case .stool(let stoolRecord):
            return stoolRecord.objectID.uriRepresentation().absoluteString
        case .urine(let urineRecord):
            return urineRecord.objectID.uriRepresentation().absoluteString
        case .feeding(let feedingRecord):
            return feedingRecord.objectID.uriRepresentation().absoluteString
        case .hydration(let hydrationRecord):
            return hydrationRecord.objectID.uriRepresentation().absoluteString
        case .task(let taskInstance):
            return taskInstance.objectID.uriRepresentation().absoluteString
        case .symptom(let symptom):
            return symptom.objectID.uriRepresentation().absoluteString
        }
    }
    
    var base: Reportable {
        switch self {
        case .urine(let r): return r
        case .stool(let r): return r
        case .feeding(let r): return r
        case .task(let r): return r
        case .hydration(let r): return r
        case .symptom(let r): return r
        }
    }
}
