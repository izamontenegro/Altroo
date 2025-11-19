//
//  HydrationRecordViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//
import UIKit
import Combine

final class HydrationRecordViewController: GradientNavBarViewController {
    private let viewModel: HydrationRecordViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var amountButtons: [UIButton] = []
    private var customValueView: HydrationMeasureInputView!
    private var hydrationTargetView: HydrationMeasureInputView!
    
    private var confirmationButton: StandardConfirmationButton!
    
    var onDismiss: (() -> Void)?

    init(viewModel: HydrationRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite
        
        viewModel.loadTargetValue()
        setupLayout()
        bindViewModel()
        setupTapToDismiss()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            onDismiss?()
        }
    }

    // MARK: - Layout
    private func setupLayout() {
        let header = StandardHeaderView(
            title: "Registrar Hidratação",
            subtitle: "Registre a quantidade ingerida de líquidos"
        )
        let amountSection = makeAmountSection()
        let customSection = makeCustomValueSection()
        let targetSection = makeHydrationTargetValueSection()
        
        confirmationButton = configureConfirmationButton()
        
        let contentStack = UIStackView(arrangedSubviews: [header, amountSection, customSection, targetSection])
        contentStack.axis = .vertical
        contentStack.spacing = 24
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentStack)
        view.addSubview(confirmationButton)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            confirmationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            confirmationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        updateConfirmationButtonState(enabled: false)
    }

    private func makeAmountSection() -> UIView {
        let title = StandardLabel(
            labelText: "Quantidade",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .semibold
        )

        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12

        var currentRow = UIStackView()
        currentRow.axis = .horizontal
        currentRow.spacing = 12
        currentRow.distribution = .fillEqually

        var buttonsInCurrentRow = 0

        for (index, option) in HydrationAmountEnum.allCases.enumerated() {
            let button = PrimaryStyleButton(title: option.displayText)
            button.backgroundColor = .black40
            button.setTitleColor(.white, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(amountTapped(_:)), for: .touchUpInside)

            amountButtons.append(button)

            currentRow.addArrangedSubview(button)
            buttonsInCurrentRow += 1

            if buttonsInCurrentRow == 2 {
                container.addArrangedSubview(currentRow)
                currentRow = UIStackView()
                currentRow.axis = .horizontal
                currentRow.spacing = 12
                currentRow.distribution = .fillEqually
                buttonsInCurrentRow = 0
            }
        }

        if buttonsInCurrentRow > 0 {
            container.addArrangedSubview(currentRow)
        }

        let section = UIStackView(arrangedSubviews: [title, container])
        section.axis = .vertical
        section.spacing = 16
        return section
    }

    private func makeCustomValueSection() -> UIView {
        let title = StandardLabel(
            labelText: "Valor Personalizado",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .semibold
        )

        let input = HydrationMeasureInputView(
            initialValue: Int(viewModel.customValue),
            unit: .milliliter,
            minValue: 0,
            maxValue: 5000
        )

        input.onValueChanged = { [weak self] value, _ in
            self?.viewModel.customValue = Double(value)
        }

        input.setContentHuggingPriority(.required, for: .horizontal)
        input.setContentCompressionResistancePriority(.required, for: .horizontal)

        self.customValueView = input

        let isCustom = viewModel.selectedAmount == .custom
        input.isUserInteractionEnabled = isCustom
        input.alpha = isCustom ? 1.0 : 0.4

        let stack = UIStackView(arrangedSubviews: [title, input])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        
        return stack
    }
    
    private func makeHydrationTargetValueSection() -> UIView {
        let title = StandardLabel(
            labelText: "Meta",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .semibold
        )

        let input = HydrationMeasureInputView(
            initialValue: Int(viewModel.targetValue),
            unit: .milliliter,
            minValue: 0,
            maxValue: 10000
        )

        input.onValueChanged = { [weak self] value, _ in
            self?.viewModel.targetValue = Double(value)
        }

        input.setContentHuggingPriority(.required, for: .horizontal)
        input.setContentCompressionResistancePriority(.required, for: .horizontal)

        self.hydrationTargetView = input

        let stack = UIStackView(arrangedSubviews: [title, input])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        
        return stack
    }

    private func configureConfirmationButton() -> StandardConfirmationButton {
        let button = StandardConfirmationButton(title: "Salvar")
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    // MARK: - Actions
    
    @objc private func amountTapped(_ sender: PrimaryStyleButton) {
        let tappedOption = HydrationAmountEnum.allCases[sender.tag]

        if viewModel.selectedAmount == tappedOption {
            viewModel.selectedAmount = nil
        } else {
            viewModel.selectedAmount = tappedOption
        }

        amountButtons.enumerated().forEach { index, button in
            let isSelected = viewModel.selectedAmount == HydrationAmountEnum.allCases[index]
            button.backgroundColor = isSelected ? .teal20 : .black40
        }

        let isCustom = viewModel.selectedAmount == .custom
        customValueView.isUserInteractionEnabled = isCustom
        customValueView.alpha = isCustom ? 1.0 : 0.4
    }
    
    @objc private func save() {
        viewModel.saveHydrationTarget()
        viewModel.saveHydrationMeasure()
        dismiss(animated: true)
    }

    private func updateConfirmationButtonState(enabled: Bool) {
        confirmationButton.isUserInteractionEnabled = enabled
        UIView.animate(withDuration: 0.2) {
            self.confirmationButton.backgroundColor = enabled ? .teal20 : .black40
        }
    }
    
    private func setupTapToDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Combine Binding
    private func bindViewModel() {
        Publishers.CombineLatest3(
            viewModel.$selectedAmount,
            viewModel.$customValue,
            viewModel.$targetValue
        )
        .sink { [weak self] amount, custom, target in
            guard let self else { return }
            
            let isCustom = amount == .custom
            self.customValueView?.isUserInteractionEnabled = isCustom
            self.customValueView?.alpha = isCustom ? 1.0 : 0.4
            
            // se quiser manter os componentes em sync com o VM:
            let customInt = Int(custom)
            if customInt != self.customValueView.value {
                self.customValueView.value = customInt
            }
            let targetInt = Int(target)
            if targetInt != self.hydrationTargetView.value {
                self.hydrationTargetView.value = targetInt
            }
            
            let measureValid = (amount != nil && (amount != .custom || custom > 0))
            let targetValid = target > 0
            self.updateConfirmationButtonState(enabled: measureValid || targetValid)
        }
        .store(in: &cancellables)
    }
}
