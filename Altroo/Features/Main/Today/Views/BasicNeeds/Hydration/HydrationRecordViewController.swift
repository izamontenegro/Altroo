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
    private var customValueField: UITextField!
    private var confirmationButton: StandardConfirmationButton!

    init(viewModel: HydrationRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite
        setupLayout()
        bindViewModel()
        setupTapToDismiss()
    }

    // MARK: - Layout
    private func setupLayout() {

        let amountSection = makeAmountSection()
        let customSection = makeCustomValueSection()
        
        confirmationButton = configureConfirmationButton()
        
        let contentStack = UIStackView(arrangedSubviews: [amountSection, customSection])
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
                currentRow.distribution = .fillProportionally 
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

        let textField = StandardTextfield()
        textField.placeholder = "ml"
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(customValueChanged(_:)), for: .editingChanged)
        self.customValueField = textField

        let stack = UIStackView(arrangedSubviews: [title, textField])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }

    private func configureConfirmationButton() -> StandardConfirmationButton {
        let button = StandardConfirmationButton(title: "Salvar")
        button.addTarget(self, action: #selector(saveHydrationRecord), for: .touchUpInside)
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
        customValueField.isUserInteractionEnabled = isCustom
        customValueField.alpha = isCustom ? 1.0 : 0.4
    }

    @objc private func customValueChanged(_ sender: UITextField) {
        viewModel.customValue = Double(sender.text ?? "") ?? 0
    }

    @objc private func saveHydrationRecord() {
        viewModel.saveHydrationRecord()
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
        Publishers.CombineLatest(viewModel.$selectedAmount, viewModel.$customValue)
            .sink { [weak self] amount, value in
                let valid = (amount != nil && (amount != .custom || value > 0))
                self?.updateConfirmationButtonState(enabled: valid)
            }
            .store(in: &cancellables)
    }
}
