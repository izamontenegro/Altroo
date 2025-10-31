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
    private var oralHealthOptionButtons: [UIButton] = []

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
        return button
    }()

    private let header: EditSectionHeaderView = {
        let header = EditSectionHeaderView(
            sectionTitle: "Estado Físico",
            sectionDescription: "Preencha os campos a seguir quanto aos dados básicos da pessoa cuidada.",
            sectionIcon: "figure.arms.open"
        )
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    private lazy var visionSection = FormSectionView(title: "Visão", content: visionPopupButton)
    private lazy var hearingSection = FormSectionView(title: "Audição", content: hearingPopupButton)
    private lazy var locomotionSection = FormSectionView(title: "Locomoção", content: locomotionPopupButton)

    private lazy var oralHealthTitleLabel: StandardLabel = {
        StandardLabel(
            labelText: "Saúde bucal",
            labelFont: .sfPro,
            labelType: .headline,
            labelColor: .black10,
            labelWeight: .semibold
        )
    }()

    private lazy var oralHealthOptionsStack: UIStackView = {
        let titles: [String] = OralHealthEnum.allCases.map { $0.displayText }
        let rows = titles.map { makeOralHealthOptionRow(text: $0) }
        let stack = UIStackView(arrangedSubviews: rows)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 12
        return stack
    }()

    private lazy var senseRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [visionSection, hearingSection])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var formStack: UIStackView = {
        let oralHealthContainer = UIStackView(arrangedSubviews: [oralHealthTitleLabel, oralHealthOptionsStack])
        oralHealthContainer.axis = .vertical
        oralHealthContainer.alignment = .fill
        oralHealthContainer.spacing = 12

        let stack = UIStackView(arrangedSubviews: [
            senseRowStack,
            locomotionSection,
            oralHealthContainer
        ])

        NSLayoutConstraint.activate([
            locomotionSection.widthAnchor.constraint(equalToConstant: 175)
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
        setupUI()
        configureMenus()
        bindViewModel()
        viewModel.loadInitialPhysicalStateFormState()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        backgroundColor = .pureWhite
        addSubview(header)
        addSubview(formStack)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            formStack.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 15),
            formStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            formStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            formStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20)
        ])
    }

    private func bindViewModel() {
        viewModel.$physicalStateFormState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }

                if let v = state.visionState {
                    self.visionPopupButton.setTitle(v.displayText, for: .normal)
                }
                if let h = state.hearingState {
                    self.hearingPopupButton.setTitle(h.displayText, for: .normal)
                }
                if let m = state.mobilityState {
                    self.locomotionPopupButton.setTitle(m.displayText, for: .normal)
                }

                if let oral = state.oralHealthState {
                    self.selectOralHealth(optionText: oral.displayText)
                } else {
                    self.selectOralHealth(optionText: nil)
                }
            }
            .store(in: &subscriptions)
    }

    private func configureMenus() {
        let visionActions: [UIAction] = VisionEnum.allCases.map { value in
            UIAction(title: value.displayText, handler: { [weak self] _ in
                self?.visionPopupButton.setTitle(value.displayText, for: .normal)
                self?.viewModel.updateVisionState(value)
            })
        }
        visionPopupButton.menu = UIMenu(children: visionActions)
        visionPopupButton.showsMenuAsPrimaryAction = true

        let hearingActions: [UIAction] = HearingEnum.allCases.map { value in
            UIAction(title: value.displayText, handler: { [weak self] _ in
                self?.hearingPopupButton.setTitle(value.displayText, for: .normal)
                self?.viewModel.updateHearingState(value)
            })
        }
        hearingPopupButton.menu = UIMenu(children: hearingActions)
        hearingPopupButton.showsMenuAsPrimaryAction = true

        let locomotionActions: [UIAction] = MobilityEnum.allCases.map { value in
            UIAction(title: value.displayText, handler: { [weak self] _ in
                self?.locomotionPopupButton.setTitle(value.displayText, for: .normal)
                self?.viewModel.updateMobilityState(value)
            })
        }
        locomotionPopupButton.menu = UIMenu(children: locomotionActions)
        locomotionPopupButton.showsMenuAsPrimaryAction = true
    }

    private func makeOralHealthOptionRow(text: String) -> UIView {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue40.cgColor
        button.tintColor = .white
        button.backgroundColor = .clear
        button.setImage(nil, for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 14, weight: .bold), forImageIn: .normal)
        button.contentHorizontalAlignment = .center
        button.widthAnchor.constraint(equalToConstant: 22).isActive = true
        button.heightAnchor.constraint(equalToConstant: 22).isActive = true
        button.accessibilityIdentifier = text

        let label = StandardLabel(
            labelText: text,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black10,
            labelWeight: .regular
        )

        let container = UIStackView(arrangedSubviews: [button, label])
        container.axis = .horizontal
        container.alignment = .center
        container.spacing = 12

        oralHealthOptionButtons.append(button)

        button.addAction(UIAction { [weak self, weak button] _ in
            guard let self, let button else { return }
            self.selectOralHealth(optionText: button.accessibilityIdentifier)
            if let key = button.accessibilityIdentifier,
               let oral = OralHealthEnum.allCases.first(where: { $0.displayText == key }) {
                self.viewModel.updateOralHealthState(oral)
            }
        }, for: .touchUpInside)

        return container
    }

    private func selectOralHealth(optionText: String?) {
        for button in oralHealthOptionButtons {
            let match = (button.accessibilityIdentifier == optionText)
            button.backgroundColor = match ? .blue40 : .clear
            button.layer.borderColor = UIColor.blue40.cgColor
            button.tintColor = .white
            if match {
                button.setImage(UIImage(systemName: "checkmark"), for: .normal)
            } else {
                button.setImage(nil, for: .normal)
            }
        }
    }
}
