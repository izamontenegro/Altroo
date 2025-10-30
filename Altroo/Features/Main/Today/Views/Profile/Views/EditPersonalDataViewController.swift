//
//  EditPersonalDataViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 28/10/25.
//

import UIKit

final class EditPersonalDataViewController: GradientNavBarViewController {
    let viewModel: EditMedicalRecordViewModel
    
    weak var delegate: EditMedicalRecordViewControllerDelegate?
    
    private let genderSegmentedControl: StandardSegmentedControl = {
        let items = ["F", "M"]
        let control = StandardSegmentedControl(items: items)
        return control
    }()
    
    private lazy var nameTextField = StandardTextfield(placeholder: "Nome do assistido")
    
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
    
    private lazy var nameSection = FormSectionView(title: "Nome", content: nameTextField, isObligatory: true)
    private lazy var birthDateSection = FormSectionView(title: "Data de Nascimento", content: datePicker)
    private lazy var ageSection = FormSectionView(title: "Idade", content: ageLabel)
    private lazy var heightSection = FormSectionView(title: "Altura", content: heightInputStack)
    private lazy var weightSection = FormSectionView(title: "Peso", content: weightInputStack)
    private lazy var genderSection = FormSectionView(title: "Sexo", content: genderSegmentedControl)
    private lazy var addressSection = FormSectionView(title: "Endereço", content: addressTextField)
    
    //FIXME: Turn back into plural
    private lazy var contactSection = FormSectionView(title: "Contato", content: contactTextField)
    
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
            contactSection,
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillInformations()
        
        
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .pureWhite
        
        setupUI()
    }
    
    func setupUI() {
        let header = EditSectionHeaderView(sectionTitle: "Dados Pessoais", sectionDescription: "Preencha os campos a seguir quanto aos dados básicos da pessoa cuidada.", sectionIcon: "person.fill")
        header.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(header)
        view.addSubview(formStack)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            formStack.topAnchor.constraint(equalTo: header.safeAreaLayoutGuide.bottomAnchor, constant: 60)

        ])
        
    }
    
    private func fillInformations() {
        guard let patient = viewModel.userService.fetchCurrentPatient(),
              let personalData = patient.personalData else { return }
        
        nameTextField.text = personalData.name ?? ""
        heightTextField.text = personalData.height != nil ? "\(personalData.height)" : ""
        weightTextField.text = personalData.weight != nil ? "\(personalData.weight)" : ""
        addressTextField.text = personalData.address ?? ""
        contactTextField.text = MedicalRecordFormatter.contactsList(from: personalData.contacts as? Set<Contact>)
        
        if let dateOfBirth = personalData.dateOfBirth {
            datePicker.date = dateOfBirth
            ageLabel.text = viewModel.calculateAge(from: dateOfBirth)
        } else {
            ageLabel.text = ""
        }
        
//        if let gender = personalData.gender {
//            if gender.lowercased() == "f" {
//                genderSegmentedControl.selectedSegmentIndex = 0
//            } else if gender.lowercased() == "m" {
//                genderSegmentedControl.selectedSegmentIndex = 1
//            } else {
//                genderSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
//            }
//        } else {
//            genderSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
//        }
    }
}
