//
//  PatientFormsViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

class PatientFormsViewController: UIViewController {
    
    weak var delegate: AssociatePatientViewControllerDelegate?
    private let viewModel: AddPatientViewModel
    
    private var contactsList: [ContactDraft] = []
    
    private let genderSegmentedControl: StandardSegmentedControl = {
        let items = ["F", "M"]
        let control = StandardSegmentedControl(items: items)
        control.backgroundColor = .white70
        control.selectedSegmentTintColor = .teal20
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private lazy var nameTextField: StandardTextfield = {
        let tf = StandardTextfield()
        tf.placeholder = "Nome Completo"
        tf.backgroundColor = .white70
        tf.textColor = .black10
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    private lazy var heightTextField: StandardTextfield = {
        let tf = StandardTextfield()
        tf.placeholder = ""
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
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var weightTextField: StandardTextfield = {
        let tf = StandardTextfield()
        tf.placeholder = ""
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
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var addressTextField: StandardTextfield = {
        let tf = StandardTextfield()
        tf.placeholder = "Endereço"
        tf.backgroundColor = .white70
        tf.textColor = .black10
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    private lazy var contactTextField: StandardTextfield = {
        let tf = StandardTextfield()
        tf.placeholder = "Número ou email"
        tf.backgroundColor = .white70
        tf.textColor = .black10
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        picker.preferredDatePickerStyle = .compact
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var heightSection = FormSectionView(title: "Altura", content: heightInputStack)
    private lazy var weightSection = FormSectionView(title: "Peso", content: weightInputStack)
    private lazy var addressSection = FormSectionView(title: "Endereço", content: addressTextField)
    private lazy var contactSection = FormSectionView(title: "Contatos", content: contactTextField)
    private lazy var genderSection = FormSectionView(title: "Sexo", content: genderSegmentedControl)
    private lazy var nameSection = FormSectionView(title: "Nome", content: nameTextField)
    private lazy var birthDateSection = FormSectionView(title: "Data de Nascimento", content: datePicker)
    
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
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var formStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameSection,
            birthAndAgeStack,
            physicalInfoStack,
            addressSection,
            contactSection,
            addContactButton,
            nextStepButton
        ])
        stack.axis = .vertical
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    
    private let nextStepButton = StandardConfirmationButton(title: "Próximo")
    private let addContactButton = WideRectangleButton(title: "+")
        
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
    }
    
    private func setupUI() {
        view.backgroundColor = .pureWhite
//        navigationItem.title = "Perfil do Assistido"
        
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
    func didTapNextStepButton(_ sender: UISegmentedControl) {
        guard let name = nameTextField.text, !name.isEmpty,
              let heightText = heightTextField.text, let height = Double(heightText),
              let weightText = weightTextField.text, let weight = Double(weightText),
              let address = addressTextField.text
        else {
            showAlert(message: "Preencha todos os campos corretamente.")
            return
        }

        let selectedIndex = genderSegmentedControl.selectedSegmentIndex
        let gender = selectedIndex == 0 ? "female" : "male"

        let dateOfBirth = datePicker.date

        viewModel.updatePersonalData(
            name: name,
            gender: gender,
            dateOfBirth: dateOfBirth,
            height: height,
            weight: weight,
            address: address
        )

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
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Informação Incompleta", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
