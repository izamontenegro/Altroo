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
    
    private let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Insert the comorbidities here"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next Step", for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let firstRowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let secondRowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var selectedComorbidities: Set<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setupComorbidityButtons()
        
        mainStack.addArrangedSubview(viewLabel)
        mainStack.addArrangedSubview(firstRowStack)
        mainStack.addArrangedSubview(secondRowStack)
        mainStack.addArrangedSubview(doneButton)
        
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            doneButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }
    
    private func setupComorbidityButtons() {
        let firstRowDiseases = ["Diabetes", "Hypertension", "Asthma"]
        for disease in firstRowDiseases {
            let button = createComorbidityButton(title: disease)
            firstRowStack.addArrangedSubview(button)
        }
        
        let secondRowDiseases = ["without movement", "with movement"]
        for disease in secondRowDiseases {
            let button = createComorbidityButton(title: disease)
            secondRowStack.addArrangedSubview(button)
        }
    }
    
    private func createComorbidityButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 8
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(didTapComorbidityButton(_:)), for: .touchUpInside)
        return button
    }
    
    @objc
    private func didTapComorbidityButton(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }

        if firstRowStack.arrangedSubviews.contains(sender) {
            if selectedComorbidities.contains(title) {
                selectedComorbidities.remove(title)
                // Remove da diseasesList
                if let index = diseasesList.firstIndex(where: { $0.name == title }) {
                    diseasesList.remove(at: index)
                }
                sender.backgroundColor = .systemGray5
            } else {
                selectedComorbidities.insert(title)
                // Adiciona à diseasesList
                diseasesList.append(DiseaseDraft(name: title))
                sender.backgroundColor = .systemBlue
            }
        } else if secondRowStack.arrangedSubviews.contains(sender) {
            // Reset visual de todos os botões da segunda linha
            for case let button as UIButton in secondRowStack.arrangedSubviews {
                button.backgroundColor = .systemGray5
            }
            sender.backgroundColor = .systemBlue
            
            switch title {
            case "without movement":
                bedriddenStatus = .notBedridden
            case "with movement":
                bedriddenStatus = .bedriddenMovable
            default:
                bedriddenStatus = .notBedridden
            }
        }
    }
    
    @objc
    func didTapDoneButton() {
        viewModel.updateHealthProblems(diseases: diseasesList, bedriddenStatus: bedriddenStatus)
        viewModel.finalizeCareRecipient()
        delegate?.goToShiftForms()
    }
}
