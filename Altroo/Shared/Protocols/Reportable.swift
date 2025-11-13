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
    var reportTitle: String { self.formatType?.displayText ?? "Tipo não registrado" }
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

enum ReportItem: Identifiable, Equatable {
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
        case .urine(let record): return record
        case .stool(let record): return record
        case .feeding(let record): return record
        case .task(let record): return record
        case .hydration(let record): return record
        case .symptom(let record): return record
        }
    }
    
    var type: ReportItemType {
        switch self {
        case .stool(let stoolRecord): .stool
        case .urine(let urineRecord): .urine
        case .feeding(let feedingRecord): .feeding
        case .hydration(let hydrationRecord): .hydration
        case .task(let taskInstance): .task
        case .symptom(let symptom): .symptom
        }
    }
}

enum ReportItemType: CaseIterable {
    case stool
    case urine
    case feeding
    case hydration
    case task
    case symptom
    
    var displayText: String {
        switch self {
        case .stool: "Fezes"
        case .urine: "Urina"
        case .feeding: "Alimentação"
        case .hydration: "Hidratação"
        case .task: "Tarefas"
        case .symptom: "Intercorrências"
        }
    }
}
