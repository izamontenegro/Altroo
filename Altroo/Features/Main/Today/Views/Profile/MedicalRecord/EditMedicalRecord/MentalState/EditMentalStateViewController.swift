//
//  EditMentalState.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 30/10/25.
//
import UIKit

final class EditMentalStateViewController: UIViewController {

    let viewModel: EditMentalStateViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?

    private let headerView: EditSectionHeaderView = {
        let headerView = EditSectionHeaderView(
            sectionTitle: "Estado Mental",
            sectionDescription: "patient_profile_description".localized,
            sectionIcon: "brain.head.profile.fill"
        )
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()


    private lazy var emotionalSectionTitleLabel = StandardLabel(
        labelText: "Estado Emocional",
        labelFont: .sfPro,
        labelType: .headline,
        labelColor: .black10,
        labelWeight: .semibold
    )

    private lazy var orientationTitleLabel = StandardLabel(
        labelText: "Orientação",
        labelFont: .sfPro,
        labelType: .headline,
        labelColor: .black10,
        labelWeight: .semibold
    )

    private lazy var emotionalColumn: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .leading

        let options = EmotionalStateEnum.allCases

        let firstRow = Array(options.prefix(3))
        let secondRow = Array(options.suffix(from: 3))

        let row1 = UIStackView()
        row1.axis = .horizontal
        row1.spacing = 12
        row1.alignment = .leading
        row1.distribution = .fill

        firstRow.forEach { option in
            let button = CheckOptionButton(title: option.displayText)
            button.associatedData = option
            button.isSelected = false
            button.addTarget(self, action: #selector(didTapEmotional(_:)), for: .touchUpInside)
            row1.addArrangedSubview(button)
        }

        let row2 = UIStackView()
        row2.axis = .horizontal
        row2.spacing = 12
        row2.alignment = .leading
        row2.distribution = .fill

        secondRow.forEach { option in
            let button = CheckOptionButton(title: option.displayText)
            button.associatedData = option
            button.isSelected = false
            button.addTarget(self, action: #selector(didTapEmotional(_:)), for: .touchUpInside)
            row2.addArrangedSubview(button)
        }

        stack.addArrangedSubview(row1)
        stack.addArrangedSubview(row2)

        return stack
    }()

    private lazy var orientationColumn: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .leading
        stack.distribution = .fill

        let options: [OrientationEnum] = [
            .oriented,
            .disorientedInTime,
            .disorientedInSpace,
            .disorientedInPersons
        ]

        options.forEach { option in
            let button = CheckOptionButton(title: option.displayText)
            button.associatedData = option
            button.isSelected = false

            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)

            button.addTarget(self, action: #selector(didTapOrientation(_:)), for: .touchUpInside)

            stack.addArrangedSubview(button)
        }

        return stack
    }()


    private lazy var memoryPopupButton: PopupMenuButton = {
        let button = PopupMenuButton(title: MemoryEnum.intact.displayText)
        button.backgroundColor = .blue40
        button.widthAnchor.constraint(equalToConstant: 170).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var memorySection = FormSectionView(title: "Memória", content: memoryPopupButton)


    private lazy var formStack: UIStackView = {
        let emotionalContainer = UIStackView(arrangedSubviews: [
            emotionalSectionTitleLabel,
            emotionalColumn
        ])
        emotionalContainer.axis = .vertical
        emotionalContainer.spacing = 12
        emotionalContainer.alignment = .leading

        let orientationContainer = UIStackView(arrangedSubviews: [
            orientationTitleLabel,
            orientationColumn
        ])
        orientationContainer.axis = .vertical
        orientationContainer.spacing = 12
        orientationContainer.alignment = .leading

        let stack = UIStackView(arrangedSubviews: [
            emotionalContainer,
            orientationContainer,
            memorySection
        ])
        stack.alignment = .leading
        stack.axis = .vertical
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    
    init(viewModel: EditMentalStateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureMemoryMenu()
        configureNavBar()
        loadInitialState()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .pureWhite
        
        let saveButton = configureConfirmationButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView)
        view.addSubview(formStack)
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            formStack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15),
            formStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            formStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            formStack.bottomAnchor.constraint(lessThanOrEqualTo: saveButton.topAnchor, constant: -20),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func loadInitialState() {
        viewModel.loadInitialMentalState()
        let state = viewModel.mentalStateFormState

        let selected = state.emotionalState

        emotionalColumn.arrangedSubviews.forEach { row in
            (row as? UIStackView)?.arrangedSubviews.forEach { view in
                guard
                    let button = view as? CheckOptionButton,
                    let option = button.associatedData as? EmotionalStateEnum
                else { return }

                button.isSelected = selected.contains(option)
            }
        }

        orientationColumn.arrangedSubviews.forEach { view in
            guard
                let button = view as? CheckOptionButton,
                let option = button.associatedData as? OrientationEnum
            else { return }

            button.isSelected = state.orientationState.contains(option)
        }
        
        if let memory = state.memoryState {
            memoryPopupButton.setTitle(memory.displayText, for: .normal)
        }
    }

    // MARK: - Menus

    private func configureMemoryMenu() {
        memoryPopupButton.menu = UIMenu(children:
            MemoryEnum.allCases.map { option in
                UIAction(title: option.displayText) { [weak self] _ in
                    self?.memoryPopupButton.setTitle(option.displayText, for: .normal)
                    self?.viewModel.updateMemoryState(option)
                }
            }
        )
        memoryPopupButton.showsMenuAsPrimaryAction = true
    }

    @objc private func didTapEmotional(_ sender: CheckOptionButton) {
        guard let option = sender.associatedData as? EmotionalStateEnum else { return }

        sender.isSelected.toggle()

        let selectedOptions: [EmotionalStateEnum] =
            emotionalColumn.arrangedSubviews.flatMap { row in
                (row as? UIStackView)?.arrangedSubviews.compactMap { view in
                    guard
                        let button = view as? CheckOptionButton,
                        let option = button.associatedData as? EmotionalStateEnum,
                        button.isSelected
                    else { return nil }
                    return option
                } ?? []
            }

        viewModel.updateEmotionalState(selectedOptions)
    }

    @objc private func didTapOrientation(_ sender: CheckOptionButton) {
        
        sender.isSelected.toggle()

        let selectedOptions: [OrientationEnum] = orientationColumn.arrangedSubviews.compactMap { view in
            guard
                let btn = view as? CheckOptionButton,
                let opt = btn.associatedData as? OrientationEnum,
                btn.isSelected
            else { return nil }
            return opt
        }

        viewModel.updateOrientationState(selectedOptions)
    }

    @objc func persistAllFromView() {
        viewModel.persistMentalState()
        dismiss(animated: true)
    }

    private func configureConfirmationButton() -> StandardConfirmationButton {
        let button = StandardConfirmationButton(title: "Salvar")
        button.addTarget(self, action: #selector(persistAllFromView), for: .touchUpInside)
        return button
    }

    // MARK: - NavBar

    private func configureNavBar() {
        navigationItem.title = "Editar".localized
        
        let closeButton = UIBarButtonItem(
            title: "close".localized,
            style: .done,
            target: self,
            action: #selector(closeTapped)
        )
        closeButton.tintColor = .blue10
        navigationItem.leftBarButtonItem = closeButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
}
