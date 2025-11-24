//
//  EditPersonalDataViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 28/10/25.
//
import UIKit

final class EditPersonalDataViewController: UIViewController, UITextFieldDelegate {
    
    let viewModel: EditPersonalDataViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?
    
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
    
    private let genderSegmentedControl = StandardSegmentedControl(items: ["F", "M"])
    private let nameTextField = StandardTextfield(placeholder: "patient_name_placeholder".localized)
    private let addressTextField = StandardTextfield(placeholder: "address_placeholder".localized)
    
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
        textField.placeholder = "contact_phone_placeholder".localized
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var relationshipButton: PopupMenuButton = {
        let button = PopupMenuButton(title: RelationshipOptionsEnum.caregiver.displayText)
        button.showsMenuAsPrimaryAction = true
        button.backgroundColor = .blue40
        button.menu = createRelationshipMenu(selected: RelationshipOptionsEnum.caregiver.displayText)
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
        sectionDescription: "patient_profile_description".localized,
        sectionIcon: "person.fill"
    )
    
    private lazy var nameSection = FormSectionView(
        title: "name".localized,
        content: nameTextField,
        isObligatory: true
    )
    private lazy var dateOfBirthSection = FormSectionView(
        title: "birth_date".localized,
        content: dateOfBirthPicker
    )
    private lazy var ageSection = FormSectionView(
        title: "age".localized,
        content: ageLabel
    )
    private lazy var heightSection = FormSectionView(
        title: "height".localized,
        content: heightStackView
    )
    private lazy var weightSection = FormSectionView(
        title: "weight".localized,
        content: weightStackView
    )
    private lazy var genderSection = FormSectionView(
        title: "gender".localized,
        content: genderSegmentedControl
    )
    private lazy var addressSection = FormSectionView(
        title: "address".localized,
        content: addressTextField
    )
    
    private lazy var contactNameSection = FormSectionView(
        title: "name".localized,
        content: contactNameTextField,
        isSubsection: true
    )
    private lazy var contactPhoneSection = FormSectionView(
        title: "contact_phone".localized,
        content: contactPhoneTextField,
        isSubsection: true
    )
    private lazy var contactRelationshipSection = FormSectionView(
        title: "relationship".localized,
        content: relationshipButton,
        isSubsection: true
    )
    private lazy var contactSection = FormSectionView(
        title: "emergency_contact".localized,
        content: contactStackView
    )
    
