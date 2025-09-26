//
//  PersonalCare+Extensions.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/09/25.
//

import CoreData

extension PersonalCare {

    var bath: BathEnum? {
        get {
            guard let rawValue = self.bathState else { return nil }
            return BathEnum(rawValue: rawValue)
        }
        set {
            self.bathState = newValue?.rawValue
        }
    }

    var hygiene: HygieneEnum? {
        get {
            guard let rawValue = self.hygieneState else { return nil }
            return HygieneEnum(rawValue: rawValue)
        }
        set {
            self.hygieneState = newValue?.rawValue
        }
    }

    var excretion: ExcretionEnum? {
        get {
            guard let rawValue = self.excretionState else { return nil }
            return ExcretionEnum(rawValue: rawValue)
        }
        set {
            self.excretionState = newValue?.rawValue
        }
    }

    var feeding: FeedingEnum? {
        get {
            guard let rawValue = self.feedingState else { return nil }
            return FeedingEnum(rawValue: rawValue)
        }
        set {
            self.feedingState = newValue?.rawValue
        }
    }

    var equipment: EquipmentEnum? {
        get {
            guard let rawValue = self.equipmentState else { return nil }
            return EquipmentEnum(rawValue: rawValue)
        }
        set {
            self.equipmentState = newValue?.rawValue
        }
    }
}
