//
//  ComorbitiesFormsViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

class ComorbiditiesFormsViewController: UIViewController {
    
    weak var delegate: AssociatePatientViewControllerDelegate?
    private let viewModel: AddPatientViewModel
    private var bedriddenStatus: BedriddenStatus = .notBedridden
    private var diseasesList: [DiseaseDraft] = []
    private var keyboardHandler: KeyboardHandler?

    init(viewModel: AddPatientViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let titleSection = FormTitleSection(
        title: "comorbidities".localized,
        description: "comorbidities_subtitle".localized,
        totalSteps: 3,
        currentStep: 2
    )
    
    private let label1 = StandardLabel(
        labelText: "conditions_question".localized,
        labelFont: .sfPro, labelType: .title3, labelColor: .black10, labelWeight: .semibold
    )
    
    private let label2 = StandardLabel(
        labelText: "mobility_question".localized,
        labelFont: .sfPro, labelType: .title3, labelColor: .black10, labelWeight: .semibold
    )

    private let firstRowStack = UIStackView()
    private let secondRowStack = UIStackView()
    
    private let nextStepButton = StandardConfirmationButton(title: "next".localized)

    let bedriddenMovableButton = BedriddenButton(bedriddenState: .needsHelp)
    let bedriddenNoMovementButton = BedriddenButton(bedriddenState: .bedridden)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite
        setupUI()
        setupComorbidityButtons()
        keyboardHandler = KeyboardHandler(viewController: self, scrollView: scrollView)
    }

    private func setupUI() {

        label1.numberOfLines = 2
        label1.lineBreakMode = .byWordWrapping
        label2.numberOfLines = 2
        label2.lineBreakMode = .byWordWrapping
        
        bedriddenMovableButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        bedriddenMovableButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        bedriddenNoMovementButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        bedriddenNoMovementButton.setContentHuggingPriority(.defaultLow, for: .horizontal)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        contentStack.axis = .vertical
        contentStack.spacing = Layout.largeSpacing
        contentStack.alignment = .fill

        firstRowStack.axis = .horizontal
        firstRowStack.spacing = Layout.smallSpacing
        firstRowStack.distribution = .fillEqually

        secondRowStack.axis = .horizontal
        secondRowStack.distribution = .fillProportionally

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        nextStepButton.translatesAutoresizingMaskIntoConstraints = false
        nextStepButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        nextStepButton.widthAnchor.constraint(equalToConstant: 205).isActive = true

        contentStack.addArrangedSubview(titleSection)
        contentStack.addArrangedSubview(label1)
        contentStack.addArrangedSubview(firstRowStack)
        contentStack.addArrangedSubview(label2)
        contentStack.addArrangedSubview(secondRowStack)

        contentStack.addArrangedSubview(nextStepButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: Layout.mediumSpacing),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -Layout.mediumSpacing),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -40)
        ])

        nextStepButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }

    private func setupComorbidityButtons() {
        let firstRow: [ComorbidityButton.Comorbidity] = [.circulatory, .diabetes, .cognition]

        for disease in firstRow {
            let button = ComorbidityButton(comorbidity: disease)
            button.addTarget(self, action: #selector(didTapComorbidityButton(_:)), for: .touchUpInside)
            button.heightAnchor.constraint(equalToConstant: 190).isActive = true
            firstRowStack.addArrangedSubview(button)
        }
        
        bedriddenMovableButton.heightAnchor.constraint(equalToConstant: 210).isActive = true
        bedriddenNoMovementButton.heightAnchor.constraint(equalToConstant: 210).isActive = true
        bedriddenMovableButton.widthAnchor.constraint(equalToConstant: 170).isActive = true
        bedriddenNoMovementButton.widthAnchor.constraint(equalToConstant: 170).isActive = true

        bedriddenMovableButton.addTarget(self, action: #selector(didTapBedriddenButton(_:)), for: .touchUpInside)
        bedriddenNoMovementButton.addTarget(self, action: #selector(didTapBedriddenButton(_:)), for: .touchUpInside)

        secondRowStack.addArrangedSubview(bedriddenMovableButton)
        secondRowStack.addArrangedSubview(bedriddenNoMovementButton)
        secondRowStack.distribution = .equalSpacing
    }

    @objc private func didTapComorbidityButton(_ sender: ComorbidityButton) {
        sender.toggleState()
        if sender.isSelectedState {
            diseasesList.append(DiseaseDraft(name: sender.comorbidity.name))
        } else {
            diseasesList.removeAll { $0.name == sender.comorbidity.name }
        }
    }

    @objc private func didTapBedriddenButton(_ sender: BedriddenButton) {
        if sender.isSelectedState {
            sender.toggleState()
            bedriddenStatus = .notBedridden
            return
        }

        bedriddenMovableButton.setSelectedState(false)
        bedriddenNoMovementButton.setSelectedState(false)

        sender.setSelectedState(true)

        bedriddenStatus = sender.bedriddenState == .needsHelp ? .bedriddenMovable : .bedriddenImmobile
    }

    @objc func didTapDoneButton() {
        viewModel.updateHealthProblems(diseases: diseasesList, bedriddenStatus: bedriddenStatus)
        delegate?.goToShiftForms(receivedPatientViaShare: false, patient: nil)
    }
}
