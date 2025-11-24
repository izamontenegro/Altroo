//
//  EditPersonalDataViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 28/10/25.
//

import UIKit

final class EditPersonalCareViewController: UIViewController, UITextFieldDelegate {

    let viewModel: EditPersonalCareViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?

    private let header: EditSectionHeaderView = {
        let header = EditSectionHeaderView(
            sectionTitle: "Cuidados Pessoais",
            sectionDescription: "patient_profile_description".localized,
            sectionIcon: "hand.raised.fill"
        )
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    private lazy var bathPopupMenuButton: PopupMenuButton = {
        let button = PopupMenuButton(title: BathEnum.withAssistance.displayText)
        button.backgroundColor = .blue40
        return button
    }()

    private lazy var hygienePopupMenuButton: PopupMenuButton = {
        let button = PopupMenuButton(title: HygieneEnum.withoutAssistance.displayText)
        button.backgroundColor = .blue40
        return button
    }()

    private lazy var excretionPopupMenuButton: PopupMenuButton = {
        let button = PopupMenuButton(title: ExcretionEnum.normal.displayText)
        button.backgroundColor = .blue40
        return button
    }()

    private lazy var feedingPopupMenuButton: PopupMenuButton = {
        let button = PopupMenuButton(title: FeedingEnum.soft.displayText)
        button.backgroundColor = .blue40
        return button
    }()

    private lazy var equipmentsTextField: StandardTextfield = {
        let textField = StandardTextfield(placeholder: "Equipamentos separados por vírgulas")
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var bathSection = FormSectionView(title: "Banho", content: bathPopupMenuButton)
    private lazy var hygieneSection = FormSectionView(title: "Higiene", content: hygienePopupMenuButton)
    private lazy var excretionSection = FormSectionView(title: "Excreção", content: excretionPopupMenuButton)
    private lazy var feedingSection = FormSectionView(title: "feeding".localized, content: feedingPopupMenuButton)
    private lazy var equipmentsSection = FormSectionView(title: "Equipamentos", content: equipmentsTextField)

    private lazy var firstRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [bathSection, hygieneSection])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .top
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var secondRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [excretionSection, feedingSection])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .top
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var formStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            firstRowStack,
            secondRowStack,
            equipmentsSection
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var keyboardDismissTapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        return tap
    }()

    init(viewModel: EditPersonalCareViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureMenus()
        configureNavBar()
        bindInitialState()
        equipmentsTextField.addTarget(self, action: #selector(equipmentsTextChanged(_:)), for: .editingChanged)
        equipmentsTextField.delegate = self
        view.addGestureRecognizer(keyboardDismissTapGesture)
    }

    private func setupUI() {
        view.backgroundColor = .pureWhite

        view.addSubview(header)
        view.addSubview(formStack)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            formStack.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 15),
            formStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            formStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            formStack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
    }

    private func bindInitialState() {
        viewModel.loadInitialPersonalCareFormState()

        let state = viewModel.personalCareFormState

        if let v = state.bathState {
            bathPopupMenuButton.setTitle(v.displayText, for: .normal)
        } else {
            bathPopupMenuButton.setTitle(BathEnum.withAssistance.displayText, for: .normal)
        }

        if let v = state.hygieneState {
            hygienePopupMenuButton.setTitle(v.displayText, for: .normal)
        } else {
            hygienePopupMenuButton.setTitle(HygieneEnum.withoutAssistance.displayText, for: .normal)
        }

        if let v = state.excretionState {
            excretionPopupMenuButton.setTitle(v.displayText, for: .normal)
        } else {
            excretionPopupMenuButton.setTitle(ExcretionEnum.normal.displayText, for: .normal)
        }

        if let v = state.feedingState {
            feedingPopupMenuButton.setTitle(v.displayText, for: .normal)
        } else {
            feedingPopupMenuButton.setTitle(FeedingEnum.soft.displayText, for: .normal)
        }

        equipmentsTextField.text = state.equipmentsText
    }

    private func configureMenus() {
        bathPopupMenuButton.menu = UIMenu(children: BathEnum.allCases.map { option in
            UIAction(title: option.displayText, handler: { [weak self] _ in
                self?.bathPopupMenuButton.setTitle(option.displayText, for: .normal)
                self?.viewModel.updateBathState(option)
            })
        })
        bathPopupMenuButton.showsMenuAsPrimaryAction = true

        hygienePopupMenuButton.menu = UIMenu(children: HygieneEnum.allCases.map { option in
            UIAction(title: option.displayText, handler: { [weak self] _ in
                self?.hygienePopupMenuButton.setTitle(option.displayText, for: .normal)
                self?.viewModel.updateHygieneState(option)
            })
        })
        hygienePopupMenuButton.showsMenuAsPrimaryAction = true

        excretionPopupMenuButton.menu = UIMenu(children: ExcretionEnum.allCases.map { option in
            UIAction(title: option.displayText, handler: { [weak self] _ in
                self?.excretionPopupMenuButton.setTitle(option.displayText, for: .normal)
                self?.viewModel.updateExcretionState(option)
            })
        })
        excretionPopupMenuButton.showsMenuAsPrimaryAction = true

        feedingPopupMenuButton.menu = UIMenu(children: FeedingEnum.allCases.map { option in
            UIAction(title: option.displayText, handler: { [weak self] _ in
                self?.feedingPopupMenuButton.setTitle(option.displayText, for: .normal)
                self?.viewModel.updateFeedingState(option)
            })
        })
        feedingPopupMenuButton.showsMenuAsPrimaryAction = true
    }

    @objc private func equipmentsTextChanged(_ sender: UITextField) {
        viewModel.updateEquipmentsText(sender.text ?? "")
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func persistAllFromView() {
        viewModel.updateEquipmentsText(equipmentsTextField.text ?? "")
        viewModel.persistPersonalCareFormState()
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
