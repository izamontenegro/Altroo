//
//  TodayButtonActions.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 09/11/25.
//

import Foundation

extension TodayViewController {
    // MARK: - BUTTON ACTIONS
    @objc private func didTapRecordHeartRate() {
        delegate?.goTo(.recordHeartRate)
    }
    @objc private func didTapRecordGlycemia() {
        delegate?.goTo(.recordGlycemia)
    }
    @objc private func didTapRecordBloodPressure() {
        delegate?.goTo(.recordBloodPressure)
    }
    @objc private func didTapRecordTemperature() {
        delegate?.goTo(.recordTemperature)
    }
    @objc private func didTapRecordSaturation() {
        delegate?.goTo(.recordSaturation)
    }
    @objc private func didTapSeeAllMedication() {
        delegate?.goTo(.seeAllMedication)
    }
    @objc private func didTapAddNewMedication() {
        delegate?.goTo(.addNewMedication)
    }
    @objc private func didTapCheckMedicationDone() {
        delegate?.goTo(.checkMedicationDone)
    }
    @objc private func didTapSeeAllEvents() {
        delegate?.goTo(.seeAllEvents)
    }
    @objc private func didTapAddNewEvent() {
        delegate?.goTo(.addNewEvent)
    }
}
