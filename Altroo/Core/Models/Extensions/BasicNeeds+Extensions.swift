//
//  BasicNeeds+Ex.swift
//  Altroo
//
//  Created by Raissa Parente on 05/11/25.
//

extension StoolRecord {
    var colorType: StoolColorsEnum? {
        get {
            guard let rawValue = self.color else { return nil }
            return StoolColorsEnum(rawValue: rawValue)
        }
        set {
            self.color = newValue?.rawValue
        }
    }
    
    var formatType: StoolTypesEnum? {
        get {
            guard let rawValue = self.format else { return nil }
            return StoolTypesEnum(rawValue: rawValue)
        }
        set {
            self.format = newValue?.rawValue
        }
    }
}

extension UrineRecord {
    var colorType: UrineColorsEnum? {
        get {
            guard let rawValue = self.color else { return nil }
            return UrineColorsEnum(rawValue: rawValue)
        }
        set {
            self.color = newValue?.rawValue
        }
    }
}
