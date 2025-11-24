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

    private lazy var emotionalChipsView: WrappingCapsulesView = {
        let titles = EmotionalStateEnum.allCases.map { $0.displayText }
        let view = WrappingCapsulesView(titles: titles) { [weak self] selected in
            guard let self else { return }
            if let selected,
               let value = EmotionalStateEnum.allCases.first(where: { $0.displayText == selected }) {
                self.viewModel.updateEmotionalState(value)
            } else {
                self.viewModel.updateEmotionalState(nil)
            }
        }
        return view
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

    private lazy var orientationColumn = CheckColumnView(
        options: [
            OrientationEnum.oriented,
            OrientationEnum.disorientedInTime,
            OrientationEnum.disorientedInSpace,
            OrientationEnum.disorientedInPersons
        ],
        titleProvider: { $0.displayText },
        onSelect: { [weak self] option in
            self?.viewModel.updateOrientationState(option)
        }
    )

    private lazy var memoryPopupButton: PopupMenuButton = {
        let button = PopupMenuButton(title: MemoryEnum.intact.displayText)
        button.backgroundColor = .blue40
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 175).isActive = true
        return button
    }()

    private lazy var memorySection = FormSectionView(title: "Memória", content: memoryPopupButton)

    private lazy var formStack: UIStackView = {
        let emotionalContainer = UIStackView(arrangedSubviews: [
            emotionalSectionTitleLabel, emotionalChipsView
        ])
        emotionalContainer.axis = .vertical
        emotionalContainer.spacing = 12

        let orientationContainer = UIStackView(arrangedSubviews: [
            orientationTitleLabel, orientationColumn
        ])
        orientationContainer.axis = .vertical
        orientationContainer.spacing = 12

        let stack = UIStackView(arrangedSubviews: [
            emotionalContainer,
            orientationContainer,
            memorySection
        ])
        stack.axis = .vertical
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - INIT
    
    init(viewModel: EditMentalStateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureMemoryMenu()
        configureNavBar()
        loadInitialState()
    }

    private func setupUI() {
        view.backgroundColor = .pureWhite

        view.addSubview(headerView)
        view.addSubview(formStack)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            formStack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15),
            formStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            formStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            formStack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
    }

    private func loadInitialState() {
        viewModel.loadInitialMentalState()
        let state = viewModel.mentalStateFormState

        emotionalChipsView.updateSelection(with: state.emotionalState?.displayText)

        if let orientation = state.orientationState {
            orientationColumn.updateSelection(for: orientation)
        } else {
            orientationColumn.clearSelection()
        }

        if let memory = state.memoryState {
            memoryPopupButton.setTitle(memory.displayText, for: .normal)
        }
    }

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

    func persistAllFromView() {
        viewModel.persistMentalState()
    }
    
    private func configureNavBar() {
        navigationItem.title = "Editar".localized
        
        let closeButton = UIBarButtonItem(title: "close".localized, style: .done, target: self, action: #selector(closeTapped))
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
