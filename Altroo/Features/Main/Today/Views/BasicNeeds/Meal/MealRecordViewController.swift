//
//  MealRecordViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 19/10/25.
//

import UIKit
import Combine

protocol MealRecordNavigationDelegate: AnyObject {
    func didFinishAddingMealRecord()
}

final class MealRecordViewController: GradientNavBarViewController {
    weak var delegate: MealRecordNavigationDelegate?
    
    private let viewModel: MealRecordViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var mealCategoryButtons: [UIButton] = []
    private var mealAmountEatenButtons: [UIButton] = []
    private var observationTextField: UITextField?
    
    private var confirmationButton: StandardConfirmationButton!
    
    init(viewModel: MealRecordViewModel) {
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
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        let viewTitle = StandardLabel(
            labelText: "Adicionar Alimentação",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        
        let viewSubtitle = StandardLabel(
            labelText: "Registre uma refeição e o nível de aceitação do assistido a comida.",
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black30,
            labelWeight: .regular
        )
        
        viewSubtitle.numberOfLines = 0
        viewSubtitle.lineBreakMode = .byWordWrapping
        
        let headerStackView = UIStackView()
        headerStackView.axis = .vertical
        headerStackView.alignment = .fill
        headerStackView.spacing = 4
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        headerStackView.addArrangedSubview(viewTitle)
        headerStackView.addArrangedSubview(viewSubtitle)
        
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.spacing = 24
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mealCategorySection = makeMealCategorySection()
        let mealAmountEatenSection = makeMealAmountEatenSection()
        let mealObservationSection = makeMealObservationSection()
        
        confirmationButton = configureConfirmationButton()
        
        contentStackView.addArrangedSubview(headerStackView)
        contentStackView.addArrangedSubview(mealCategorySection)
        contentStackView.addArrangedSubview(mealAmountEatenSection)
        contentStackView.addArrangedSubview(mealObservationSection)
        
        view.addSubview(contentStackView)
        view.addSubview(confirmationButton)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            confirmationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            confirmationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        updateConfirmationButtonState(enabled: false)
    }
    
    // MARK: - Sections
    
    private func makeMealCategorySection() -> UIView {
        let title = StandardLabel(
            labelText: "Qual o tipo da refeição?",
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
        currentRow.distribution = .fillProportionally
        
        var totalWidth: CGFloat = 0
        let maximumWidth = UIScreen.main.bounds.width - 32
        
        for (index, category) in MealCategoryEnum.allCases.enumerated() {
            let button = PrimaryStyleButton(title: category.displayText)
            button.backgroundColor = .black40
            button.setTitleColor(.white, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(mealCategoryTapped(_:)), for: .touchUpInside)
            
            mealCategoryButtons.append(button)
            
            let estimatedWidth = button.intrinsicContentSize.width + 32
            if totalWidth + estimatedWidth > maximumWidth {
                container.addArrangedSubview(currentRow)
                currentRow = UIStackView()
                currentRow.axis = .horizontal
                currentRow.spacing = 12
                currentRow.distribution = .fillProportionally
                totalWidth = 0
            }
            
            currentRow.addArrangedSubview(button)
            totalWidth += estimatedWidth + 12
        }
        
        container.addArrangedSubview(currentRow)
        
        let section = UIStackView(arrangedSubviews: [title, container])
        section.axis = .vertical
        section.spacing = 16
        return section
    }
    
    private func makeMealAmountEatenSection() -> UIView {
        let title = StandardLabel(
            labelText: "Quanto da refeição foi comida?",
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
        currentRow.distribution = .fill
        
        var totalWidth: CGFloat = 0
        let maximumWidth = UIScreen.main.bounds.width - 32
        
        for (index, amount) in MealAmountEatenEnum.allCases.enumerated() {
            let button = PrimaryStyleButton(title: amount.displayText)
            button.backgroundColor = .black40
            button.setTitleColor(.white, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(mealAmountEatenTapped(_:)), for: .touchUpInside)
            
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
            button.titleLabel?.lineBreakMode = .byClipping
            
            let estimatedWidth = button.intrinsicContentSize.width + 32
            
            if totalWidth + estimatedWidth > maximumWidth {
                container.addArrangedSubview(currentRow)
                currentRow = UIStackView()
                currentRow.axis = .horizontal
                currentRow.spacing = 12
                currentRow.distribution = .fill
                totalWidth = 0
            }
            
            currentRow.addArrangedSubview(button)
            mealAmountEatenButtons.append(button)
            totalWidth += estimatedWidth + 12
        }
        
        container.addArrangedSubview(currentRow)
        
        let section = UIStackView(arrangedSubviews: [title, container])
        section.axis = .vertical
        section.spacing = 16
        return section
    }
    
    private func makeMealObservationSection() -> UIView {
        let title = StandardLabel(
            labelText: "Observação",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .semibold
        )
        
        let textField = StandardTextfield()
        textField.addTarget(self, action: #selector(observationChanged(_:)), for: .editingChanged)
        self.observationTextField = textField
        
        let section = UIStackView(arrangedSubviews: [title, textField])
        section.axis = .vertical
        section.spacing = 8
        return section
    }
    
    private func configureConfirmationButton() -> StandardConfirmationButton {
        let button = StandardConfirmationButton(title: "Adicionar")
        button.addTarget(self, action: #selector(createFeedingRecord), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    
    // MARK: - Actions
    private func updateConfirmationButtonState(enabled: Bool) {
        confirmationButton.isUserInteractionEnabled = enabled
        UIView.animate(withDuration: 0.2) {
            self.confirmationButton.backgroundColor = enabled ? .teal20 : .black20
        }
    }
    
    @objc private func mealCategoryTapped(_ sender: PrimaryStyleButton) {
        let tappedCategory = MealCategoryEnum.allCases[sender.tag]

        if viewModel.selectedMealCategory == tappedCategory {
            viewModel.selectedMealCategory = nil
        } else {
            viewModel.selectedMealCategory = tappedCategory
        }

        mealCategoryButtons.enumerated().forEach { index, button in
            let isSelected = viewModel.selectedMealCategory == MealCategoryEnum.allCases[index]
            button.backgroundColor = isSelected ? .teal20 : .black40
            button.setTitleColor(.white, for: .normal)
        }
    }

    @objc private func mealAmountEatenTapped(_ sender: PrimaryStyleButton) {
        let tappedAmount = MealAmountEatenEnum.allCases[sender.tag]

     
        if viewModel.selectedMealAmountEaten == tappedAmount {
            viewModel.selectedMealAmountEaten = nil
        } else {
            viewModel.selectedMealAmountEaten = tappedAmount
        }

        mealAmountEatenButtons.enumerated().forEach { index, button in
            let isSelected = viewModel.selectedMealAmountEaten == MealAmountEatenEnum.allCases[index]
            button.backgroundColor = isSelected ? .teal20 : .black40
            button.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc private func observationChanged(_ sender: UITextField) {
        viewModel.notes = sender.text ?? ""
    }
    
    @objc private func createFeedingRecord() {
        viewModel.createFeedingRecord()
        delegate?.didFinishAddingMealRecord()
    }
    
    // MARK: - Combine Bindings
    
    private func bindViewModel() {
        viewModel.$selectedMealCategory
            .sink { [weak self] selected in
                guard let self, let selected else { return }
                for (index, button) in self.mealCategoryButtons.enumerated() {
                    let isSelected = MealCategoryEnum.allCases[index] == selected
                    button.backgroundColor = isSelected ? .teal20 : .black40
                    button.setTitleColor(.white, for: .normal)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$selectedMealAmountEaten
            .sink { [weak self] selected in
                guard let self, let selected else { return }
                for (index, button) in self.mealAmountEatenButtons.enumerated() {
                    let isSelected = MealAmountEatenEnum.allCases[index] == selected
                    button.backgroundColor = isSelected ? .teal20 : .black40
                    button.setTitleColor(.white, for: .normal)
                }
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest(viewModel.$selectedMealCategory, viewModel.$selectedMealAmountEaten)
            .sink { [weak self] category, amount in
                let bothSelected = (category != nil && amount != nil)
                self?.updateConfirmationButtonState(enabled: bothSelected)
            }
            .store(in: &cancellables)
    }
}
