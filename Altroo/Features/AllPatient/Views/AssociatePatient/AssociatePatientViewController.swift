//
//  AssociatePatientViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 30/09/25.
//

import UIKit

protocol AssociatePatientViewControllerDelegate: AnyObject {
    func goToPatientForms()
    func goToComorbiditiesForms()
    func goToShiftForms()
    func goToTutorialAddSheet()
}

class AssociatePatientViewController: UIViewController {
    weak var delegate: AssociatePatientViewControllerDelegate?
    
    private let viewModel: AssociatePatientViewModel

    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "All patients / no patient View"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addNewPatientButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Add new patient", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addExistingPatientButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Add existing patient", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(viewModel: AssociatePatientViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        setupLayout()
        updateView()
    }
    
    private func setupLayout() {
        view.addSubview(vStack)
        vStack.addArrangedSubview(viewLabel)
        vStack.addArrangedSubview(addNewPatientButton)
        vStack.addArrangedSubview(addExistingPatientButton)
        
        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        addNewPatientButton.addTarget(self, action: #selector(didTapAddNewPatientButton), for: .touchUpInside)
        addExistingPatientButton.addTarget(self, action: #selector(didTapAddExistingPatientButton), for: .touchUpInside)
    }
    
    private func updateView() {
        
//        let patients = viewModel.allPatients

//        if patients.isEmpty {
            viewLabel.text = "No patients"
//        } else {
//            let names = patients.compactMap { $0.personalData?.name }
//            viewLabel.text = names.joined(separator: "")
//        }
    }
    
    @objc
    func didTapAddNewPatientButton() {
        delegate?.goToPatientForms()
    }
    
    @objc
    func didTapAddExistingPatientButton() {
        delegate?.goToTutorialAddSheet()
    }
}
