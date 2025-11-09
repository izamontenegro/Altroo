//
//  EditHealthProblems.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 30/10/25.
//

// EditHealthProblemsView.swift

import UIKit
import ObjectiveC

final class EditHealthProblemsView: UIView {
    let viewModel: EditMedicalRecordViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private lazy var diseaseTextField = StandardTextfield(placeholder: "Doenças separadas por vírgulas")
    private lazy var alergiesTextField = StandardTextfield(placeholder: "Alergias separadas por vírgulas")
    private lazy var surgeryNameTextField = StandardTextfield(placeholder: "Nome da cirurgia")

    private let surgeryDatePicker: UIDatePicker = {
        let p = UIDatePicker()
        p.datePickerMode = .date
        p.maximumDate = Date()
        p.preferredDatePickerStyle = .compact
        p.translatesAutoresizingMaskIntoConstraints = false
        p.setContentHuggingPriority(.required, for: .horizontal)
        p.setContentCompressionResistancePriority(.required, for: .horizontal)
        p.contentHorizontalAlignment = .leading
        return p
    }()

    private lazy var addSurgeryButton: OutlineButton = {
        let b = OutlineButton(title: "+", color: .blue40, cornerRadius: 8)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private lazy var observationView: ObservationView = {
        let v = ObservationView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var surgeriesListStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.alignment = .fill
        s.spacing = 12
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private let header: EditSectionHeaderView = {
        let h = EditSectionHeaderView(
            sectionTitle: "Problemas de Saúde",
            sectionDescription: "Preencha os campos a seguir quanto aos dados básicos da pessoa cuidada.",
            sectionIcon: "heart.fill"
        )
        h.translatesAutoresizingMaskIntoConstraints = false
        return h
    }()

    private lazy var formStack: UIStackView = {
        let diseasesSection = FormSectionView(title: "Doenças", content: diseaseTextField)
        diseaseTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        alergiesTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
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

    private lazy var contentStack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [header, formStack])
        s.axis = .vertical
        s.alignment = .fill
        s.spacing = 15
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private var endEditingObserver: NSObjectProtocol?

    deinit {
        if let obs = endEditingObserver { NotificationCenter.default.removeObserver(obs) }
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
    }

    private func bindUI() {
        diseaseTextField.addTarget(self, action: #selector(diseasesChanged), for: .editingChanged)
        diseaseTextField.addTarget(self, action: #selector(diseasesEditingEnded), for: .editingDidEnd)

        alergiesTextField.addTarget(self, action: #selector(allergiesChanged), for: .editingChanged)
        alergiesTextField.addTarget(self, action: #selector(allergiesEditingEnded), for: .editingDidEnd)

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
    @objc private func allergiesChanged() { viewModel.updateAllergiesText(alergiesTextField.text ?? "") }
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
        alergiesTextField.text = viewModel.healthFormState.allergiesText
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
        surgeriesListStack.arrangedSubviews.forEach { v in
            surgeriesListStack.removeArrangedSubview(v); v.removeFromSuperview()
        }

        guard let hp = viewModel.currentPatient()?.healthProblems,
              let set = hp.surgeries as? Set<Surgery> else { return }

        let surgeries = set.sorted {
            let da = $0.date ?? .distantPast
            let db = $1.date ?? .distantPast
            if da == db { return ($0.name ?? "") < ($1.name ?? "") }
            return da > db
        }

        for s in surgeries {
            surgeriesListStack.addArrangedSubview(makeSurgeryRow(for: s))
        }
    }

    private func makeSurgeryRow(for surgery: Surgery) -> UIView {
        let name = surgery.name ?? "—"
        let dateString = dateFormatter.string(from: surgery.date ?? Date())
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

    @objc private func deleteSurgeryTapped(_ sender: UIButton) {
        guard let surgery = objc_getAssociatedObject(sender, &AssociatedKeys.surgeryKey) as? Surgery else { return }
        viewModel.deleteSurgery(surgery)
        reloadSurgeriesList()
    }

    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.locale = Locale(identifier: "pt_BR")
        return df
    }()
}

private enum AssociatedKeys { static var surgeryKey: UInt8 = 0 }

extension EditHealthProblemsView: ObservationViewDelegate {
    func observationView(_ view: ObservationView, didChangeText text: String) {
        viewModel.updateObservationText(text)
    }
}
