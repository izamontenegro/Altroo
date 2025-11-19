//
//  HydrationMeasureInputView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 19/11/25.
//
import UIKit

final class HydrationMeasureInputView: UIView, UITextFieldDelegate {
    
    var value: Int {
        didSet {
            if value <= 0 {
                valueTextField.text = nil
            } else {
                valueTextField.text = "\(value)"
            }
        }
    }
    
    var unit: HydrationUnit {
        didSet {
            updateUnitButtonTitle()
            unitButton.menu = makeUnitMenu()
        }
    }
    
    var minValue: Int
    var maxValue: Int
    
    var onValueChanged: ((Int, HydrationUnit) -> Void)?
        
    private let valueContainer = UIView()
    private let valueTextField = UITextField()
    private let unitButton = UIButton(type: .system)

    
    init(
        initialValue: Int = 0,
        unit: HydrationUnit = .milliliter,
        minValue: Int = 0,
        maxValue: Int = 5000
    ) {
        self.value = initialValue
        self.unit = unit
        self.minValue = minValue
        self.maxValue = maxValue
        super.init(frame: .zero)
        setupView()
        value = initialValue
    }
    
    @MainActor required init?(coder: NSCoder) {
        self.value = 0
        self.unit = .milliliter
        self.minValue = 0
        self.maxValue = 5000
        super.init(coder: coder)
        setupView()
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
        setupUnitButton()
        
        mainStack.addArrangedSubview(valueContainer)
        mainStack.addArrangedSubview(unitButton)
        
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            valueContainer.heightAnchor.constraint(equalToConstant: 48),
            unitButton.heightAnchor.constraint(equalToConstant: 48),
            
            valueContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 96),
            unitButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 72)
        ])
        
        valueContainer.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        unitButton.setContentHuggingPriority(.required, for: .horizontal)
    }
        
    private func setupValueContainer() {
        valueContainer.translatesAutoresizingMaskIntoConstraints = false
        valueContainer.backgroundColor = UIColor.white70
        valueContainer.layer.cornerRadius = 8
        valueContainer.clipsToBounds = true
        
        valueTextField.translatesAutoresizingMaskIntoConstraints = false
        valueTextField.keyboardType = .numberPad
        valueTextField.borderStyle = .none
        valueTextField.textAlignment = .center
        valueTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        valueTextField.textColor = UIColor.black10
        valueTextField.placeholder = "0"
        valueTextField.addTarget(self, action: #selector(valueEditingChanged), for: .editingChanged)
        valueTextField.delegate = self
        
        valueContainer.addSubview(valueTextField)
        
        NSLayoutConstraint.activate([
            valueTextField.topAnchor.constraint(equalTo: valueContainer.topAnchor),
            valueTextField.bottomAnchor.constraint(equalTo: valueContainer.bottomAnchor),
            valueTextField.leadingAnchor.constraint(equalTo: valueContainer.leadingAnchor, constant: 16),
            valueTextField.trailingAnchor.constraint(equalTo: valueContainer.trailingAnchor, constant: -16)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(focusValueField))
        valueContainer.addGestureRecognizer(tap)
    }
    
    
    private func setupUnitButton() {
        unitButton.translatesAutoresizingMaskIntoConstraints = false
        unitButton.backgroundColor = UIColor.blue40
        unitButton.layer.cornerRadius = 8
        unitButton.clipsToBounds = true
        
        unitButton.setTitleColor(.white, for: .normal)
        unitButton.tintColor = .pureWhite
        unitButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        unitButton.semanticContentAttribute = .forceRightToLeft
        
        unitButton.showsMenuAsPrimaryAction = true
        unitButton.menu = makeUnitMenu()
        
        updateUnitButtonTitle()
    }
    
    private func updateUnitButtonTitle() {
        let title = unit.displayText
        let image = UIImage(systemName: "chevron.up.chevron.down")
        
        unitButton.setTitle(title, for: .normal)
        unitButton.setImage(image, for: .normal)
    }
    
    private func makeUnitMenu() -> UIMenu {
        let actions = HydrationUnit.allCases.map { unit in
            UIAction(
                title: unit.displayText,
                state: unit == self.unit ? .on : .off
            ) { [weak self] _ in
                guard let self else { return }
                self.unit = unit
                self.onValueChanged?(self.value, self.unit)
            }
        }
        
        return UIMenu(children: actions)
    }
    
    // MARK: - Actions
    
    @objc private func focusValueField() {
        valueTextField.becomeFirstResponder()
    }
    
    @objc private func valueEditingChanged() {
        let newValue = Int(valueTextField.text ?? "") ?? 0
        let clamped = max(minValue, min(maxValue, newValue))
        
        if clamped != value {
            value = clamped
        }
        
        if newValue > maxValue {
            valueTextField.text = "\(maxValue)"
            value = maxValue
        }
        
        onValueChanged?(value, unit)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.isEmpty { return true }

        let allowed = CharacterSet.decimalDigits
        if string.rangeOfCharacter(from: allowed.inverted) != nil { return false }

        let oldText = textField.text ?? ""
        guard let r = Range(range, in: oldText) else { return false }
        let newText = oldText.replacingCharacters(in: r, with: string)

        if let num = Int(newText), num <= maxValue {
            return true
        }

        return false
    }
}
