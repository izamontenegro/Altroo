//
//  EditHealthProblems.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 30/10/25.
//
import UIKit

final class EditHealthProblemsView: UIView {
    let viewModel: EditMedicalRecordViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?

    private lazy var diseaseTextField = StandardTextfield(placeholder: "Doenças separadas por vírgulas")
    private lazy var alergiesTextField = StandardTextfield(placeholder: "Alergias separadas por vírgulas")
    private lazy var surgeryNameTextField = StandardTextfield(placeholder: "Nome da cirurgia")

    private let surgeryDatePicker: UIDatePicker = {
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

    private lazy var addSurgeryButton: OutlineButton = {
        let button = OutlineButton(title: "+", color: .blue40, cornerRadius: 8)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.updateColor(.blue40)
        return button
    }()

    private lazy var observationView: ObservationView = {
        let view = ObservationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let header: EditSectionHeaderView = {
        let header = EditSectionHeaderView(
            sectionTitle: "Problemas de Saúde",
            sectionDescription: "Preencha os campos a seguir quanto aos dados básicos da pessoa cuidada.",
            sectionIcon: "heart.fill"
        )
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    private lazy var formStack: UIStackView = {
        let diseasesSection = FormSectionView(title: "Doenças", content: diseaseTextField)
        
        NSLayoutConstraint.activate([
            surgeryNameTextField.widthAnchor.constraint(equalToConstant: 246)
        ])

        let surgeriesHorizontalStack = UIStackView(arrangedSubviews: [surgeryNameTextField, surgeryDatePicker])
        surgeriesHorizontalStack.axis = .horizontal
        surgeriesHorizontalStack.spacing = 12
        surgeriesHorizontalStack.alignment = .fill
        surgeriesHorizontalStack.distribution = .fillProportionally

        let surgeriesVerticalStack = UIStackView(arrangedSubviews: [surgeriesHorizontalStack, addSurgeryButton])
        surgeriesVerticalStack.axis = .vertical
        surgeriesVerticalStack.spacing = 12
        surgeriesVerticalStack.alignment = .fill
        surgeriesVerticalStack.distribution = .fill

        let surgeriesSection = FormSectionView(title: "Cirurgias", content: surgeriesVerticalStack)
        let alergiesSection = FormSectionView(title: "Alergias", content: alergiesTextField)
        let observationsSection = FormSectionView(title: "Observações", content: observationView)

        let stack = UIStackView(arrangedSubviews: [
            diseasesSection,
            surgeriesSection,
            alergiesSection,
            observationsSection
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
        fillInformations()
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

        surgeryDatePicker.addTarget(self, action: #selector(handleDateChanged), for: .valueChanged)
    }

    @objc private func handleDateChanged() {
    }

    func fillInformations() {
        guard let patient = viewModel.userService.fetchCurrentPatient() else { return }
    }
}
