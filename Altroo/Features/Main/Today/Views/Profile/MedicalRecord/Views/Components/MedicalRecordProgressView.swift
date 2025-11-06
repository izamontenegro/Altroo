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

    private let trackView: UIView = {
        let view = UIView()
        view.backgroundColor = .pureWhite
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let fillView: UIView = {
        let view = UIView()
        view.backgroundColor = .pureWhite
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

    private var fillWidthConstraint: NSLayoutConstraint?
    private let gradientLayer = CAGradientLayer()
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

        let progressRow = UIStackView(arrangedSubviews: [trackView, percentLabel])
        progressRow.axis = .horizontal
        progressRow.alignment = .center
        progressRow.spacing = 10
        progressRow.translatesAutoresizingMaskIntoConstraints = false

        let containerStack = UIStackView(arrangedSubviews: [headerRow, progressRow])
        containerStack.axis = .vertical
        containerStack.spacing = 8
        containerStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(containerStack)
        trackView.addSubview(fillView)

        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor),

            trackView.heightAnchor.constraint(equalToConstant: 15),
            trackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 110),

            fillView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor),
            fillView.centerYAnchor.constraint(equalTo: trackView.centerYAnchor),
            fillView.heightAnchor.constraint(equalTo: trackView.heightAnchor)
        ])

        let width = fillView.widthAnchor.constraint(equalTo: trackView.widthAnchor, multiplier: 0)
        width.isActive = true
        fillWidthConstraint = width
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if gradientLayer.superlayer == nil {
            gradientLayer.colors = [UIColor.blue50.cgColor, UIColor.blue10.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint   = CGPoint(x: 1.0, y: 0.5)
            fillView.layer.insertSublayer(gradientLayer, at: 0)
        }
        gradientLayer.frame = fillView.bounds
        gradientLayer.cornerRadius = fillView.layer.cornerRadius
    }
    
    func setProgress(percent: CGFloat, animated: Bool) {
        let clamped = max(0, min(1, percent))
        self.percent = clamped
        percentLabel.text = "\(Int(round(clamped * 100)))%"

        fillWidthConstraint?.isActive = false
        let newWidth = fillView.widthAnchor.constraint(equalTo: trackView.widthAnchor, multiplier: clamped)
        newWidth.isActive = true
        fillWidthConstraint = newWidth

        if animated {
            UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
                self.layoutIfNeeded()
                self.gradientLayer.frame = self.fillView.bounds
                self.gradientLayer.cornerRadius = self.fillView.layer.cornerRadius
            }.startAnimation()
        } else {
            self.layoutIfNeeded()
            self.gradientLayer.frame = self.fillView.bounds
            self.gradientLayer.cornerRadius = self.fillView.layer.cornerRadius
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
        // REMOVIDO DA PORCENTAGEM DE CONCLUSÃO:
        // O que faz: exclui o campo "cirurgia" do cálculo de conclusão.
        // Como faz: não chama nenhuma função de "check" para cirurgia.
        // Por quê: por regra de produto você solicitou que cirurgias não influenciem a porcentagem.
        // checkArray(healthProblems?.surgery)

        let mentalState = careRecipient.mentalState
        check(mentalState?.cognitionState)
        check(mentalState?.emotionalState)
        check(mentalState?.memoryState)
        check(mentalState?.orientationState)

        let physicalState = careRecipient.physicalState
        check(physicalState?.mobilityState)
        check(physicalState?.hearingState)
        check(physicalState?.visionState)
        check(physicalState?.oralHealthState)

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
