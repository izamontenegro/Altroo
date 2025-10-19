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
    
    var displayText: String {
        switch self {
        case .lumpy:
            return "Caroços"
        case .clumpy:
            return "Grumos"
        case .sausageCracks:
            return "Salsicha com Fissuras"
        case .smoothSausage:
            return "Salsicha Lisa"
        case .softPieces:
            return "Pedaços"
        case .mushy:
            return "Pastosa"
        case .watery:
            return "Líquida"
        }
    }
    
    var displayImage: String {
        switch self {
        case .lumpy:
            return "lumpy_stool_illustration"
        case .clumpy:
            return "clumpy_stool_illustration"
        case .sausageCracks:
            return "sausageCracks_stool_illustration"
        case .smoothSausage:
            return "smoothSausage_stool_illustration"
        case .softPieces:
            return "softPieces_stool_illustration"
        case .mushy:
            return "mushy_stool_illustration"
        case .watery:
            return "water_stool_illustration"
        }
    }
}
