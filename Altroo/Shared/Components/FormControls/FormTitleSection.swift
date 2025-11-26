//
//  FormTitleSection.swift
//  Altroo
//
//  Created by Raissa Parente on 22/10/25.
//
import UIKit

final class FormTitleSection: UIStackView {
    var currentStep: Int?
    var totalSteps: Int?
    
    private let titleLabel: StandardLabel
    private let descriptionLabel: StandardLabel
    private let stepRow: UIStackView
    
    init(title: String, description: String, totalSteps: Int, currentStep: Int) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        
        self.titleLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .blue30,
            labelWeight: .semibold
        )
        
        self.descriptionLabel = StandardLabel(
            labelText: description,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black30,
            labelWeight: .regular
        )
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        self.stepRow = UIStackView()
        
        super.init(frame: .zero)
        alignment = .leading
        axis = .vertical
        spacing = Layout.verySmallSpacing
        translatesAutoresizingMaskIntoConstraints = false
        
        configureStepRow()
        
        addArrangedSubview(stepRow)

        addArrangedSubview(titleLabel)
        setCustomSpacing(0, after: titleLabel)
        addArrangedSubview(descriptionLabel)
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateContent(title: String, description: String, currentStep: Int) {
        titleLabel.text = title
        descriptionLabel.text = description
        self.currentStep = currentStep
        configureStepRow()
    }
    
    private func configureStepRow() {
        stepRow.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        stepRow.axis = .horizontal
        stepRow.distribution = .fill
        stepRow.alignment = .center
        stepRow.spacing = 6
        
        guard let totalSteps, let currentStep else { return  }
        
        for step in 1...totalSteps {
            let circle = makeCircle(for: step, isActive: step == currentStep)
            stepRow.addArrangedSubview(circle)
        }
        
    }
    
    private func makeCircle(for step: Int, isActive: Bool) -> UIView {
        let circle = CircleView()
        circle.widthAnchor.constraint(equalToConstant: 26).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 26).isActive = true
        circle.translatesAutoresizingMaskIntoConstraints = true
        
        guard let currentStep else { return circle }
        let fillColor: UIColor
        if step == currentStep {
            fillColor = .blue20
        } else if step < currentStep {
            fillColor = .blue50
        } else {
            fillColor = .black40
        }
        circle.fillColor = fillColor

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
