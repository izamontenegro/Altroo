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

final class MealRecordViewController: UIViewController {
    weak var delegate: MealRecordNavigationDelegate?
    private var keyboardHandler: KeyboardHandler?
    
    private let viewModel: MealRecordViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var mealCategorySectionView: BasicNeedsCardsScrollSectionView?
    private var mealAmountEatenButtons: [UIButton] = []
    private var observationView: ObservationView?
    
    private var confirmationButton: StandardConfirmationButton!
    
    init(viewModel: MealRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite
        setupLayout()
        bindViewModel()
        setupTapToDismiss()
        configureNavBar()
        
        keyboardHandler = KeyboardHandler(viewController: self)
    }
    
    private func configureNavBar() {
        let closeButton = UIBarButtonItem(title: "Fechar", style: .done, target: self, action: #selector(closeTapped))
        closeButton.tintColor = .blue20
        navigationItem.leftBarButtonItem = closeButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }

    // MARK: - Layout
    
    private func setupLayout() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true

        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.spacing = 24
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        let headerView = StandardHeaderView(
            title: "record_meal".localized,
            subtitle: "Registre uma refeição e o nível de aceitação do assistido com a comida."
        )
        
        let mealCategorySection = makeMealCategorySection()
        let mealAmountEatenSection = makeMealAmountEatenSection()
        let mealObservationSection = makeMealObservationSection()
        
        confirmationButton = configureConfirmationButton()
        
        contentStackView.addArrangedSubview(headerView)
        contentStackView.addArrangedSubview(mealCategorySection)
        contentStackView.addArrangedSubview(mealAmountEatenSection)
        contentStackView.addArrangedSubview(mealObservationSection)
        
        let buttonContainer = UIView()
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.addSubview(confirmationButton)
        
        NSLayoutConstraint.activate([
            confirmationButton.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            confirmationButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor),
            confirmationButton.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor),
            confirmationButton.widthAnchor.constraint(equalToConstant: 188),
            confirmationButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        let bottomSpacer = UIView()
        bottomSpacer.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        contentStackView.addArrangedSubview(buttonContainer)
        contentStackView.addArrangedSubview(bottomSpacer)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
        
        updateConfirmationButtonState(enabled: false)
    }
    // MARK: - Sections
    
    private func makeMealCategorySection() -> UIView {
        let categories = MealCategoryEnum.allCases
        
        let imageNames = categories.map { $0.displayImageName }
        let subtitles = categories.map { _ in "Tipo" }
        let titles = categories.map { $0.displayName }
        
        let selectedIndex: Int?
        if let selected = viewModel.selectedMealCategory,
           let idx = categories.firstIndex(of: selected) {
            selectedIndex = idx
        } else {
            selectedIndex = nil
        }
        
        let section = BasicNeedsCardsScrollSectionView(
            title: "Qual o tipo da refeição?",
            imageNames: imageNames,
            subtitles: subtitles,
            titles: titles,
            selectedIndex: selectedIndex,
            scrollHeight: 160,
            spacing: 12,
            leadingPadding: 5,
            trailingContentInset: 16
        )
        
        section.onCardSelected = { [weak self] index in
            guard let self else { return }
            let tappedCategory = MealCategoryEnum.allCases[index]
            self.viewModel.selectedMealCategory = tappedCategory
        }
        
        self.mealCategorySectionView = section
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
        container.axis = .horizontal
        container.spacing = 16
        container.alignment = .leading
        container.distribution = .fill
        
        for (index, amount) in MealAmountEatenEnum.allCases.enumerated() {
            let button = OutlineRectangleButton(title: amount.displayText)
            button.tag = index
            button.addTarget(self, action: #selector(mealAmountEatenTapped(_:)), for: .touchUpInside)
            
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            mealAmountEatenButtons.append(button)
            container.addArrangedSubview(button)
        }
        
        let section = UIStackView(arrangedSubviews: [title, container])
        section.axis = .vertical
        section.spacing = 16
        section.alignment = .leading
        
        return section
    }
    
    private func makeMealObservationSection() -> UIView {
        let title = StandardLabel(
            labelText: "observation".localized,
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .semibold
        )
        
        let obs = ObservationView(placeholder: "Detalhes opcionais")
        obs.delegate = self
        obs.translatesAutoresizingMaskIntoConstraints = false
        self.observationView = obs
        
        let section = UIStackView(arrangedSubviews: [title, obs])
        section.axis = .vertical
        section.spacing = 8
        return section
    }
    
    private func configureConfirmationButton() -> StandardConfirmationButton {
        let button = StandardConfirmationButton(title: "add".localized)
        button.addTarget(self, action: #selector(createFeedingRecord), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // MARK: - Actions
    
    private func updateConfirmationButtonState(enabled: Bool) {
        confirmationButton.isUserInteractionEnabled = enabled
        UIView.animate(withDuration: 0.2) {
            self.confirmationButton.backgroundColor = enabled ? .teal20 : .white50
        }
    }
    
    @objc private func mealAmountEatenTapped(_ sender: OutlineRectangleButton) {
        let tappedAmount = MealAmountEatenEnum.allCases[sender.tag]
        
        if viewModel.selectedMealAmountEaten == tappedAmount {
            viewModel.selectedMealAmountEaten = nil
        } else {
            viewModel.selectedMealAmountEaten = tappedAmount
        }
    }
    
    @objc private func createFeedingRecord() {
        viewModel.createFeedingRecord()
        delegate?.didFinishAddingMealRecord()
        dismiss(animated: true)

    }
    
    private func setupTapToDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Combine Bindings
    
    private func bindViewModel() {
        viewModel.$selectedMealCategory
            .sink { [weak self] selected in
                guard let self else { return }
                
                let index: Int?
                if let selected,
                   let idx = MealCategoryEnum.allCases.firstIndex(of: selected) {
                    index = idx
                } else {
                    index = nil
                }
                
                self.mealCategorySectionView?.updateSelection(index: index)
            }
            .store(in: &cancellables)
        
        viewModel.$selectedMealAmountEaten
            .sink { [weak self] selected in
                guard let self else { return }
                for (index, button) in self.mealAmountEatenButtons.enumerated() {
                    let isSelected = MealAmountEatenEnum.allCases[index] == selected
                    button.isSelected = isSelected
                }
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest(viewModel.$selectedMealCategory, viewModel.$selectedMealAmountEaten)
            .sink { [weak self] category, amount in
                self?.updateConfirmationButtonState(enabled: category != nil)
            }
            .store(in: &cancellables)
    }
}

// MARK: - ObservationViewDelegate

extension MealRecordViewController: ObservationViewDelegate {
    func observationView(_ view: ObservationView, didChangeText text: String) {
        viewModel.notes = text
    }
}
