//
//  EditPhysicalStateView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 30/10/25.
//
import UIKit

final class EditPhysicalStateViewController: UIViewController {

    let viewModel: EditPhysicalStateViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?

    // MARK: - UI

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

    private lazy var locomotionSection = FormSectionView(
        title: "Locomoção",
        content: locomotionContentContainer
    )

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

    // MARK: - Init

    init(viewModel: EditPhysicalStateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
        configureNavBar()
        configureMenus()
        loadInitialState()
    }

    // MARK: - UI Setup

    private func setupUserInterface() {
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

    // MARK: - Load initial state

    private func loadInitialState() {
        viewModel.loadInitialPhysicalState()
        let state = viewModel.physicalStateFormState

        if let visionState = state.visionState {
            visionPopupButton.setTitle(visionState.displayText, for: .normal)
        } else {
            visionPopupButton.setTitle(VisionEnum.noChanges.displayText, for: .normal)
        }

        if let hearingState = state.hearingState {
            hearingPopupButton.setTitle(hearingState.displayText, for: .normal)
        } else {
            hearingPopupButton.setTitle(HearingEnum.withoutDeficit.displayText, for: .normal)
        }

        if let mobilityState = state.mobilityState {
            locomotionPopupButton.setTitle(mobilityState.displayText, for: .normal)
        } else {
            locomotionPopupButton.setTitle(MobilityEnum.noAssistance.displayText, for: .normal)
        }

        if let oralHealthState = state.oralHealthState {
            oralHealthColumn.updateSelection(for: oralHealthState)
        } else {
            oralHealthColumn.clearSelection()
        }
    }

    // MARK: - Menus

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

    // MARK: - Public helper

    func persistAllFromView() {
        viewModel.persistPhysicalState()
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
