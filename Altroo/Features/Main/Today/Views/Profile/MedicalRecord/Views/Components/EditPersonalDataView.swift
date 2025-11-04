//
//  EditPersonalDataViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 28/10/25.
//
import UIKit
import Combine

final class EditPersonalDataView: UIView, UITextFieldDelegate {
    let viewModel: EditMedicalRecordViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?
    
    private var subscriptions = Set<AnyCancellable>()

    private let genderSegmentedControl: StandardSegmentedControl = {
        let items = ["F", "M"]
        let control = StandardSegmentedControl(items: items)
        return control
    }()

    private lazy var nameTextField = StandardTextfield(placeholder: "Nome do assistido")

    private lazy var heightTextField: StandardTextfield = {
        let textField = StandardTextfield()
        textField.placeholder = "0"
        textField.backgroundColor = .white70
        textField.textColor = .black10
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var heightInputStack: UIStackView = {
        let label = StandardLabel(
            labelText: "cm",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .regular
        )
        let stack = UIStackView(arrangedSubviews: [heightTextField, label])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        heightTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return stack
    }()

    private lazy var weightTextField: StandardTextfield = {
        let textField = StandardTextfield()
        textField.placeholder = "0"
        textField.backgroundColor = .white70
        textField.textColor = .black10
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var weightInputStack: UIStackView = {
        let label = StandardLabel(
            labelText: "kg",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .regular
        )
        let stack = UIStackView(arrangedSubviews: [weightTextField, label])
        stack.axis = .horizontal
        stack.spacing = 8
        weightTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return stack
    }()

    private lazy var addressTextField = StandardTextfield(placeholder: "Endereço do assistido")
    private lazy var contactTextField = StandardTextfield(placeholder: "(00) 0 0000-0000")

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        picker.preferredDatePickerStyle = .compact
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.setContentHuggingPriority(.required, for: .horizontal)
        picker.setContentCompressionResistancePriority(.required, for: .horizontal)
        picker.contentHorizontalAlignment = .leading
        return picker
    }()

    private lazy var ageLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "0 anos",
            labelFont: .sfPro,
            labelType: .largeTitle,
            labelColor: .blue10,
            labelWeight: .regular
        )
        return label
    }()

    private lazy var nameSection = FormSectionView(title: "Nome", content: nameTextField, isObligatory: true)
    private lazy var birthDateSection = FormSectionView(title: "Data de Nascimento", content: datePicker)
    private lazy var ageSection = FormSectionView(title: "Idade", content: ageLabel)
    private lazy var heightSection = FormSectionView(title: "Altura", content: heightInputStack)
    private lazy var weightSection = FormSectionView(title: "Peso", content: weightInputStack)
    private lazy var genderSection = FormSectionView(title: "Sexo", content: genderSegmentedControl)
    private lazy var addressSection = FormSectionView(title: "Endereço", content: addressTextField)
    private lazy var contactSection = FormSectionView(title: "Contato", content: contactTextField)

    private lazy var birthAndAgeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [birthDateSection, ageLabel])
        stack.axis = .horizontal
        stack.spacing = Layout.mediumSpacing
        stack.alignment = .bottom
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var physicalInfoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [weightSection, heightSection, genderSection])
        stack.axis = .horizontal
        stack.spacing = Layout.largeSpacing
        stack.alignment = .top
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var formStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameSection,
            birthAndAgeStack,
            physicalInfoStack,
            addressSection,
            contactSection
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let header: EditSectionHeaderView = {
        let header = EditSectionHeaderView(
            sectionTitle: "Dados Pessoais",
            sectionDescription: "Preencha os campos a seguir quanto aos dados básicos da pessoa cuidada.",
            sectionIcon: "person.fill"
        )
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
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
        bindViewModel()
        bindInputs()
        fillInformations()
        installKeyboardDismiss()
        setTextFieldDelegates()
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

        datePicker.addTarget(self, action: #selector(handleDateChanged), for: .valueChanged)
    }

    private func bindViewModel() {
        viewModel.$personalDataFormState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                if self.nameTextField.text != state.name { self.nameTextField.text = state.name }
                if self.addressTextField.text != state.address { self.addressTextField.text = state.address }
                if let height = state.height {
                    let text = height.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(height)) : String(height)
                    if self.heightTextField.text != text { self.heightTextField.text = text }
                } else if self.heightTextField.text?.isEmpty == false {
                    self.heightTextField.text = ""
                }
                if let weight = state.weight {
                    let text = weight.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(weight)) : String(weight)
                    if self.weightTextField.text != text { self.weightTextField.text = text }
                } else if self.weightTextField.text?.isEmpty == false {
                    self.weightTextField.text = ""
                }
                if let date = state.dateOfBirth, self.datePicker.date != date {
                    self.datePicker.date = date
                }
                let index = state.gender == "M" ? 1 : (state.gender == "F" ? 0 : UISegmentedControl.noSegment)
                if self.genderSegmentedControl.selectedSegmentIndex != index {
                    self.genderSegmentedControl.selectedSegmentIndex = index
                }
                self.ageLabel.text = state.ageText
            }
            .store(in: &subscriptions)
        
        viewModel.$fieldErrors
            .receive(on: RunLoop.main)
            .sink { [weak self] errors in
                self?.nameSection.setError(errors["name"])
                self?.weightSection.setError(errors["weight"])
                self?.heightSection.setError(errors["height"])
                self?.birthDateSection.setError(errors["age"])
            }
            .store(in: &subscriptions)
    }

    private func bindInputs() {
        nameTextField.addTarget(self, action: #selector(handleNameChanged), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(handleAddressChanged), for: .editingChanged)
        heightTextField.addTarget(self, action: #selector(handleHeightChanged), for: .editingChanged)
        weightTextField.addTarget(self, action: #selector(handleWeightChanged), for: .editingChanged)
        genderSegmentedControl.addTarget(self, action: #selector(handleGenderChanged), for: .valueChanged)
    }

    private func installKeyboardDismiss() {
        addGestureRecognizer(keyboardDismissTapGesture)
    }

    private func setTextFieldDelegates() {
        [nameTextField, heightTextField, weightTextField, addressTextField, contactTextField].forEach { $0.delegate = self }
    }

    @objc private func handleDateChanged() {
        viewModel.updateDateOfBirth(datePicker.date)
        ageLabel.text = viewModel.personalDataFormState.ageText
    }

    @objc private func handleNameChanged() {
        viewModel.updateName(nameTextField.text ?? "")
    }

    @objc private func handleAddressChanged() {
        viewModel.updateAddress(addressTextField.text ?? "")
    }

    @objc private func handleHeightChanged() {
        viewModel.updateHeight(from: heightTextField.text ?? "")
    }

    @objc private func handleWeightChanged() {
        viewModel.updateWeight(from: weightTextField.text ?? "")
    }

    @objc private func handleGenderChanged() {
        let index = genderSegmentedControl.selectedSegmentIndex
        let value = (index == 1) ? "M" : (index == 0) ? "F" : ""
        viewModel.updateGender(value)
    }

    @objc private func dismissKeyboard() {
        endEditing(true)
    }

    func fillInformations() {
        viewModel.loadInitialPersonalDataFormState()
        if let patient = viewModel.userService.fetchCurrentPatient(),
           let personalData = patient.personalData {
            contactTextField.text = MedicalRecordFormatter.contactsList(from: personalData.contacts as? Set<Contact>)
        }
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
