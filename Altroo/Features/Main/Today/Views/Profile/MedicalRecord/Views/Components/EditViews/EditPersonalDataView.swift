//
//  EditPersonalDataViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 28/10/25.
//
import UIKit
import Combine
import CoreData
import CloudKit

final class EditPersonalDataView: UIView, UITextFieldDelegate {
    let viewModel: EditMedicalRecordViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?

    private var subscriptions = Set<AnyCancellable>()
    private let relationshipOptions = ["Cuidador", "Mãe/Pai", "Filha/Filho", "Neta/Neto", "Familiar", "Amigo", "Outro"]

    private let scrollView = UIScrollView.make(direction: .vertical)
    private let contentStack = UIStackView()

    private let genderSegmentedControl = StandardSegmentedControl(items: ["F", "M"])
    private let nameTextField = StandardTextfield(placeholder: "Nome do assistido")
    private let addressTextField = StandardTextfield(placeholder: "Endereço do assistido")

    private let heightTextField: StandardTextfield = {
        let heightField = StandardTextfield()
        heightField.placeholder = "0"
        heightField.keyboardType = .numberPad
        return heightField
    }()

    private let weightTextField: StandardTextfield = {
        let weightField = StandardTextfield()
        weightField.placeholder = "0"
        weightField.keyboardType = .numberPad
        return weightField
    }()

    private let contactNameTextField = StandardTextfield(placeholder: "Nome do contato")
    private let contactPhoneTextField: StandardTextfield = {
        let contactField = StandardTextfield()
        contactField.placeholder = "Telefone com DDI"
        contactField.keyboardType = .numberPad
        return contactField
    }()

