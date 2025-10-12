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
    
    private let nameTextField = PatientFormsViewController.makeTextField(placeholder: "Full name")
    private let genderTextField = PatientFormsViewController.makeTextField(placeholder: "Gender (e.g. Male / Female)")
    private let heightTextField = PatientFormsViewController.makeTextField(placeholder: "Height (cm)")
    private let weightTextField = PatientFormsViewController.makeTextField(placeholder: "Weight (kg)")
    private let addressTextField = PatientFormsViewController.makeTextField(placeholder: "Address")
    private let contactTextField = PatientFormsViewController.makeTextField(placeholder: "Contact (phone)")
        
    private let contactsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        picker.preferredDatePickerStyle = .compact
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Insert the patient information here"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nextStepButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next Step", for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let contactsTextView: UITextView = {
        let tv = UITextView()
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.layer.cornerRadius = 8
        tv.font = .systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private lazy var formStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameTextField,
            genderTextField,
            datePicker,
            heightTextField,
            weightTextField,
            addressTextField,
            contactsStack
        ])
        
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let addContactButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ Add Contact", for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
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
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(viewLabel)
        view.addSubview(formStack)
        view.addSubview(nextStepButton)
        
        contactsStack.addArrangedSubview(contactTextField)
        contactsStack.addArrangedSubview(addContactButton)
        
        addContactButton.addTarget(self, action: #selector(didTapAddContactButton), for: .touchUpInside)
        nextStepButton.addTarget(self, action: #selector(didTapNextStepButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            viewLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            formStack.topAnchor.constraint(equalTo: viewLabel.bottomAnchor, constant: 24),
            formStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            formStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            nextStepButton.topAnchor.constraint(equalTo: formStack.bottomAnchor, constant: 32),
            nextStepButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextStepButton.widthAnchor.constraint(equalToConstant: 150),
            nextStepButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
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

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    func didTapNextStepButton() {
        guard let name = nameTextField.text, !name.isEmpty,
              let gender = genderTextField.text, !gender.isEmpty,
              let heightText = heightTextField.text, let height = Double(heightText),
              let weightText = weightTextField.text, let weight = Double(weightText),
              let address = addressTextField.text, !address.isEmpty,
              let contact = contactTextField.text, !contact.isEmpty
        else {
            showAlert(message: "Please fill in all fields correctly.")
            return
        }
        
        let dateOfBirth = datePicker.date
        
        viewModel.updatePersonalData(
            name: name,
            gender: gender.lowercased(),
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
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Missing Information", message: message, preferredStyle: .alert)
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
