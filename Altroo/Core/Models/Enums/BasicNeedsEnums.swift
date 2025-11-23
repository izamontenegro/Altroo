//
//  BasicNeedsEnums.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 16/10/25.
//

import UIKit

// MARK: - URINE

enum UrineColorsEnum: String, CaseIterable {
    case clear
    case lightYellow
    case yellow
    case orange
    case red
    
    var displayText: String {
        switch self {
        case .clear:
            "Claro"
        case .lightYellow:
            "Amarelo claro"
        case .yellow:
            "Amarelo"
        case .orange:
            "Laranja"
        case .red:
            "Vermelho"
        }
    }
    
    var color: UIColor {
        switch self {
        case .clear:
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
            return "StoolIllustration_Lumpy"
        case .clumpy:
            return "StoolIllustration_Clumpy"
        case .sausageCracks:
            return "StoolIllustration_SausageCracks"
        case .smoothSausage:
            return "StoolIllustration_SmoothSausage"
        case .softPieces:
            return "StoolIllustration_SoftPieces"
        case .mushy:
            return "StoolIllustration_Mushy"
        case .watery:
            return "StoolIllustration_Watery"
        }
    }
}
enum StoolColorsEnum: String, CaseIterable {
    case mediumBrown
    case yellow
    case darkBrown
    case red
    case darkGreen
    
    var displayText: String {
        switch self {
        case .mediumBrown:
            "Marrom médio"
        case .yellow:
            "Amarelo"
        case .darkBrown:
            "Marrom escuro"
        case .red:
            "Vermelho"
        case .darkGreen:
            "Verde Escuro"
        }
    }
    
    var color: UIColor {
        switch self {
        case .mediumBrown:
                .mediumBrownStool
        case .yellow:
                .yellowStool
        case .darkBrown:
                .darkBrownStool
        case .red:
                .redStool
        case .darkGreen:
                .darkGreenStool
        }
    }
}

// MARK: - MEAL
enum MealAmountEatenEnum: String, CaseIterable {
    case all
    case half
    case none
    
    var displayText: String {
        switch self {
        case .all:
            return "Tudo"
        case .half:
            return "Parcialmente"
        case .none:
            return "Nada"
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
        }
    }
}
enum MealCategoryEnum: String, CaseIterable {
    case breakfast
    case morningSnack
    case lunch
    case afternoonSnack
    case dinner
    case supper
        
    var displayName: String {
        switch self {
        case .breakfast:
            return "Café da manhã"
        case .morningSnack:
            return "Lanche da manhã"
        case .lunch:
            return "Almoço"
        case .afternoonSnack:
            return "Lanche da tarde"
        case .dinner:
            return "Janta"
        case .supper:
            return "Ceia"
        }
    }
    
    var displayImageName: String {
        switch self {
        case .breakfast:
            return "MealIllustration_Breakfeast"
        case .morningSnack:
            return "MealIllustration_MorningSnack"
        case .lunch:
            return "MealIllustration_Lunch"
        case .afternoonSnack:
            return "MealIllustration_AfternoonSnack"
        case .dinner:
            return "MealIllustration_Dinner"
        case .supper:
            return "MealIllustration_Supper"
        }
    }
}

// MARK: - HYDRATION
enum HydrationAmountEnum: String, CaseIterable {
    case custom
    case oneCup
    case twoCups
    case bottle
   
    var displayText: String {
        switch self {
        case .oneCup:
            return "1 Copo (250ml)"
        case .twoCups:
            return "2 Copos (500ml)"
        case .bottle:
            return "1 Garrafa (1000ml)"
        case .custom:
            return "Personalizado"
        }
    }
    
    var displayImageName: String {
        switch self {
        case .oneCup:
            return "HydrationIllustration_Glass"
        case .twoCups:
            return "HydrationIllustration_TwoCups"
        case .bottle:
            return "HydrationIllustration_Bottle"
        case .custom:
            return "HydrationIllustration_Custom"
        }
    }
    
    var milliliters: Double {
        switch self {
        case .oneCup:
            return 250
        case .twoCups:
            return 500
        case .bottle:
            return 1000
        case .custom:
            return 0
        }
    }
}

enum HydrationUnit: String, CaseIterable {
    case milliliter = "ml"
    case liter      = "L"

    var displayText: String {
        rawValue
    }
}