    private lazy var relationshipButton: PopupMenuButton = {
        let button = PopupMenuButton(title: relationshipOptions.first!)
        button.showsMenuAsPrimaryAction = true
        button.backgroundColor = .blue40
        button.menu = makeRelationshipMenu(selected: relationshipOptions.first!)
        return button
    }()

    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.preferredDatePickerStyle = .compact
        return datePicker
    }()

    private let ageLabel = StandardLabel(
        labelText: "0 anos",
        labelFont: .sfPro,
        labelType: .largeTitle,
        labelColor: .blue10,
        labelWeight: .regular
    )

    private lazy var header = EditSectionHeaderView(
        sectionTitle: "Dados Pessoais",
        sectionDescription: "Preencha os campos a seguir quanto aos dados básicos da pessoa cuidada.",
        sectionIcon: "person.fill"
    )

    private lazy var nameSection = FormSectionView(title: "Nome", content: nameTextField, isObligatory: true)
    private lazy var birthSection = FormSectionView(title: "Data de Nascimento", content: datePicker)
    private lazy var ageSection = FormSectionView(title: "Idade", content: ageLabel)
    private lazy var heightSection = FormSectionView(title: "Altura", content: heightStack)
    private lazy var weightSection = FormSectionView(title: "Peso", content: weightStack)
    private lazy var genderSection = FormSectionView(title: "Sexo", content: genderSegmentedControl)
    private lazy var addressSection = FormSectionView(title: "Endereço", content: addressTextField)
    private lazy var contactSection = FormSectionView(title: "Contato de Emergência", content: contactStack)

    private lazy var heightStack: UIStackView = {
        let centimetersLabel = StandardLabel(labelText: "cm", labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .regular)
        let stack = UIStackView(arrangedSubviews: [heightTextField, centimetersLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()

    private lazy var weightStack: UIStackView = {
        let kilogramsLabel = StandardLabel(labelText: "kg", labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .regular)
        let stack = UIStackView(arrangedSubviews: [weightTextField, kilogramsLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()

    private lazy var physicalInfoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [weightSection, heightSection, genderSection])
        stack.axis = .horizontal
        stack.spacing = Layout.smallSpacing
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var birthAndAgeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [birthSection, ageSection])
        stack.axis = .horizontal
        stack.spacing = Layout.mediumSpacing
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var contactStack: UIStackView = {
        let nameSection = FormSectionView(title: "Nome", content: contactNameTextField, isSubsection: true)
        let phoneSection = FormSectionView(title: "Telefone", content: contactPhoneTextField, isSubsection: true)
        let relationshipSection = FormSectionView(title: "Relação", content: relationshipButton, isSubsection: true)
        let horizontalStack = UIStackView(arrangedSubviews: [phoneSection, relationshipSection])
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = Layout.smallSpacing
        horizontalStack.distribution = .fillEqually
        let verticalStack = UIStackView(arrangedSubviews: [nameSection, horizontalStack])
        verticalStack.axis = .vertical
        verticalStack.spacing = Layout.verySmallSpacing
        return verticalStack
    }()

    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
        bindViewModel()
        bindInputs()
        fillInformations()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        backgroundColor = .pureWhite
        addSubview(scrollView)
        scrollView.addSubview(contentStack)

        contentStack.axis = .vertical
        contentStack.spacing = 22
        contentStack.alignment = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        [header, nameSection, birthAndAgeStack, physicalInfoStack, addressSection, contactSection].forEach {
            contentStack.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: Layout.smallSpacing),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Layout.mediumSpacing),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Layout.mediumSpacing),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Layout.smallSpacing),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -2 * Layout.mediumSpacing)
        ])

        datePicker.addTarget(self, action: #selector(updateAgeLabel), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }

    private func makeRelationshipMenu(selected: String) -> UIMenu {
        let actions: [UIAction] = relationshipOptions.map { option in
            let isSelected = (option == selected)
            return UIAction(title: option, state: isSelected ? .on : .off) { [weak self] action in
                guard let self else { return }
                self.relationshipButton.setTitle(action.title, for: .normal)
                self.relationshipButton.menu = self.makeRelationshipMenu(selected: action.title)
                self.viewModel.updateContactRelationship(action.title)
            }
        }
        return UIMenu(options: .singleSelection, children: actions)
    }

    private func bindViewModel() {
        viewModel.$personalDataFormState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self else { return }
                if nameTextField.text != state.name { nameTextField.text = state.name }
                if addressTextField.text != state.address { addressTextField.text = state.address }

                let hText = state.height.map { String($0) } ?? ""
                if heightTextField.text != hText { heightTextField.text = hText }
                let wText = state.weight.map { String($0) } ?? ""
                if weightTextField.text != wText { weightTextField.text = wText }

                if state.gender == "F" { genderSegmentedControl.selectedSegmentIndex = 0 }
                else if state.gender == "M" { genderSegmentedControl.selectedSegmentIndex = 1 }

                if let contact = state.emergencyContact {
                    contactNameTextField.text = contact.name
                    contactPhoneTextField.text = contact.phone
                    if let relationship = contact.relationship {
                        relationshipButton.setTitle(relationship, for: .normal)
                        relationshipButton.menu = makeRelationshipMenu(selected: relationship)
                    }
                }
            }
            .store(in: &subscriptions)
    }

    private func bindInputs() {
        nameTextField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(addressChanged), for: .editingChanged)
        contactNameTextField.addTarget(self, action: #selector(contactNameChanged), for: .editingChanged)
        contactPhoneTextField.addTarget(self, action: #selector(contactPhoneChanged), for: .editingChanged)

        heightTextField.addTarget(self, action: #selector(heightChanged), for: .editingChanged)
        weightTextField.addTarget(self, action: #selector(weightChanged), for: .editingChanged)
        genderSegmentedControl.addTarget(self, action: #selector(genderChanged), for: .valueChanged)
    }

    @objc private func heightChanged() { viewModel.updateHeight(from: heightTextField.text ?? "") }
    @objc private func weightChanged() { viewModel.updateWeight(from: weightTextField.text ?? "") }
    @objc private func genderChanged() {
        let g = (genderSegmentedControl.selectedSegmentIndex == 0) ? "F" : "M"
        viewModel.updateGender(g)
    }

    @objc private func nameChanged() { viewModel.updateName(nameTextField.text ?? "") }
    @objc private func addressChanged() { viewModel.updateAddress(addressTextField.text ?? "") }
    @objc private func contactNameChanged() { viewModel.updateContactName(contactNameTextField.text ?? "") }
    @objc private func contactPhoneChanged() { viewModel.updateContactPhone(contactPhoneTextField.text ?? "") }

    @objc private func updateAgeLabel() {
        let age = Calendar.current.dateComponents([.year], from: datePicker.date, to: Date()).year ?? 0
        ageLabel.updateLabelText("\(age) anos")
        viewModel.updateDateOfBirth(datePicker.date)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }

    func fillInformations() {
        viewModel.loadInitialPersonalDataFormState()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
