//
//  PatientFormsViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

class PatientFormsViewController: UIViewController {
    
    weak var delegate: AssociatePatientViewControllerDelegate?
    private let viewModel: PatientFormsViewModel
    
    private let nameTextField = PatientFormsViewController.makeTextField(placeholder: "Full name")
    private let genderTextField = PatientFormsViewController.makeTextField(placeholder: "Gender (e.g. Male / Female)")
    private let heightTextField = PatientFormsViewController.makeTextField(placeholder: "Height (cm)")
    private let weightTextField = PatientFormsViewController.makeTextField(placeholder: "Weight (kg)")
    
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
    
    private lazy var formStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameTextField,
            genderTextField,
            datePicker,
            heightTextField,
            weightTextField
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(viewModel: PatientFormsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(viewLabel)
        view.addSubview(formStack)
        view.addSubview(nextStepButton)
        
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
        
        nextStepButton.addTarget(self, action: #selector(didTapNextStepButton), for: .touchUpInside)
    }
    
    @objc
    func didTapNextStepButton() {
        guard let name = nameTextField.text, !name.isEmpty,
              let gender = genderTextField.text, !gender.isEmpty,
              let heightText = heightTextField.text, let height = Double(heightText),
              let weightText = weightTextField.text, let weight = Double(weightText)
        else {
            showAlert(message: "Please fill in all fields correctly.")
            return
        }
        
        let dateOfBirth = datePicker.date
        
        viewModel.createNewPatient(
            name: name,
            gender: gender.lowercased(),
            dateOfBirth: dateOfBirth,
            height: height,
            weight: weight
        )
        
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
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }
}
