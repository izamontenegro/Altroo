//
//  PatientFormsViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit
import Combine

class PatientFormsViewController: GradientNavBarViewController {
    private var cancellables = Set<AnyCancellable>()

    weak var delegate: AssociatePatientViewControllerDelegate?
    private let viewModel: AddPatientViewModel
    private var contactsList: [ContactDraft] = []
    
    private let titleSection = FormTitleSection(title: "Perfil do Assistido", description: "Preencha os campos a seguir quanto aos dados básicos da pessoa cuidada.", totalSteps: 3, currentStep: 1)
    
    private let genderSegmentedControl: StandardSegmentedControl = {
        let items = ["F", "M"]
        let control = StandardSegmentedControl(items: items)
        return control
    }()
    
    private lazy var nameTextField: StandardTextfield = {
        let tf = StandardTextfield()
        tf.placeholder = "Nome do assistido"
        tf.backgroundColor = .white70
        tf.textColor = .black10
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var heightTextField: StandardTextfield = {
        let tf = StandardTextfield()
        tf.placeholder = "0"
        tf.backgroundColor = .white70
        tf.textColor = .black10
        tf.keyboardType = .numberPad
        tf.translatesAutoresizingMaskIntoConstraints = false
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
        tf.backgroundColor = .white70
        tf.textColor = .black10
        tf.keyboardType = .numberPad
        tf.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    private lazy var addressTextField = StandardTextfield(placeholder: "Endereço do Assistido")
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
    
    private lazy var nameSection = FormSectionView(title: "Nome", content: nameTextField, isObligatory: true)
    private lazy var birthDateSection = FormSectionView(title: "Data de Nascimento", content: datePicker, isObligatory: true)
    private lazy var ageSection = FormSectionView(title: "Idade", content: ageLabel)
    private lazy var heightSection = FormSectionView(title: "Altura", content: heightInputStack)
    private lazy var weightSection = FormSectionView(title: "Peso", content: weightInputStack)
    private lazy var genderSection = FormSectionView(title: "Sexo", content: genderSegmentedControl)
    private lazy var addressSection = FormSectionView(title: "Endereço", content: addressTextField)
    private lazy var contactSection = FormSectionView(title: "Contatos", content: contactTextField)
    
    private lazy var ageLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "0 anos",
            labelFont: .sfPro,
            labelType: .largeTitle,
            labelColor: .blue0,
            labelWeight: .regular
        )
        return label
    }()
    
    private lazy var birthAndAgeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [birthDateSection, ageLabel])
        stack.axis = .horizontal
        stack.spacing = 40
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var physicalInfoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [weightSection, heightSection, genderSection])
        stack.axis = .horizontal
        stack.spacing = Layout.largeSpacing
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
            addContactButton,
            nextButtonContainer
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    
    private let nextStepButton = StandardConfirmationButton(title: "Próximo")
    private lazy var nextButtonContainer: UIView = {
        let view = UIView()
        view.addSubview(nextStepButton)
        nextStepButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextStepButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextStepButton.topAnchor.constraint(equalTo: view.topAnchor),
            nextStepButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return view
    }()
    
    private let addContactButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor(resource: .blue40).cgColor
        button.layer.borderWidth = 2
        button.setCustomTitleLabel(StandardLabel(labelText: "+", labelFont: .sfPro, labelType: .title1, labelColor: .blue40, labelWeight: .medium))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 38).isActive = true
        return button
    }()
        
    init(viewModel: AddPatientViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupUI()
        bindViewModel()
    }
    
    private func bindViewModel() {
          viewModel.$fieldErrors
              .receive(on: RunLoop.main)
              .sink { [weak self] errors in
                  self?.nameSection.setError(errors["name"])
                  self?.weightSection.setError(errors["weight"])
                  self?.heightSection.setError(errors["height"])
              }
              .store(in: &cancellables)
      }
    
    private func setupUI() {
        view.backgroundColor = .pureWhite
        view.addSubview(formStack)
        
        NSLayoutConstraint.activate([
            formStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            formStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            formStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
        
        datePicker.addTarget(self, action: #selector(updateAgeLabel), for: .valueChanged)
        addContactButton.addTarget(self, action: #selector(didTapAddContactButton), for: .touchUpInside)
        nextStepButton.addTarget(self, action: #selector(didTapNextStepButton), for: .touchUpInside)
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    
    }
    
    private func setupNavBar() {
        setNavbarTitle("Adicionar Paciente")
    }

    @objc
    private func didTapAddContactButton() {
        guard let text = contactTextField.text, !text.isEmpty else { return }

        let contact = ContactDraft(name: text, description: "", method: "")
        contactsList.append(contact)

        contactTextField.text = ""
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
        
        //FIXME: DESCOMENTAR
//        guard viewModel.validateProfile() else { return }
        
        for c in contactsList {
            viewModel.addContact(name: c.name, contactDescription: c.description, contactMethod: c.method)
        }
        
        delegate?.goToComorbiditiesForms()
    }


    @objc
    private func updateAgeLabel() {
        let age = Calendar.current.dateComponents([.year], from: datePicker.date, to: Date()).year ?? 0
        ageLabel.updateLabelText("\(age) anos")
    }
    
    
    private static func makeTextField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }
}

extension PatientFormsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }

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
