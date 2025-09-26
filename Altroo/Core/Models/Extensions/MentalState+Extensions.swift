//
//  MentalState+Extensions.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/09/25.
//

import CoreData

extension MentalState {

    var emotional: EmotionalStateEnum? {
        get {
            guard let rawValue = self.emotionalState else { return nil }
            return EmotionalStateEnum(rawValue: rawValue)
        }
        set {
            self.emotionalState = newValue?.rawValue
        }
    }

    var memory: MemoryEnum? {
        get {
            guard let rawValue = self.memoryState else { return nil }
            return MemoryEnum(rawValue: rawValue)
        }
        set {
            self.memoryState = newValue?.rawValue
        }
    }

    var orientation: OrientationEnum? {
        get {
            guard let rawValue = self.orientationState else { return nil }
            return OrientationEnum(rawValue: rawValue)
        }
        set {
            self.orientationState = newValue?.rawValue
        }
    }

    var cognition: CognitionEnum? {
        get {
            guard let rawValue = self.cognitionState else { return nil }
            return CognitionEnum(rawValue: rawValue)
        }
        set {
            self.cognitionState = newValue?.rawValue
        }
    }
}
