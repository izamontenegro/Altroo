//
//  VolumeInputView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 19/11/25.
//
import UIKit

final class HydrationMeasureInputView: UIView {
    
    var value: Int {
        didSet {
            value = max(minValue, min(maxValue, value))
            updateValueLabel()
            onValueChanged?(value, unit)
        }
    }
    
    var unit: HydrationVolumeUnit {
        didSet {
            unitLabel.text = unit.displayText
            onValueChanged?(value, unit)
        }
    }
    
    var minValue: Int
    var maxValue: Int
    var step: Int
    
    var onValueChanged: ((Int, HydrationVolumeUnit) -> Void)?
    
    private let valueContainer = UIView()
    private let valueLabel = UILabel()
    
    private let stepperContainer = UIView()
    private let unitLabel = UILabel()
    private let upButton = UIButton(type: .system)
    private let downButton = UIButton(type: .system)
    
    init(
        initialValue: Int = 0,
        unit: HydrationVolumeUnit = .milliliter,
        minValue: Int = 0,
        maxValue: Int = 5000,
        step: Int = 50
    ) {
        self.value = initialValue
        self.unit = unit
        self.minValue = minValue
        self.maxValue = maxValue
        self.step = step
        super.init(frame: .zero)
        setupView()
        updateValueLabel()
    }
    
    @MainActor required init?(coder: NSCoder) {
        self.value = 0
        self.minValue = 0
        self.unit = .milliliter
        self.maxValue = 5000
        self.step = 50
        super.init(coder: coder)
        setupView()
        updateValueLabel()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = UIStackView()
        mainStack.axis = .horizontal
        mainStack.spacing = 8
        mainStack.alignment = .center
        mainStack.distribution = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        setupValueContainer()
        setupStepperContainer()
        
        mainStack.addArrangedSubview(valueContainer)
        mainStack.addArrangedSubview(stepperContainer)
        
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            valueContainer.heightAnchor.constraint(equalToConstant: 48),
            stepperContainer.heightAnchor.constraint(equalToConstant: 48),
            
            valueContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            stepperContainer.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        valueContainer.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stepperContainer.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private func setupValueContainer() {
        valueContainer.translatesAutoresizingMaskIntoConstraints = false
        valueContainer.backgroundColor = UIColor.systemGray6
        valueContainer.layer.cornerRadius = 24
        valueContainer.clipsToBounds = true
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        valueLabel.textColor = UIColor.label
        valueLabel.textAlignment = .center
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.6
        
        valueContainer.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: valueContainer.topAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: valueContainer.bottomAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: valueContainer.leadingAnchor, constant: 24),
            valueLabel.trailingAnchor.constraint(equalTo: valueContainer.trailingAnchor, constant: -24)
        ])
    }
    
    private func setupStepperContainer() {
        stepperContainer.translatesAutoresizingMaskIntoConstraints = false
        stepperContainer.backgroundColor = UIColor.systemBlue
        stepperContainer.layer.cornerRadius = 24
        stepperContainer.clipsToBounds = true
        
        let innerStack = UIStackView()
        innerStack.axis = .horizontal
        innerStack.alignment = .center
        innerStack.spacing = 8
        innerStack.translatesAutoresizingMaskIntoConstraints = false
        
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        unitLabel.textColor = .white
        unitLabel.text = unit.displayText
        
        let arrowsStack = UIStackView()
        arrowsStack.axis = .vertical
        arrowsStack.alignment = .center
        arrowsStack.distribution = .fillEqually
        arrowsStack.translatesAutoresizingMaskIntoConstraints = false
        
        upButton.translatesAutoresizingMaskIntoConstraints = false
        downButton.translatesAutoresizingMaskIntoConstraints = false
        
        upButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        downButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        
        upButton.tintColor = .white
        downButton.tintColor = .white
        
        upButton.addTarget(self, action: #selector(increment), for: .touchUpInside)
        downButton.addTarget(self, action: #selector(decrement), for: .touchUpInside)
        
        arrowsStack.addArrangedSubview(upButton)
        arrowsStack.addArrangedSubview(downButton)
        
        innerStack.addArrangedSubview(unitLabel)
        innerStack.addArrangedSubview(arrowsStack)
        
        stepperContainer.addSubview(innerStack)
        
        NSLayoutConstraint.activate([
            innerStack.topAnchor.constraint(equalTo: stepperContainer.topAnchor, constant: 8),
            innerStack.bottomAnchor.constraint(equalTo: stepperContainer.bottomAnchor, constant: -8),
            innerStack.leadingAnchor.constraint(equalTo: stepperContainer.leadingAnchor, constant: 16),
            innerStack.trailingAnchor.constraint(equalTo: stepperContainer.trailingAnchor, constant: -16),
            
            upButton.widthAnchor.constraint(equalToConstant: 18),
            upButton.heightAnchor.constraint(equalToConstant: 14),
            downButton.widthAnchor.constraint(equalToConstant: 18),
            downButton.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    @objc private func increment() {
        value += step
    }
    
    @objc private func decrement() {
        value -= step
    }
    
    private func updateValueLabel() {
        valueLabel.text = "\(value)"
    }
}
