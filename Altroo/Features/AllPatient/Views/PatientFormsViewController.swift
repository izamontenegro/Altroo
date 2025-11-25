//
//  PatientFormsViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit
import Combine

class PatientFormsViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private var keyboardHandler: KeyboardHandler?

    weak var delegate: AssociatePatientViewControllerDelegate?
    private let viewModel: AddPatientViewModel
    private var contactsList: [ContactDraft] = []
    
    private let titleSection = FormTitleSection(
        title: "patient_profile_title".localized,
        description: "patient_profile_description".localized,
        totalSteps: 3,
        currentStep: 1
    )
    
    private let genderSegmentedControl: StandardSegmentedControl = {
        let items = ["F", "M"]
        let control = StandardSegmentedControl(items: items)
        return control
    }()
    
    private lazy var nameTextField = StandardTextfield(placeholder: "patient_name_placeholder".localized)

    private lazy var heightTextField: StandardTextfield = {
        let tf = StandardTextfield()
        tf.placeholder = "0"
        tf.keyboardType = .numberPad
        return tf
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
        let tf = StandardTextfield()
        tf.placeholder = "0"
        tf.keyboardType = .numberPad
        return tf
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
    
    private lazy var addressTextField = StandardTextfield(placeholder: "address_placeholder".localized)
    private lazy var contactNameTextField = StandardTextfield(placeholder: "contact_name_placeholder".localized)
    private lazy var contactPhoneTextField: StandardTextfield = {
        let tf = StandardTextfield()
        tf.placeholder = "contact_phone_placeholder".localized
        tf.keyboardType = .numberPad
        return tf
    }()
    private lazy var relationshipButton: PopupMenuButton = {
        let button = PopupMenuButton(title: viewModel.selectedContactRelationship)
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.backgroundColor = .blue40
        
        let actions: [UIAction] = RelationshipOptionsEnum.allCases.map { option in
            let isSelected = (option.displayText == viewModel.selectedContactRelationship)
            return UIAction(title: option.displayText, state: isSelected ? .on : .off) { [weak self] action in
                guard let self else { return }
                self.viewModel.selectedContactRelationship = action.title
                
                self.relationshipButton.setTitle(action.title, for: .normal)
            }
        }
        
        button.menu = UIMenu(options: .singleSelection, children: actions)
        
        return button
    }()
    
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
    
    
    private lazy var nameSection = FormSectionView(title: "name".localized, content: nameTextField, isObligatory: true)
    private lazy var birthDateSection = FormSectionView(title: "birth_date".localized, content: datePicker)
    private lazy var ageSection = FormSectionView(title: "age".localized, content: ageLabel)
    private lazy var heightSection = FormSectionView(title: "height".localized, content: heightInputStack)
    private lazy var weightSection = FormSectionView(title: "weight".localized, content: weightInputStack)
    private lazy var genderSection = FormSectionView(title: "gender".localized, content: genderSegmentedControl)
    private lazy var addressSection = FormSectionView(title: "address".localized, content: addressTextField)

    private lazy var contactSection = FormSectionView(title: "emergency_contact".localized, content: contactStack)
    private lazy var contactNameSection = FormSectionView(title: "name".localized, content: contactNameTextField, isSubsection: true)
    private lazy var contactPhoneSection = FormSectionView(title: "contact_phone".localized, content: contactPhoneTextField, isSubsection: true)
    private lazy var contactRelationshipSection = FormSectionView(title: "relationship".localized, content: relationshipButton, isSubsection: true)

    private lazy var ageLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "age_default".localized,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black10,
            labelWeight: .regular
        )
        return label
    }()
    
    private lazy var birthAndAgeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [birthDateSection, ageSection])
        stack.axis = .horizontal
        stack.spacing = Layout.mediumSpacing
        stack.alignment = .top
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var physicalInfoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [weightSection, heightSection, genderSection])
        stack.axis = .horizontal
        stack.spacing = Layout.smallSpacing
        stack.alignment = .top
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var contactStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [contactNameSection, phoneAndRelationshipStack])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = Layout.verySmallSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var phoneAndRelationshipStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [contactPhoneSection, contactRelationshipSection])
        stack.axis = .horizontal
        stack.spacing = Layout.smallSpacing
        stack.alignment = .top
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var formStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleSection,
            nameSection,
            birthAndAgeStack,
            physicalInfoStack,
            addressSection,
            contactSection,
            nextStepButton
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let scrollView = UIScrollView.make(direction: .vertical)
    private let nextStepButton = StandardConfirmationButton(title: "next".localized)
        
    init(viewModel: AddPatientViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        keyboardHandler = KeyboardHandler(viewController: self)
    }
    
    private func bindViewModel() {
      viewModel.$fieldErrors
          .receive(on: RunLoop.main)
          .sink { [weak self] errors in
              self?.nameSection.setError(errors["name"])
              self?.weightSection.setError(errors["weight"])
              self?.heightSection.setError(errors["height"])
              self?.birthDateSection.setError(errors["age"])
          }
          .store(in: &cancellables)
      }
    
    private func setupUI() {
        view.backgroundColor = .pureWhite

        view.addSubview(scrollView)
        scrollView.addSubview(formStack)
        
        let allTextFields: [UITextField] = [
            nameTextField,
            heightTextField,
            weightTextField,
            addressTextField,
            contactNameTextField,
            contactPhoneTextField
        ]
        allTextFields.forEach { tf in
            tf.delegate = self
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            formStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: Layout.smallSpacing),
            formStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Layout.mediumSpacing),
            formStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Layout.mediumSpacing),
            formStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Layout.smallSpacing),
            formStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -2 * Layout.mediumSpacing)
        ])
        
        datePicker.addTarget(self, action: #selector(updateAgeLabel), for: .valueChanged)
        nextStepButton.addTarget(self, action: #selector(didTapNextStepButton), for: .touchUpInside)
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func configureNavBar() {
        let closeButton = UIBarButtonItem(title: "close".localized, style: .done, target: self, action: #selector(didTapClose))
        closeButton.tintColor = .blue30
        navigationItem.leftBarButtonItem = closeButton

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    func didTapNextStepButton(_ sender: UIButton) {
        let selectedIndex = genderSegmentedControl.selectedSegmentIndex
        let gender = selectedIndex == 0 ? "female" : "male"
        
        let heightText = heightTextField.text ?? ""
        let height = Double(heightText) ?? 0
        let weightText = weightTextField.text ?? ""
        let weight = Double(weightText) ?? 0
        
        let dateOfBirth = datePicker.date
        
        viewModel.updatePersonalData(
            name: nameTextField.text ?? "",
            gender: gender,
            dateOfBirth: dateOfBirth,
            height: height,
            weight: weight,
            address: addressTextField.text ?? ""
        )
        
        let contactName = contactNameTextField.text ?? ""
        let contactPhone = contactPhoneTextField.text ?? ""

        viewModel.updateContact(name: contactName, phone: contactPhone)
        
        guard viewModel.validateProfile() else { return }
        
        delegate?.goToComorbiditiesForms()
    }

    @objc
    private func updateAgeLabel() {
        let age = Calendar.current.dateComponents([.year], from: datePicker.date, to: Date()).year ?? 0
        ageLabel.updateLabelText(String(format: "age_format".localized, age))
    }
}

extension PatientFormsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//class BasicNeedsFacadeMock: BasicNeedsFacadeProtocol {}
//class RoutineActivitiesFacadeMock: RoutineActivitiesFacadeProtocol {}
//class CoreDataServiceMock: CoreDataService {}
//
//#Preview {
//    let mockService = UserServiceSession(context: AppDependencies().coreDataService.stack.context)
//
//    PatientFormsViewController(viewModel: AddPatientViewModel(careRecipientFacade: CareRecipientFacade(basicNeedsFacade: BasicNeedsFacadeMock(), routineActivitiesFacade: RoutineActivitiesFacadeMock(), persistenceService: CoreDataServiceMock()), userService: mockService))
//}