    private lazy var heightStackView: UIStackView = {
        let centimetersLabel = StandardLabel(
            labelText: "cm",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .regular
        )
        let stackView = UIStackView(arrangedSubviews: [heightTextField, centimetersLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var weightStackView: UIStackView = {
        let kilogramsLabel = StandardLabel(
            labelText: "kg",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .regular
        )
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
        let phoneAndRelationshipStackView = UIStackView(
            arrangedSubviews: [contactPhoneSection, contactRelationshipSection]
        )
        phoneAndRelationshipStackView.axis = .horizontal
        phoneAndRelationshipStackView.spacing = Layout.smallSpacing
        phoneAndRelationshipStackView.distribution = .fill
        phoneAndRelationshipStackView.alignment = .top
        
        let verticalStackView = UIStackView(
            arrangedSubviews: [contactNameSection, phoneAndRelationshipStackView]
        )
        verticalStackView.axis = .vertical
        verticalStackView.spacing = Layout.verySmallSpacing
        return verticalStackView
    }()
    
    // MARK: - Init
    
    init(viewModel: EditPersonalDataViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserInterface()
        bindInputs()
        configureNavBar()
        loadExistingInformation()
    }
    
    // MARK: - UI
    
    private func configureUserInterface() {
        view.backgroundColor = .pureWhite
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 22
        contentStackView.alignment = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            headerSection,
            nameSection,
            dateOfBirthAndAgeStackView,
            physicalInformationStackView,
            addressSection,
            contactSection
        ].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor,
                constant: Layout.smallSpacing
            ),
            contentStackView.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor,
                constant: Layout.mediumSpacing
            ),
            contentStackView.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor,
                constant: -Layout.mediumSpacing
            ),
            contentStackView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor,
                constant: -Layout.smallSpacing
            ),
            contentStackView.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor,
                constant: -2 * Layout.mediumSpacing
            )
        ])
        
        dateOfBirthPicker.addTarget(self, action: #selector(updateAgeLabel), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
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
    
    // MARK: - Carregar estado inicial
    
    private func loadExistingInformation() {
        viewModel.loadInitialPersonalData()
        applyFormStateToUI()
    }
    
    private func applyFormStateToUI() {
        let formState = viewModel.personalDataFormState
        
        // Nome / endereço
        nameTextField.text = formState.name
        addressTextField.text = formState.address
        
        // Peso / altura
        if let weight = formState.weight {
            weightTextField.text = numberFormatter.string(from: NSNumber(value: weight))
        } else {
            weightTextField.text = ""
        }
        
        if let height = formState.height {
            heightTextField.text = numberFormatter.string(from: NSNumber(value: height))
        } else {
            heightTextField.text = ""
        }
        
        // Gênero
        if formState.gender == "F" {
            genderSegmentedControl.selectedSegmentIndex = 0
        } else if formState.gender == "M" {
            genderSegmentedControl.selectedSegmentIndex = 1
        } else {
            genderSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
        }
        
        // Data de nascimento + idade
        if let dob = formState.dateOfBirth {
            dateOfBirthPicker.setDate(dob, animated: false)
            ageLabel.updateLabelText(formState.ageText)
        } else {
            ageLabel.updateLabelText("—")
        }
        
        // Contato de emergência
        if let contact = formState.emergencyContact {
            contactNameTextField.text = contact.name
            contactPhoneTextField.text = contact.phone
            if let relationship = contact.relationship {
                relationshipButton.setTitle(relationship, for: .normal)
                relationshipButton.menu = createRelationshipMenu(selected: relationship)
            }
        }
    }
    
    // MARK: - Bind inputs
    
    private func bindInputs() {
        nameTextField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(addressChanged), for: .editingChanged)
        heightTextField.addTarget(self, action: #selector(heightChanged), for: .editingChanged)
        weightTextField.addTarget(self, action: #selector(weightChanged), for: .editingChanged)
        contactNameTextField.addTarget(self, action: #selector(contactNameChanged), for: .editingChanged)
        contactPhoneTextField.addTarget(self, action: #selector(contactPhoneChanged), for: .editingChanged)
        genderSegmentedControl.addTarget(self, action: #selector(genderChanged), for: .valueChanged)
    }
    
    // MARK: - Actions (inputs)
    
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
        let calculatedAge = Calendar.current.dateComponents(
            [.year],
            from: dateOfBirthPicker.date,
            to: Date()
        ).year ?? 0
        
        ageLabel.updateLabelText("\(calculatedAge) anos")
        viewModel.updateDateOfBirth(dateOfBirthPicker.date)
        dateOfBirthSection.setError(nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Relationship menu
    
    private func createRelationshipMenu(selected: String) -> UIMenu {
        let actions: [UIAction] = RelationshipOptionsEnum.allCases.map { option in
            let isSelected = (option.displayText == selected)
            return UIAction(title: option.displayText, state: isSelected ? .on : .off) { [weak self] action in
                guard let self = self else { return }
                self.relationshipButton.setTitle(action.title, for: .normal)
                self.relationshipButton.menu = self.createRelationshipMenu(selected: action.title)
                self.viewModel.updateContactRelationship(action.title)
                self.contactRelationshipSection.setError(nil)
            }
        }
        return UIMenu(options: .singleSelection, children: actions)
    }
    
    // MARK: - Validação / Erros
    
    private func applyFieldErrors() {
        let errors = viewModel.fieldErrors
        
        nameSection.setError(errors["name"])
        weightSection.setError(errors["weight"])
        heightSection.setError(errors["height"])
        dateOfBirthSection.setError(errors["age"])
        contactNameSection.setError(errors["contact_name"])
        contactPhoneSection.setError(errors["contact_phone"])
        contactRelationshipSection.setError(errors["contact_relationship"])
        
        scrollToFirstErrorIfNeeded(errors)
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
    
    // MARK: - Public helpers
    
    /// Valida, aplica erros na UI e, se tudo ok, persiste.
    @discardableResult
    func validateAndPersist() -> Bool {
        let isValid = viewModel.validatePersonalData()
        applyFieldErrors()
        if isValid {
            viewModel.persistPersonalData()
        }
        return isValid
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
