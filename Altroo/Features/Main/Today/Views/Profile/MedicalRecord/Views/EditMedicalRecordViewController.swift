//
//  EditMedicalRecordViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 30/10/25.
//
import UIKit
import Combine

final class EditMedicalRecordViewController: GradientNavBarViewController, MedicalRecordSectionSelectorViewDelegate {
    
    let viewModel: EditMedicalRecordViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?
    
    private lazy var editPersonalDataForms = EditPersonalDataView(viewModel: viewModel)
    private lazy var editHealthProblemsForms = EditHealthProblemsView(viewModel: viewModel)
    private lazy var editPhysicalStateForms = EditPhysicalStateView(viewModel: viewModel)
    private lazy var editMentalStateForms = EditMentalStateView(viewModel: viewModel)
    private lazy var editPersonalCareForms = EditPersonalCareView(viewModel: viewModel)

    private var currentContentView: UIView?
    private var currentSectionIndex: Int = 0
    private var cancellables = Set<AnyCancellable>()

    private let contentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let progressBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue80
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let progressView: MedicalRecordProgressView = {
        let view = MedicalRecordProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle(text: "Conclusão da ficha")
        return view
    }()

    private lazy var sectionSelectorView: MedicalRecordSectionSelectorView = {
        let selector = MedicalRecordSectionSelectorView(
            symbolNames: ["person.fill", "heart.fill", "figure.arms.open", "brain.head.profile.fill", "hand.raised.fill"]
        )
        selector.delegate = self
        selector.translatesAutoresizingMaskIntoConstraints = false
        return selector
    }()

    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        let salvarButton = UIButton(type: .system)
        salvarButton.setTitle("Salvar", for: .normal)
        salvarButton.titleLabel?.font = .systemFont(ofSize: 17)
        salvarButton.addTarget(self, action: #selector(handleSaveTapped), for: .touchUpInside)
        rightButton = salvarButton

        super.viewDidLoad()

        view.backgroundColor = .pureWhite

        view.addSubview(contentContainerView)
        view.addSubview(sectionSelectorView)
        view.addSubview(progressBackgroundView)
        progressBackgroundView.addSubview(progressView)

        NSLayoutConstraint.activate([
            contentContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            sectionSelectorView.bottomAnchor.constraint(equalTo: progressBackgroundView.topAnchor, constant: -20),
            sectionSelectorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sectionSelectorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sectionSelectorView.heightAnchor.constraint(equalToConstant: 30),

            progressBackgroundView.topAnchor.constraint(equalTo: sectionSelectorView.bottomAnchor, constant: 6),
            progressBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            progressView.topAnchor.constraint(equalTo: progressBackgroundView.topAnchor, constant: 10),
            progressView.leadingAnchor.constraint(equalTo: progressBackgroundView.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: progressBackgroundView.trailingAnchor, constant: -16),
            progressView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])

        view.bringSubviewToFront(sectionSelectorView)
        displaySection(editPersonalDataForms)
        viewModel.loadInitialPersonalDataFormState()

        let currentPatient = viewModel.userService.fetchCurrentPatient()
        progressView.setCareRecipient(currentPatient, animated: false)
    }

    func medicalRecordSectionSelectorView(_ selectorView: MedicalRecordSectionSelectorView, didSelectIndex index: Int) {
        
        guard viewModel.validatePersonalData() else { return }
        currentSectionIndex = index
        
        switch index {
        case 0:
            displaySection(editPersonalDataForms)
            viewModel.loadInitialPersonalDataFormState()
        case 1:
            displaySection(editHealthProblemsForms)
        case 2:
            displaySection(editPhysicalStateForms)
            viewModel.loadInitialPhysicalStateFormState()
        case 3:
            displaySection(editMentalStateForms)
            viewModel.loadInitialMentalStateFormState()
        case 4:
            displaySection(editPersonalCareForms)
            viewModel.loadInitialPersonalCareFormState()
        default:
            displaySection(editPersonalDataForms)
            viewModel.loadInitialPersonalDataFormState()
        }

        let currentPatient = viewModel.userService.fetchCurrentPatient()
        progressView.setCareRecipient(currentPatient, animated: true)
    }
    
    func medicalRecordSectionSelectorView(_ selectorView: MedicalRecordSectionSelectorView, shouldChangeAppearanceTo index: Int) -> Bool {
        return viewModel.validatePersonalData()
    }

    private func displaySection(_ newContentView: UIView) {
        if let currentContentView {
            currentContentView.removeFromSuperview()
        }

        contentContainerView.addSubview(newContentView)
        newContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newContentView.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            newContentView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            newContentView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            newContentView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor)
        ])

        currentContentView = newContentView
        view.layoutIfNeeded()
    }

    @objc func handleSaveTapped() {
        guard viewModel.validatePersonalData() else { return }
        
        viewModel.persistFormState()
        let currentPatient = viewModel.userService.fetchCurrentPatient()
        progressView.setCareRecipient(currentPatient, animated: true)
        navigationController?.popViewController(animated: true)
    }
}
