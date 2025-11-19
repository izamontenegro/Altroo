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

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private lazy var diseaseTextField = StandardTextfield(placeholder: "Doenças separadas por vírgulas")
    private lazy var allergiesTextField = StandardTextfield(placeholder: "Alergias separadas por vírgulas")
    private lazy var surgeryNameTextField = StandardTextfield(placeholder: "Nome da cirurgia")

    private let surgeryDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.setContentHuggingPriority(.required, for: .horizontal)
        datePicker.setContentCompressionResistancePriority(.required, for: .horizontal)
        datePicker.contentHorizontalAlignment = .leading
        return datePicker
    }()

    private lazy var addSurgeryButton: OutlineButton = {
        let button = OutlineButton(title: "+", color: .blue40, cornerRadius: 8)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var observationView: ObservationView = {
        let view = ObservationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var surgeriesListStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let header: EditSectionHeaderView = {
        let header = EditSectionHeaderView(
            sectionTitle: "Problemas de Saúde",
            sectionDescription: "patient_profile_description".localized,
            sectionIcon: "heart.fill"
        )
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    private lazy var formStack: UIStackView = {
        let diseasesSection = FormSectionView(title: "Doenças", content: diseaseTextField)
        diseaseTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        allergiesTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        surgeryNameTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true

        NSLayoutConstraint.activate([
            surgeryNameTextField.widthAnchor.constraint(equalToConstant: 246)
        ])

        let surgeriesHorizontalStack = UIStackView(arrangedSubviews: [surgeryNameTextField, surgeryDatePicker])
        surgeriesHorizontalStack.axis = .horizontal
        surgeriesHorizontalStack.spacing = 12
        surgeriesHorizontalStack.alignment = .fill
        surgeriesHorizontalStack.distribution = .fillProportionally

        let surgeriesVerticalStack = UIStackView(arrangedSubviews: [surgeriesHorizontalStack, addSurgeryButton, surgeriesListStack])
        surgeriesVerticalStack.axis = .vertical
        surgeriesVerticalStack.spacing = 12
        surgeriesVerticalStack.alignment = .fill
        surgeriesVerticalStack.distribution = .fill

        let surgeriesSection = FormSectionView(title: "Cirurgias", content: surgeriesVerticalStack)
        let allergiesSection = FormSectionView(title: "Alergias", content: allergiesTextField)
        let observationsSection = FormSectionView(title: "observations".localized, content: observationView)

        let stack = UIStackView(arrangedSubviews: [
            diseasesSection,
            surgeriesSection,
            allergiesSection,
            observationsSection
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [header, formStack])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private var endEditingObserver: NSObjectProtocol?

    deinit {
        if let observer = endEditingObserver { NotificationCenter.default.removeObserver(observer) }
    }

    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
        bindUI()
        fillInformations()
        reloadSurgeriesList()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        backgroundColor = .pureWhite

        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutMargins = UIEdgeInsets(top: 15, left: 16, bottom: 20, right: 16)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        contentView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }

    private func bindUI() {
        diseaseTextField.addTarget(self, action: #selector(diseasesChanged), for: .editingChanged)
        diseaseTextField.addTarget(self, action: #selector(diseasesEditingEnded), for: .editingDidEnd)

        allergiesTextField.addTarget(self, action: #selector(allergiesChanged), for: .editingChanged)
        allergiesTextField.addTarget(self, action: #selector(allergiesEditingEnded), for: .editingDidEnd)

        surgeryNameTextField.addTarget(self, action: #selector(surgeryNameChanged), for: .editingChanged)
        surgeryDatePicker.addTarget(self, action: #selector(handleDateChanged), for: .valueChanged)
        addSurgeryButton.addTarget(self, action: #selector(addSurgeryTapped), for: .touchUpInside)

        observationView.delegate = self

        endEditingObserver = NotificationCenter.default.addObserver(
            forName: UITextView.textDidEndEditingNotification,
            object: observationView.textView,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.updateObservationText(self.observationView.textView.text)
            self.viewModel.persistObservation()
        }
    }

    @objc private func diseasesChanged() { viewModel.updateDiseasesText(diseaseTextField.text ?? "") }
    @objc private func diseasesEditingEnded() {
        viewModel.persistDiseaseFormState()
        diseaseTextField.text = viewModel.diseaseFormState.diseasesText
    }
    @objc private func allergiesChanged() { viewModel.updateAllergiesText(allergiesTextField.text ?? "") }
    @objc private func allergiesEditingEnded() { viewModel.persistAllergies() }
    @objc private func surgeryNameChanged() { viewModel.updateSurgeryName(surgeryNameTextField.text ?? "") }
    @objc private func handleDateChanged() { viewModel.updateSurgeryDate(surgeryDatePicker.date) }

    @objc private func addSurgeryTapped() {
        viewModel.addSurgeryFromState()
        surgeryNameTextField.text = ""
        reloadSurgeriesList()
    }

    func fillInformations() {
        viewModel.loadAllInitialStates()
        diseaseTextField.text = viewModel.diseaseFormState.diseasesText
        allergiesTextField.text = viewModel.healthFormState.allergiesText
        observationView.textView.text = viewModel.healthFormState.observationText
        surgeryDatePicker.date = viewModel.healthFormState.surgeryDate
    }

    func persistAllFromView() {
        viewModel.updateObservationText(observationView.textView.text)
        viewModel.persistObservation()
        viewModel.persistAllergies()
        viewModel.persistDiseaseFormState()
    }

    private func reloadSurgeriesList() {
        surgeriesListStack.arrangedSubviews.forEach { view in
            surgeriesListStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        guard let healthProblems = viewModel.currentPatient()?.healthProblems,
              let surgeriesSet = healthProblems.surgeries as? Set<Surgery> else { return }

        let surgeries = surgeriesSet.sorted {
            let dateA = $0.date ?? .distantPast
            let dateB = $1.date ?? .distantPast
            if dateA == dateB { return ($0.name ?? "") < ($1.name ?? "") }
            return dateA > dateB
        }

        for surgery in surgeries {
            surgeriesListStack.addArrangedSubview(makeSurgeryRow(for: surgery))
        }
    }

    private func makeSurgeryRow(for surgery: Surgery) -> UIView {
        let name = surgery.name ?? "—"
        let dateString = DateFormatterHelper.birthDateFormatter(from: surgery.date ?? Date())
        let infoView = MedicalRecordInfoItemView(infotitle: name, primaryText: dateString, secondaryText: "")

        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = UIColor(resource: .red40)
        deleteButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        objc_setAssociatedObject(deleteButton, &AssociatedKeys.surgeryKey, surgery, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        deleteButton.addTarget(self, action: #selector(deleteSurgeryTapped(_:)), for: .touchUpInside)

        let row = UIStackView(arrangedSubviews: [infoView, deleteButton])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 12

        infoView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        deleteButton.setContentHuggingPriority(.required, for: .horizontal)

        return row
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }


    @objc private func deleteSurgeryTapped(_ sender: UIButton) {
        guard let surgery = objc_getAssociatedObject(sender, &AssociatedKeys.surgeryKey) as? Surgery else { return }
        viewModel.deleteSurgery(surgery)
        reloadSurgeriesList()
    }
}

private enum AssociatedKeys { static var surgeryKey: UInt8 = 0 }

extension EditHealthProblemsView: ObservationViewDelegate {
    func observationView(_ view: ObservationView, didChangeText text: String) {
        viewModel.updateObservationText(text)
    }
}
