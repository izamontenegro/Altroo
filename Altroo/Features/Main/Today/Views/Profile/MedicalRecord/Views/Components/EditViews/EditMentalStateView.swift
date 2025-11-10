//
//  EditMentalState.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 30/10/25.
//

import UIKit
import Combine

final class EditMentalStateView: UIView {
    let viewModel: EditMedicalRecordViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?

    private var subscriptions = Set<AnyCancellable>()

    private let headerView: EditSectionHeaderView = {
        let headerView = EditSectionHeaderView(
            sectionTitle: "Estado Mental",
            sectionDescription: "Preencha os campos a seguir quanto aos dados básicos da pessoa cuidada.",
            sectionIcon: "brain.head.profile.fill"
        )
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()

    private lazy var emotionalChipsView: WrappingCapsulesView = {
        let titles = EmotionalStateEnum.allCases.map { $0.displayText }
        let view = WrappingCapsulesView(titles: titles) { [weak self] selectedTitle in
            guard let self else { return }
            if let text = selectedTitle,
               let value = EmotionalStateEnum.allCases.first(where: { $0.displayText == text }) {
                self.viewModel.updateEmotionalState(value)
            } else {
                self.viewModel.updateEmotionalState(nil)
            }
        }
        return view
    }()

    private lazy var emotionalSectionTitleLabel: StandardLabel = {
        StandardLabel(
            labelText: "Estado Emocional",
            labelFont: .sfPro,
            labelType: .headline,
            labelColor: .black10,
            labelWeight: .semibold
        )
    }()

    private lazy var orientationTitleLabel: StandardLabel = {
        StandardLabel(
            labelText: "Orientação",
            labelFont: .sfPro,
            labelType: .headline,
            labelColor: .black10,
            labelWeight: .semibold
        )
    }()

    private lazy var orientationColumn = CheckColumnView(
        options: [
            OrientationEnum.oriented,
            OrientationEnum.disorientedInTime,
            OrientationEnum.disorientedInSpace,
            OrientationEnum.disorientedInPersons
        ],
        titleProvider: { $0.displayText },
        onSelect: { [weak self] selectedOption in
            self?.viewModel.updateOrientationState(selectedOption)
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
        let emotionalContainer = UIStackView(arrangedSubviews: [emotionalSectionTitleLabel, emotionalChipsView])
        emotionalContainer.axis = .vertical
        emotionalContainer.alignment = .fill
        emotionalContainer.spacing = 12

        let orientationContainer = UIStackView(arrangedSubviews: [orientationTitleLabel, orientationColumn])
        orientationContainer.axis = .vertical
        orientationContainer.alignment = .fill
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

    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupUserInterface()
        configureMemoryMenu()
        bindViewModel()
        viewModel.loadInitialMentalStateFormState()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUserInterface() {
        backgroundColor = .pureWhite
        addSubview(headerView)
        addSubview(formStack)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            formStack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15),
            formStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            formStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            formStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20)
        ])
    }

    private func bindViewModel() {
        viewModel.$mentalStateFormState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentState in
                guard let self else { return }

                if let emotionalState = currentState.emotionalState {
                    self.emotionalChipsView.updateSelection(title: emotionalState.displayText)
                } else {
                    self.emotionalChipsView.updateSelection(title: nil)
                }

                if let orientationState = currentState.orientationState {
                    self.orientationColumn.updateSelection(for: orientationState)
                } else {
                    self.orientationColumn.clearSelection()
                }

                if let memoryState = currentState.memoryState {
                    self.memoryPopupButton.setTitle(memoryState.displayText, for: .normal)
                }
            }
            .store(in: &subscriptions)
    }

    private func configureMemoryMenu() {
        let memoryActions = MemoryEnum.allCases.map { option in
            UIAction(title: option.displayText) { [weak self] _ in
                self?.memoryPopupButton.setTitle(option.displayText, for: .normal)
                self?.viewModel.updateMemoryState(option)
            }
        }
        memoryPopupButton.menu = UIMenu(children: memoryActions)
        memoryPopupButton.showsMenuAsPrimaryAction = true
    }
}
