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
    private var confirmationButton: StandardConfirmationButton!
    
    private var hydrationAmountSectionView: BasicNeedsCardsScrollSectionView?
    
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

        let header = StandardHeaderView(title: "Registrar Hidratação", subtitle: "Registre a quantidade ingerida de líquidos")
        let amountSection = makeAmountSection()
        let customSection = makeCustomValueSection()
        
        confirmationButton = configureConfirmationButton()
        
        let contentStack = UIStackView(arrangedSubviews: [header, amountSection, customSection])
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
        let categories = HydrationAmountEnum.allCases
        
        let imageNames = categories.map { $0.displayImageName }
        let subtitles = categories.map { _ in "Medida" }
        let titles = categories.map { $0.displayText }
        
        let selectedIndex: Int?
        if let selected = viewModel.selectedAmount,
           let idx = categories.firstIndex(of: selected) {
            selectedIndex = idx
        } else {
            selectedIndex = nil
        }
        
        let section = BasicNeedsCardsScrollSectionView(
            title: "Quantidade?",
            imageNames: imageNames,
            subtitles: subtitles,
            titles: titles,
            selectedIndex: selectedIndex,
            scrollHeight: 170,
            spacing: 12,
            leadingPadding: 5,
            trailingContentInset: 16
        )
        
        section.onCardSelected = { [weak self] index in
            guard let self else { return }
            let tappedCategory = HydrationAmountEnum.allCases[index]
            self.viewModel.selectedAmount = tappedCategory
        }
        
        self.hydrationAmountSectionView = section
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
        
        let inputView = HydrationMeasureInputView(
            initialValue: Int(viewModel.customValue),
            unit: .milliliter,
            minValue: 0,
            maxValue: 5000,
            step: 50
        )
        
        inputView.onValueChanged = { [weak self] value, unit in
            self?.viewModel.customValue = Double(value)
            // self?.viewModel.customUnit = unit
        }
        
        inputView.setContentHuggingPriority(.required, for: .horizontal)
        inputView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let stack = UIStackView(arrangedSubviews: [title, inputView])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        
        return stack
    }
    private func configureConfirmationButton() -> StandardConfirmationButton {
        let button = StandardConfirmationButton(title: "Salvar")
        button.addTarget(self, action: #selector(saveHydrationMeasure), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    // MARK: - Actions
    @objc private func saveHydrationMeasure() {
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
        Publishers.CombineLatest(viewModel.$selectedAmount, viewModel.$customValue)
            .sink { [weak self] amount, value in
                guard let self else { return }
                
                let isCustom = amount == .custom
                self.customValueView.isUserInteractionEnabled = isCustom
                self.customValueView.alpha = isCustom ? 1.0 : 0.4
                
                let valid = (amount != nil && (amount != .custom || value > 0))
                self.updateConfirmationButtonState(enabled: valid)
            }
            .store(in: &cancellables)
    }
}
