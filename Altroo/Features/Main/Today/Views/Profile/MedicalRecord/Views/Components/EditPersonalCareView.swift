//
//  EditPersonalDataViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 28/10/25.
//

import UIKit
import Combine

final class EditPersonalCareView: UIView, UITextFieldDelegate {
    let viewModel: EditMedicalRecordViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?

    private var subscriptions = Set<AnyCancellable>()

    private let header: EditSectionHeaderView = {
        let header = EditSectionHeaderView(
            sectionTitle: "Cuidados Pessoais",
            sectionDescription: "Preencha os campos a seguir quanto aos dados básicos da pessoa cuidada.",
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
        return textField
    }()

    private lazy var bathSection = FormSectionView(title: "Banho", content: bathPopupMenuButton)
    private lazy var hygieneSection = FormSectionView(title: "Higiene", content: hygienePopupMenuButton)
    private lazy var excretionSection = FormSectionView(title: "Excreção", content: excretionPopupMenuButton)
    private lazy var feedingSection = FormSectionView(title: "Alimentação", content: feedingPopupMenuButton)
    private lazy var equipmentsSection = FormSectionView(title: "Equipamentos", content: equipmentsTextField)

    private lazy var firstRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [bathSection, hygieneSection])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .top
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var secondRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [excretionSection, feedingSection])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .top
        stack.distribution = .fillProportionally
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

    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
        configureMenus()
        bindViewModel()
        viewModel.loadInitialPersonalCareFormState()
        fillInitialEquipmentsFromModel()
        equipmentsTextField.addTarget(self, action: #selector(equipmentsTextChanged(_:)), for: .editingChanged)

       
        equipmentsTextField.delegate = self

        addGestureRecognizer(keyboardDismissTapGesture)
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
        viewModel.$personalCareFormState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                if let v = state.bathState { self.bathPopupMenuButton.setTitle(v.displayText, for: .normal) }
                if let v = state.hygieneState { self.hygienePopupMenuButton.setTitle(v.displayText, for: .normal) }
                if let v = state.excretionState { self.excretionPopupMenuButton.setTitle(v.displayText, for: .normal) }
                if let v = state.feedingState { self.feedingPopupMenuButton.setTitle(v.displayText, for: .normal) }
                if self.equipmentsTextField.text != state.equipmentsText {
                    self.equipmentsTextField.text = state.equipmentsText
                }
            }
            .store(in: &subscriptions)
    }

    @objc private func equipmentsTextChanged(_ sender: UITextField) {
        viewModel.updateEquipmentsText(sender.text ?? "")
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

    private func fillInitialEquipmentsFromModel() {
        guard let patient = viewModel.userService.fetchCurrentPatient(),
              let csv = patient.personalCare?.equipmentState, !csv.isEmpty else { return }
        equipmentsTextField.text = csv
    }

    @objc private func dismissKeyboard() {
        endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
