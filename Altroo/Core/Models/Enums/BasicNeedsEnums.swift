//
//  BasicNeedsEnums.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 16/10/25.
//

import UIKit

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
enum UrineColorsEnum: String, CaseIterable {
    case light
    case lightYellow
    case yellow
    case orange
    case red
    
    var displayText: String {
        switch self {
        case .light:
            "Translúcido"
        case .lightYellow:
            "Amarelo claro"
        case .yellow:
            "Amarelo"
        case .orange:
            "Alaranjado"
        case .red:
            "Avermelhado"
        }
    }
    
    var color: UIColor {
        switch self {
        case .light:
                .urineLight
        case .lightYellow:
                .urineLightYellow
        case .yellow:
                .urineYellow
        case .orange:
                .urineOrange
        case .red:
                .urineRed
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
enum StoolColorsEnum: String, CaseIterable {
    case brown
    case yellow
    case black
    case red
    case green
    
    var displayText: String {
        switch self {
        case .brown:
            "Marrom médio"
        case .yellow:
            "Amarelado"
        case .black:
            "Marrom escuro"
        case .red:
            "Avermelhado"
        case .green:
            "Esverdeado"
        }
    }
    
    var color: UIColor {
        switch self {
        case .brown:
                .stoolBrown
        case .yellow:
                .stoolYellow
        case .black:
                .stoolBlack
        case .red:
                .stoolRed
        case .green:
                .stoolGreen
        }
    }
}

// MARK: - MEAL
enum MealAmountEatenEnum: String, CaseIterable {
    case all
    case half
    case none
    case dontKnow
    
    var displayText: String {
        switch self {
        case .all:
            return "Tudo"
        case .half:
            return "Parcialmente"
        case .none:
            return "Nada"
        case .dontKnow:
            return "Não sei"
        }
    }
    
    var displaySymbol: String {
        switch self {
        case .all:
            return "circle.fill"
        case .half:
            return "circle.righthalf.filled.inverse"
        case .none:
            return "circle.dashed"
        case .dontKnow:
            return "circle.dashed"
        }
    }
}
enum MealCategoryEnum: String, CaseIterable {
    case breakfast
    case lunch
    case snack
    case dinner
    case supper
    
    var displayText: String {
        switch self {
        case .breakfast:
            return "Café da Manhã"
        case .lunch:
            return "Almoço"
        case .snack:
            return "Lanche"
        case .dinner:
            return "Janta"
        case .supper:
            return "Ceia"
        }
    }
}

// MARK: - HYDRATION
enum HydrationAmountEnum: String, CaseIterable {
    case oneCup
    case twoCups
    case oneBottle
    case custom
    
    var displayText: String {
        switch self {
        case .oneCup:
            return "1 Copo (250ml)"
        case .twoCups:
            return "2 Copos (500ml)"
        case .oneBottle:
            return "1 Garrafa (1000ml)"
        case .custom:
            return "Personalizado"
        }
    }
    
    var milliliters: Double {
        switch self {
        case .oneCup:
            return 250
        case .twoCups:
            return 500
        case .oneBottle:
            return 1000
        case .custom:
            return 0
        }
    }
}
