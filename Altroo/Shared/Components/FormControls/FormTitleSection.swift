//
//  FormTitleSection.swift
//  Altroo
//
//  Created by Raissa Parente on 22/10/25.
//
import UIKit

final class FormTitleSection: UIStackView {
    let currentStep: Int?
    let totalSteps: Int?
    
    init(title: String, description: String, totalSteps: Int, currentStep: Int) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        super.init(frame: .zero)
        alignment = .leading
        axis = .vertical
        spacing = Layout.verySmallSpacing
        translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .blue30,
            labelWeight: .semibold
        )
        
        let descriptionLabel = StandardLabel(
            labelText: description,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black30,
            labelWeight: .regular
        )
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        addArrangedSubview(makeStepRow())
        addArrangedSubview(titleLabel)
        setCustomSpacing(0, after: titleLabel)
        addArrangedSubview(descriptionLabel)
    }

    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func makeStepRow() -> UIStackView {
        
        let hstack = UIStackView()
        hstack.axis = .horizontal
        hstack.distribution = .fill
        hstack.alignment = .center
        hstack.spacing = 6
        
        guard let totalSteps, let currentStep else { return hstack }

        for step in 1...totalSteps {
            let circle = makeCircle(for: step, isActive: step == currentStep)
            hstack.addArrangedSubview(circle)
        }
        
        return hstack
    }
    
    private func makeCircle(for step: Int, isActive: Bool) -> UIView {
        let circle = CircleView()
        circle.widthAnchor.constraint(equalToConstant: 26).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 26).isActive = true
        circle.translatesAutoresizingMaskIntoConstraints = true
        circle.fillColor = isActive ? .blue30 : .blue30.withAlphaComponent(0.3)
        let number = StandardLabel(
            labelText: "\(step)",
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .pureWhite,
            labelWeight: .regular
        )
        
        circle.addSubview(number)
        
        NSLayoutConstraint.activate([
            number.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            number.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
        ])
        
        return circle
    }
}
