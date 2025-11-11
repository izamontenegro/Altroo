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

    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private let scrollView = UIScrollView.make(direction: .vertical)
    private let contentStackView = UIStackView()

    private let genderSegmentedControl = StandardSegmentedControl(items: ["Feminino", "Masculino"])
    private let nameTextField = StandardTextfield(placeholder: "Nome do assistido")
    private let addressTextField = StandardTextfield(placeholder: "Endereço do assistido")

    private let heightTextField: StandardTextfield = {
        let textField = StandardTextfield()
        textField.placeholder = "0"
        textField.keyboardType = .decimalPad
        return textField
    }()

    private let weightTextField: StandardTextfield = {
        let textField = StandardTextfield()
        textField.placeholder = "0"
        textField.keyboardType = .decimalPad
        return textField
    }()

    private let contactNameTextField = StandardTextfield(placeholder: "Nome do contato de emergência")
    private let contactPhoneTextField: StandardTextfield = {
        let textField = StandardTextfield()
        textField.placeholder = "Telefone com DDI"
        textField.keyboardType = .numberPad
        return textField
    }()

    private lazy var relationshipButton: PopupMenuButton = {
        let button = PopupMenuButton(title: relationshipOptions.first ?? "Cuidador")
        button.showsMenuAsPrimaryAction = true
        button.backgroundColor = .blue40
        button.menu = createRelationshipMenu(selected: relationshipOptions.first ?? "Cuidador")
        return button
    }()

    private let dateOfBirthPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        picker.preferredDatePickerStyle = .compact
        return picker
    }()

    private let ageLabel = StandardLabel(
        labelText: "—",
        labelFont: .sfPro,
        labelType: .largeTitle,
        labelColor: .blue10,
        labelWeight: .regular
    )

    private lazy var headerSection = EditSectionHeaderView(
        sectionTitle: "Dados Pessoais",
        sectionDescription: "Preencha os campos a seguir quanto aos dados básicos da pessoa cuidada.",
        sectionIcon: "person.fill"
    )

    private lazy var nameSection = FormSectionView(title: "Nome", content: nameTextField, isObligatory: true)
    private lazy var dateOfBirthSection = FormSectionView(title: "Data de Nascimento", content: dateOfBirthPicker)
    private lazy var ageSection = FormSectionView(title: "Idade", content: ageLabel)
    private lazy var heightSection = FormSectionView(title: "Altura", content: heightStackView)
    private lazy var weightSection = FormSectionView(title: "Peso", content: weightStackView)
    private lazy var genderSection = FormSectionView(title: "Sexo", content: genderSegmentedControl)
    private lazy var addressSection = FormSectionView(title: "Endereço", content: addressTextField)

    private lazy var contactNameSection = FormSectionView(title: "Nome", content: contactNameTextField, isSubsection: true)
    private lazy var contactPhoneSection = FormSectionView(title: "Telefone", content: contactPhoneTextField, isSubsection: true)
    private lazy var contactRelationshipSection = FormSectionView(title: "Relação", content: relationshipButton, isSubsection: true)
    private lazy var contactSection = FormSectionView(title: "Contato de Emergência", content: contactStackView)

    private lazy var heightStackView: UIStackView = {
        let centimetersLabel = StandardLabel(labelText: "cm", labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .regular)
        let stackView = UIStackView(arrangedSubviews: [heightTextField, centimetersLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()

    private lazy var weightStackView: UIStackView = {
        let kilogramsLabel = StandardLabel(labelText: "kg", labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .regular)
        let stackView = UIStackView(arrangedSubviews: [weightTextField, kilogramsLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()

    private lazy var physicalInformationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weightSection, heightSection, genderSection])
        stackView.axis = .horizontal
        stackView.spacing = Layout.smallSpacing
        stackView.distribution = .fill
        stackView.alignment = .top
        return stackView
    }()

    private lazy var dateOfBirthAndAgeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateOfBirthSection, ageSection])
        stackView.axis = .horizontal
        stackView.spacing = Layout.mediumSpacing
        stackView.distribution = .fill
        stackView.alignment = .top
        return stackView
    }()

    private lazy var contactStackView: UIStackView = {
        let phoneAndRelationshipStackView = UIStackView(arrangedSubviews: [contactPhoneSection, contactRelationshipSection])
        phoneAndRelationshipStackView.axis = .horizontal
        phoneAndRelationshipStackView.spacing = Layout.smallSpacing
        phoneAndRelationshipStackView.distribution = .fill
        phoneAndRelationshipStackView.alignment = .top
        
        let verticalStackView = UIStackView(arrangedSubviews: [contactNameSection, phoneAndRelationshipStackView])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = Layout.verySmallSpacing
        return verticalStackView
    }()
    
    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureUserInterface()
        bindViewModel()
        bindInputs()
        loadExistingInformation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUserInterface() {
        backgroundColor = .pureWhite
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        contentStackView.axis = .vertical
        contentStackView.spacing = 22
        contentStackView.alignment = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        [headerSection, nameSection, dateOfBirthAndAgeStackView, physicalInformationStackView, addressSection, contactSection].forEach {
            contentStackView.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: Layout.smallSpacing),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Layout.mediumSpacing),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Layout.mediumSpacing),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Layout.smallSpacing),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -2 * Layout.mediumSpacing)
        ])

        dateOfBirthPicker.addTarget(self, action: #selector(updateAgeLabel), for: .valueChanged)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)

        let allTextFields: [UITextField] = [
            nameTextField,
            addressTextField,
            heightTextField,
            weightTextField,
            contactNameTextField,
            contactPhoneTextField
        ]
        allTextFields.forEach { $0.delegate = self }
    }
    
    private func bindViewModel() {
        viewModel.$personalDataFormState
            .receive(on: RunLoop.main)
            .sink { [weak self] formState in
                guard let self = self else { return }

                if !self.weightTextField.isFirstResponder {
                    let weightText = formState.weight.flatMap { self.numberFormatter.string(from: NSNumber(value: $0)) } ?? ""
                    if self.weightTextField.text != weightText { self.weightTextField.text = weightText }
                }

                if !self.heightTextField.isFirstResponder {
                    let heightText = formState.height.flatMap { self.numberFormatter.string(from: NSNumber(value: $0)) } ?? ""
                    if self.heightTextField.text != heightText { self.heightTextField.text = heightText }
                }

                if self.nameTextField.text != formState.name { self.nameTextField.text = formState.name }
                if self.addressTextField.text != formState.address { self.addressTextField.text = formState.address }

                if formState.gender == "F" { self.genderSegmentedControl.selectedSegmentIndex = 0 }
                else if formState.gender == "M" { self.genderSegmentedControl.selectedSegmentIndex = 1 }

                if let dateOfBirth = formState.dateOfBirth {
                    if self.dateOfBirthPicker.date != dateOfBirth {
                        self.dateOfBirthPicker.setDate(dateOfBirth, animated: false)
                    }
                    let years = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0
                    self.ageLabel.updateLabelText("\(years) anos")
                } else {
                    self.ageLabel.updateLabelText("—")
                }

                if let emergencyContact = formState.emergencyContact {
                    self.contactNameTextField.text = emergencyContact.name
                    self.contactPhoneTextField.text = emergencyContact.phone
                    if let relationship = emergencyContact.relationship {
                        self.relationshipButton.setTitle(relationship, for: .normal)
                        self.relationshipButton.menu = self.createRelationshipMenu(selected: relationship)
                    }
                }
            }
            .store(in: &subscriptions)

        viewModel.$fieldErrors
            .receive(on: RunLoop.main)
            .sink { [weak self] errors in
                guard let self = self else { return }
                self.nameSection.setError(errors["name"])
                self.weightSection.setError(errors["weight"])
                self.heightSection.setError(errors["height"])
                self.dateOfBirthSection.setError(errors["age"])
                self.contactNameSection.setError(errors["contact_name"])
                self.contactPhoneSection.setError(errors["contact_phone"])
                self.contactRelationshipSection.setError(errors["contact_relationship"])
                self.scrollToFirstErrorIfNeeded(errors)
            }
            .store(in: &subscriptions)
    }

    private func bindInputs() {
        nameTextField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(addressChanged), for: .editingChanged)
        heightTextField.addTarget(self, action: #selector(heightChanged), for: .editingChanged)
        weightTextField.addTarget(self, action: #selector(weightChanged), for: .editingChanged)
        contactNameTextField.addTarget(self, action: #selector(contactNameChanged), for: .editingChanged)
        contactPhoneTextField.addTarget(self, action: #selector(contactPhoneChanged), for: .editingChanged)
        genderSegmentedControl.addTarget(self, action: #selector(genderChanged), for: .valueChanged)
    }

    @objc private func nameChanged() {
        viewModel.updateName(nameTextField.text ?? "")
        nameSection.setError(nil)
    }

    @objc private func addressChanged() {
        viewModel.updateAddress(addressTextField.text ?? "")
    }

    @objc private func heightChanged() {
        viewModel.updateHeight(from: heightTextField.text ?? "")
        heightSection.setError(nil)
    }

    @objc private func weightChanged() {
        viewModel.updateWeight(from: weightTextField.text ?? "")
        weightSection.setError(nil)
    }

    @objc private func contactNameChanged() {
        viewModel.updateContactName(contactNameTextField.text ?? "")
        contactNameSection.setError(nil)
    }

    @objc private func contactPhoneChanged() {
        viewModel.updateContactPhone(contactPhoneTextField.text ?? "")
        contactPhoneSection.setError(nil)
    }

    @objc private func genderChanged() {
        let selectedGender = (genderSegmentedControl.selectedSegmentIndex == 0) ? "F" : "M"
        viewModel.updateGender(selectedGender)
    }

    @objc private func updateAgeLabel() {
        let calculatedAge = Calendar.current.dateComponents([.year], from: dateOfBirthPicker.date, to: Date()).year ?? 0
        ageLabel.updateLabelText("\(calculatedAge) anos")
        viewModel.updateDateOfBirth(dateOfBirthPicker.date)
        dateOfBirthSection.setError(nil)
    }

    @objc private func dismissKeyboard() {
        endEditing(true)
    }

    private func createRelationshipMenu(selected: String) -> UIMenu {
        let actions: [UIAction] = relationshipOptions.map { option in
            let isSelected = (option == selected)
            return UIAction(title: option, state: isSelected ? .on : .off) { [weak self] action in
                guard let self = self else { return }
                self.relationshipButton.setTitle(action.title, for: .normal)
                self.relationshipButton.menu = self.createRelationshipMenu(selected: action.title)
                self.viewModel.updateContactRelationship(action.title)
                self.contactRelationshipSection.setError(nil)
            }
        }
        return UIMenu(options: .singleSelection, children: actions)
    }

    func loadExistingInformation() {
        viewModel.loadInitialPersonalDataFormState()
    }

    private func scrollToFirstErrorIfNeeded(_ errors: [String: String]) {
        guard !errors.isEmpty else { return }
        let orderedSections: [(key: String, section: UIView)] = [
            ("name", nameSection),
            ("age", dateOfBirthSection),
            ("height", heightSection),
            ("weight", weightSection),
            ("contact_name", contactNameSection),
            ("contact_phone", contactPhoneSection),
            ("contact_relationship", contactRelationshipSection)
        ]

        if let firstErrorSection = orderedSections.first(where: { errors[$0.key] != nil })?.section {
            let visibleRect = firstErrorSection.convert(firstErrorSection.bounds, to: scrollView)
            scrollView.scrollRectToVisible(visibleRect.insetBy(dx: 0, dy: -24), animated: true)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
