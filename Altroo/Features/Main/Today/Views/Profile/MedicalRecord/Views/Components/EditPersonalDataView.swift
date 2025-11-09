//
//  EditPersonalDataViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 28/10/25.
//
//
//  EditPersonalDataView.swift
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

    // MARK: - Subviews
    private let scrollView = UIScrollView.make(direction: .vertical)
    private let contentStack = UIStackView()

    private let genderSegmentedControl = StandardSegmentedControl(items: ["F", "M"])
    private let nameTextField = StandardTextfield(placeholder: "Nome do assistido")
    private let addressTextField = StandardTextfield(placeholder: "Endereço do assistido")

    private let heightTextField: StandardTextfield = {
        let tf = StandardTextfield()
        tf.placeholder = "0"
        tf.keyboardType = .numberPad
        return tf
    }()

    private let weightTextField: StandardTextfield = {
        let tf = StandardTextfield()
        tf.placeholder = "0"
        tf.keyboardType = .numberPad
        return tf
    }()

    private let contactNameTextField = StandardTextfield(placeholder: "Nome do contato")
    private let contactPhoneTextField: StandardTextfield = {
        let tf = StandardTextfield()
        tf.placeholder = "Telefone com DDI"
        tf.keyboardType = .numberPad
        return tf
    }()

    private lazy var relationshipButton: PopupMenuButton = {
        let button = PopupMenuButton(title: relationshipOptions.first!)
        button.showsMenuAsPrimaryAction = true
        button.backgroundColor = .blue40
        button.menu = makeRelationshipMenu(selected: relationshipOptions.first!)
        return button
    }()

    private let datePicker: UIDatePicker = {
        let p = UIDatePicker()
        p.datePickerMode = .date
        p.maximumDate = Date()
        p.preferredDatePickerStyle = .compact
        return p
    }()

    private let ageLabel = StandardLabel(
        labelText: "0 anos",
        labelFont: .sfPro,
        labelType: .largeTitle,
        labelColor: .blue10,
        labelWeight: .regular
    )

    // MARK: - Sections
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

    // MARK: - Stacks
    private lazy var heightStack: UIStackView = {
        let label = StandardLabel(labelText: "cm", labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .regular)
        let stack = UIStackView(arrangedSubviews: [heightTextField, label])
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()

    private lazy var weightStack: UIStackView = {
        let label = StandardLabel(labelText: "kg", labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .regular)
        let stack = UIStackView(arrangedSubviews: [weightTextField, label])
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()

    private lazy var physicalInfoStack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [weightSection, heightSection, genderSection])
        s.axis = .horizontal
        s.spacing = Layout.smallSpacing
        s.distribution = .fillEqually
        return s
    }()

    private lazy var birthAndAgeStack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [birthSection, ageSection])
        s.axis = .horizontal
        s.spacing = Layout.mediumSpacing
        s.distribution = .fillEqually
        return s
    }()

    private lazy var contactStack: UIStackView = {
        let nameSec = FormSectionView(title: "Nome", content: contactNameTextField, isSubsection: true)
        let phoneSec = FormSectionView(title: "Telefone", content: contactPhoneTextField, isSubsection: true)
        let relSec = FormSectionView(title: "Relação", content: relationshipButton, isSubsection: true)
        let hStack = UIStackView(arrangedSubviews: [phoneSec, relSec])
        hStack.axis = .horizontal
        hStack.spacing = Layout.smallSpacing
        hStack.distribution = .fillEqually
        let vStack = UIStackView(arrangedSubviews: [nameSec, hStack])
        vStack.axis = .vertical
        vStack.spacing = Layout.verySmallSpacing
        return vStack
    }()

    // MARK: - Init
    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
        bindViewModel()
        bindInputs()
        fillInformations()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Setup

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

    // MARK: - Bindings
    private func bindViewModel() {
        viewModel.$personalDataFormState
            .receive(on: RunLoop.main)
            .sink { [weak self] s in
                guard let self else { return }
                if nameTextField.text != s.name { nameTextField.text = s.name }
                if addressTextField.text != s.address { addressTextField.text = s.address }
                if let c = s.emergencyContact {
                    contactNameTextField.text = c.name
                    contactPhoneTextField.text = c.phone
                    if let rel = c.relationship {
                        relationshipButton.setTitle(rel, for: .normal)
                        relationshipButton.menu = makeRelationshipMenu(selected: rel)
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
    }

    // MARK: - Handlers
    @objc private func nameChanged() { viewModel.updateName(nameTextField.text ?? "") }
    @objc private func addressChanged() { viewModel.updateAddress(addressTextField.text ?? "") }
    @objc private func contactNameChanged() { viewModel.updateContactName(contactNameTextField.text ?? "") }
    @objc private func contactPhoneChanged() { viewModel.updateContactPhone(contactPhoneTextField.text ?? "") }

    @objc private func updateAgeLabel() {
        let age = Calendar.current.dateComponents([.year], from: datePicker.date, to: Date()).year ?? 0
        ageLabel.updateLabelText("\(age) anos")
        viewModel.updateDateOfBirth(datePicker.date)
    }

    func fillInformations() {
        viewModel.loadInitialPersonalDataFormState()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
