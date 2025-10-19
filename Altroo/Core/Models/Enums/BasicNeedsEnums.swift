//
//  BasicNeedsEnums.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 16/10/25.
//

// MARK: - URINE

enum UrineCharacteristicsEnum: String, CaseIterable {
    case pain
    case excessFoam
    case incontinence
    case unusualOdor
    
    var displayText: String {
        switch self {
        case .excessFoam:
            return "Excesso de espuma"
        case .pain:
            return "Dor"
        case .incontinence:
            return "Incontinência"
        case .unusualOdor:
            return "Cheiro Anormal"
        }
    }
}

// MARK: - STOOL

enum StoolTypesEnum: String, CaseIterable {
    case lumpy
    case clumpy
    case sausageCracks
    case smoothSausage
    case softPieces
    case mushy
    case watery
}
