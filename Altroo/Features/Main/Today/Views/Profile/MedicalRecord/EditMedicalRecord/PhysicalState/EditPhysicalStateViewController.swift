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

    private lazy var visionPopupButton: PopupMenuButton = {
        let button = PopupMenuButton(title: VisionEnum.noChanges.displayText)
        button.backgroundColor = .blue40
        button.widthAnchor.constraint(equalToConstant: 180).isActive = true
        return button
    }()

    private lazy var hearingPopupButton: PopupMenuButton = {
        let button = PopupMenuButton(title: HearingEnum.withoutDeficit.displayText)
        button.backgroundColor = .blue40
        button.widthAnchor.constraint(equalToConstant: 160).isActive = true
        return button
    }()

    private lazy var locomotionPopupButton: PopupMenuButton = {
        let button = PopupMenuButton(title: MobilityEnum.noAssistance.displayText)
        button.backgroundColor = .blue40
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.widthAnchor.constraint(equalToConstant: 180).isActive = true
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

    private lazy var oralHealthColumn: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .leading
        stack.distribution = .fill

        OralHealthEnum.allCases.forEach { option in
            let button = CheckOptionButton(title: option.displayText)
            button.associatedData = option
            button.isSelected = false

            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)

            button.addTarget(self, action: #selector(didTapOralHealth(_:)), for: .touchUpInside)

            stack.addArrangedSubview(button)
        }

        return stack
    }()

    private lazy var senseRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [visionSection, hearingSection])
        stack.axis = .horizontal
        stack.spacing = 22
        stack.alignment = .leading
        stack.distribution = .fillProportionally
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
        oralHealthContainer.alignment = .leading
        oralHealthContainer.spacing = 12

        let stack = UIStackView(arrangedSubviews: [
            senseRowStack,
            locomotionSection,
            oralHealthContainer
        ])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 16
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
        
        let saveButton = configureConfirmationButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            formStack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15),
            formStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            formStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            formStack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
            oralHealthColumn.arrangedSubviews.forEach { view in
                if let btn = view as? CheckOptionButton,
                   let option = btn.associatedData as? OralHealthEnum {
                    btn.isSelected = (option == oralHealthState)
                }
            }
        } else {
            oralHealthColumn.arrangedSubviews.forEach { view in
                if let btn = view as? CheckOptionButton {
                    btn.isSelected = false
                }
            }
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

    @objc private func didTapOralHealth(_ sender: CheckOptionButton) {
        guard let option = sender.associatedData as? OralHealthEnum else { return }

        oralHealthColumn.arrangedSubviews.forEach { view in
            if let btn = view as? CheckOptionButton {
                btn.isSelected = (btn == sender)
            }
        }

        viewModel.updateOralHealthState(option)
    }
    
    @objc
    func persistAllFromView() {
        viewModel.persistPhysicalState()
        
        dismiss(animated: true)
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
    
    private func configureConfirmationButton() -> StandardConfirmationButton {
        let button = StandardConfirmationButton(title: "Salvar")
        button.addTarget(self, action: #selector(persistAllFromView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
}
