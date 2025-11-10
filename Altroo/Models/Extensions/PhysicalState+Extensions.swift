//
//  PhysicalState+Extensions.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/09/25.
//

import CoreData

extension PhysicalState {

    var vision: VisionEnum? {
        get {
            guard let rawValue = self.visionState else { return nil }
            return VisionEnum(rawValue: rawValue)
        }
        set {
            self.visionState = newValue?.rawValue
        }
    }

    var hearing: HearingEnum? {
        get {
            guard let rawValue = self.hearingState else { return nil }
            return HearingEnum(rawValue: rawValue)
        }
        set {
            self.hearingState = newValue?.rawValue
        }
    }

    var oralHealth: OralHealthEnum? {
        get {
            guard let rawValue = self.oralHealthState else { return nil }
            return OralHealthEnum(rawValue: rawValue)
        }
        set {
            self.oralHealthState = newValue?.rawValue
        }
    }

    var mobility: MobilityEnum? {
        get {
            guard let rawValue = self.mobilityState else { return nil }
            return MobilityEnum(rawValue: rawValue)
        }
        set {
            self.mobilityState = newValue?.rawValue
        }
    }
}
