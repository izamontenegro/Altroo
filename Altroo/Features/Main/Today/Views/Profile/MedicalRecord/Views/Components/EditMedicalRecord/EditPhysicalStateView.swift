//
//  EditPhysicalStateView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 30/10/25.
//

import UIKit
import Combine

final class EditPhysicalStateView: UIView {
    let viewModel: EditMedicalRecordViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?

    private var subscriptions = Set<AnyCancellable>()

    private lazy var visionPopupButton: PopupMenuButton = {
        let button = PopupMenuButton(title: VisionEnum.noChanges.displayText)
        button.backgroundColor = .blue40
        return button
    }()

    private lazy var hearingPopupButton: PopupMenuButton = {
        let button = PopupMenuButton(title: HearingEnum.withoutDeficit.displayText)
        button.backgroundColor = .blue40
        return button
    }()

    private lazy var locomotionPopupButton: PopupMenuButton = {
        let button = PopupMenuButton(title: MobilityEnum.noAssistance.displayText)
        button.backgroundColor = .blue40
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()

    private lazy var locomotionContentContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [locomotionPopupButton])
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fill
        return stack
    }()

    private lazy var locomotionSection = FormSectionView(title: "Locomoção", content: locomotionContentContainer)

    private let headerView: EditSectionHeaderView = {
        let headerView = EditSectionHeaderView(
            sectionTitle: "Estado Físico",
            sectionDescription: "patient_profile_description".localized,
            sectionIcon: "figure.arms.open"
        )
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()

    private lazy var visionSection = FormSectionView(title: "Visão", content: visionPopupButton)
    private lazy var hearingSection = FormSectionView(title: "Audição", content: hearingPopupButton)

    private lazy var oralHealthTitleLabel: StandardLabel = {
        StandardLabel(
            labelText: "Saúde bucal",
            labelFont: .sfPro,
            labelType: .headline,
            labelColor: .black10,
            labelWeight: .semibold
        )
    }()

    private lazy var oralHealthColumn = CheckColumnView(
        options: OralHealthEnum.allCases,
        titleProvider: { $0.displayText },
        onSelect: { [weak self] selectedOption in
            self?.viewModel.updateOralHealthState(selectedOption)
        }
    )

    private lazy var senseRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [visionSection, hearingSection])
        stack.axis = .vertical
        stack.spacing = 22
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()

    private lazy var locomotionRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [locomotionSection])
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fill
        return stack
    }()

    private lazy var formStack: UIStackView = {
        let oralHealthContainer = UIStackView(arrangedSubviews: [oralHealthTitleLabel, oralHealthColumn])
        oralHealthContainer.axis = .vertical
        oralHealthContainer.alignment = .fill
        oralHealthContainer.spacing = 12

        let stack = UIStackView(arrangedSubviews: [
            senseRowStack,
            locomotionRowStack,
            oralHealthContainer
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupUserInterface()
        configureMenus()
        bindViewModel()
        viewModel.loadInitialPhysicalStateFormState()
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
        viewModel.$physicalStateFormState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentState in
                guard let self else { return }

                if let visionState = currentState.visionState {
                    self.visionPopupButton.setTitle(visionState.displayText, for: .normal)
                }
                if let hearingState = currentState.hearingState {
                    self.hearingPopupButton.setTitle(hearingState.displayText, for: .normal)
                }
                if let mobilityState = currentState.mobilityState {
                    self.locomotionPopupButton.setTitle(mobilityState.displayText, for: .normal)
                }
                if let oralHealthState = currentState.oralHealthState {
                    self.oralHealthColumn.updateSelection(for: oralHealthState)
                } else {
                    self.oralHealthColumn.clearSelection()
                }
            }
            .store(in: &subscriptions)
    }

    private func configureMenus() {
        let visionActions = VisionEnum.allCases.map { option in
            UIAction(title: option.displayText) { [weak self] _ in
                self?.visionPopupButton.setTitle(option.displayText, for: .normal)
                self?.viewModel.updateVisionState(option)
            }
        }
        visionPopupButton.menu = UIMenu(children: visionActions)
        visionPopupButton.showsMenuAsPrimaryAction = true

        let hearingActions = HearingEnum.allCases.map { option in
            UIAction(title: option.displayText) { [weak self] _ in
                self?.hearingPopupButton.setTitle(option.displayText, for: .normal)
                self?.viewModel.updateHearingState(option)
            }
        }
        hearingPopupButton.menu = UIMenu(children: hearingActions)
        hearingPopupButton.showsMenuAsPrimaryAction = true

        let locomotionActions = MobilityEnum.allCases.map { option in
            UIAction(title: option.displayText) { [weak self] _ in
                self?.locomotionPopupButton.setTitle(option.displayText, for: .normal)
                self?.viewModel.updateMobilityState(option)
            }
        }
        locomotionPopupButton.menu = UIMenu(children: locomotionActions)
        locomotionPopupButton.showsMenuAsPrimaryAction = true
    }
}
