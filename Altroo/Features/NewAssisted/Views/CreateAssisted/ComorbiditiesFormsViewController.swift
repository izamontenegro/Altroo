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

    init(viewModel: AddPatientViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let titleSection = FormTitleSection(title: "Comorbidades", description: "Selecione o que corresponder às comorbidades da pessoa cuidada.", totalSteps: 3, currentStep: 2)
    
    private let label1 = StandardLabel(
        labelText: "O assistido tem alguma das condições abaixo?",
        labelFont: .sfPro,
        labelType: .title3,
        labelColor: .black10,
        labelWeight: .semibold
    )
    
    private let label2 = StandardLabel(
        labelText: "O assistido é acamado?",
        labelFont: .sfPro,
        labelType: .title3,
        labelColor: .black10,
        labelWeight: .semibold
    )
    
    private let nextStepButton = StandardConfirmationButton(title: "Próximo")
    
    let bedriddenMovableButton = BedriddenButton(bedriddenState: .movement)
    let bedriddenNoMovementButton = BedriddenButton(bedriddenState: .noMovement)
    
    private let firstRowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Layout.smallSpacing
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let secondRowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Layout.smallSpacing
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Layout.largeSpacing
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var selectedComorbidities: Set<String> = []

    override func viewDidLoad() {
        view.backgroundColor = .pureWhite
        
        setupComorbidityButtons()
        
        label1.numberOfLines = 0
        label1.lineBreakMode = .byWordWrapping
        
        mainStack.addArrangedSubview(titleSection)
        mainStack.setCustomSpacing(Layout.mediumSpacing, after: titleSection)
        mainStack.addArrangedSubview(label1)
        mainStack.setCustomSpacing(Layout.smallSpacing, after: label1)
        mainStack.addArrangedSubview(firstRowStack)
        mainStack.addArrangedSubview(label2)
        mainStack.setCustomSpacing(Layout.smallSpacing, after: label2)
        mainStack.addArrangedSubview(secondRowStack)
        
        view.addSubview(mainStack)
        view.addSubview(nextStepButton)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.smallSpacing),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.mediumSpacing),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.mediumSpacing),
            
            label1.widthAnchor.constraint(equalTo: mainStack.widthAnchor),
            firstRowStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor),
            
            label2.widthAnchor.constraint(equalTo: mainStack.widthAnchor),
            secondRowStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor),
            
            nextStepButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.mediumSpacing),
            nextStepButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextStepButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        nextStepButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }
    
    
    private func setupComorbidityButtons() {
        let firstRowDiseases: [ComorbidityButton.Comorbidity] = [.circulatory, .diabetes, .cognition]
        for disease in firstRowDiseases {
            let button = ComorbidityButton(comorbidity: disease)
            button.addTarget(self, action: #selector(didTapComorbidityButton(_:)), for: .touchUpInside)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
//                button.widthAnchor.constraint(equalToConstant: 115),
                button.heightAnchor.constraint(equalToConstant: 190)
            ])
            
            firstRowStack.addArrangedSubview(button)
        }

        bedriddenMovableButton.addTarget(self, action: #selector(didTapBedriddenButton(_:)), for: .touchUpInside)
        bedriddenNoMovementButton.addTarget(self, action: #selector(didTapBedriddenButton(_:)), for: .touchUpInside)

        secondRowStack.addArrangedSubview(bedriddenNoMovementButton)
        secondRowStack.addArrangedSubview(bedriddenMovableButton)
        
        NSLayoutConstraint.activate([
//            secondRowStack.widthAnchor.constraint(equalToConstant: 115),
            secondRowStack.heightAnchor.constraint(equalToConstant: 210)
        ])
    }
    
    
    @objc
    private func didTapComorbidityButton(_ sender: ComorbidityButton) {
        sender.toggleState()

        if sender.isSelectedState {
            diseasesList.append(DiseaseDraft(name: sender.comorbidity.name))
        } else {
            if let index = diseasesList.firstIndex(where: { $0.name == sender.comorbidity.name }) {
                diseasesList.remove(at: index)
            }
        }
    }
    
    @objc
    private func didTapBedriddenButton(_ sender: BedriddenButton) {
        sender.toggleState()

        switch sender.bedriddenState {
        case .movement:
            if bedriddenStatus != .notBedridden {
                bedriddenNoMovementButton.toggleState()
            }
            bedriddenStatus = .bedriddenMovable
        
        case .noMovement:
            if bedriddenStatus != .notBedridden {
                bedriddenMovableButton.toggleState()
            }
            bedriddenStatus = .bedriddenImmobile
        }
    }
    
    @objc
    func didTapDoneButton() {
        viewModel.updateHealthProblems(diseases: diseasesList, bedriddenStatus: bedriddenStatus)
        delegate?.goToShiftForms()
    }
}
