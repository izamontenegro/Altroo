//
//  MedicalRecordProgressView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 31/10/25.
//

import UIKit
import Combine

final class MedicalRecordProgressView: UIView {
    private let titleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Conclusão da ficha",
            labelFont: .sfPro,
            labelType: .headline,
            labelColor: .black10,
            labelWeight: .semibold
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let progressBar: MedicalRecordProgressBarView = {
        let bar = MedicalRecordProgressBarView(
            height: 15,
            cornerRadius: 8,
            trackColor: .pureWhite,
            startColor: .blue50,
            endColor: .blue10,
            progress: 0
        )
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    private let percentLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "0%",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .blue20,
            labelWeight: .medium
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) var percent: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setProgress(percent: 0, animated: false)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false

        let headerRow = UIStackView(arrangedSubviews: [titleLabel, UIView()])
        headerRow.axis = .horizontal
        headerRow.alignment = .center
        headerRow.translatesAutoresizingMaskIntoConstraints = false

        let progressRow = UIStackView(arrangedSubviews: [progressBar, percentLabel])
        progressRow.axis = .horizontal
        progressRow.alignment = .center
        progressRow.spacing = 10
        progressRow.translatesAutoresizingMaskIntoConstraints = false

        let containerStack = UIStackView(arrangedSubviews: [headerRow, progressRow])
        containerStack.axis = .vertical
        containerStack.spacing = 8
        containerStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(containerStack)

        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor),

            progressBar.widthAnchor.constraint(greaterThanOrEqualToConstant: 110)
        ])
    }
    
    func setProgress(percent: CGFloat, animated: Bool) {
        let clamped = max(0, min(1, percent))
        self.percent = clamped
        percentLabel.text = "\(Int(round(clamped * 100)))%"
        progressBar.progress = clamped
        if animated {
            UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
                self.layoutIfNeeded()
            }.startAnimation()
        } else {
            layoutIfNeeded()
        }
    }

    func setCareRecipient(_ careRecipient: CareRecipient?, animated: Bool) {
        guard let careRecipient else {
            setProgress(percent: 0, animated: animated)
            return
        }
        var total = 0, filled = 0
        func check(_ value: String?) { total += 1; if let x = value, !x.trimmingCharacters(in: .whitespaces).isEmpty { filled += 1 } }
        func checkDate(_ value: Date?) { total += 1; if value != nil { filled += 1 } }
        func checkDouble(_ value: Double?) { total += 1; if let x = value, !x.isNaN { filled += 1 } }
        func checkArray(_ value: Any?) { total += 1; if let a = value as? [Any], !a.isEmpty { filled += 1 } }
        func checkToManySet<T>(_ v: Set<T>?) { total += 1; if let set = v, !set.isEmpty { filled += 1 } }
        
        let personalData = careRecipient.personalData
        check(personalData?.name)
        check(personalData?.address)
        check(personalData?.gender)
        checkDate(personalData?.dateOfBirth)
        checkDouble(personalData?.height)
        checkDouble(personalData?.weight)

        let healthProblems = careRecipient.healthProblems
        check(healthProblems?.observation)
        checkArray(healthProblems?.allergies)

        let mentalState = careRecipient.mentalState
        checkToManySet(Set(mentalState?.emotionalState ?? []))
        check(mentalState?.memoryState)
        checkToManySet(Set(mentalState?.orientationState ?? []))

        let physicalState = careRecipient.physicalState
        check(physicalState?.mobilityState)
        check(physicalState?.hearingState)
        check(physicalState?.visionState)
        checkToManySet(Set(physicalState?.oralHealthState ?? []))

        let personalCare = careRecipient.personalCare
        check(personalCare?.bathState)
        check(personalCare?.hygieneState)
        check(personalCare?.excretionState)
        check(personalCare?.feedingState)
        check(personalCare?.equipmentState)

        let percentValue: CGFloat = (total > 0) ? CGFloat(Double(filled) / Double(total)) : 0.0
        setProgress(percent: percentValue, animated: animated)
    }

    func setTitle(text: String) {
        titleLabel.text = text
    }
}
