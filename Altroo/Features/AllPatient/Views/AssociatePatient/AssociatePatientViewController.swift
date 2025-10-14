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
    private var userService: UserServiceProtocol
    private let viewModel: AssociatePatientViewModel

    let viewLabel = StandardLabel(
        labelText: "Nenhum Assistido encontrado.\nClique no botão \"Adicionar\" para criar.",
        labelFont: .sfPro,
        labelType: .title3,
        labelColor: .black40,
        labelWeight: .regular
    )
    
    let addNewPatientButton = StandardConfirmationButton(title: "Adicionar")
    
    let addExistingPatientButton: UIButton = {
        let button = UIButton(type: .system)
        let label = StandardLabel(
            labelText: "Já tenho uma pessoa cadastrada",
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .teal10,
            labelWeight: .regular
        )
        button.setAttributedTitle(NSAttributedString(string: label.labelText, attributes: [
            .font: label.font!,
            .foregroundColor: label.textColor!
        ]), for: .normal)
        button.backgroundColor = .clear
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
    
    init(viewModel: AssociatePatientViewModel, userService: UserServiceProtocol) {
        self.viewModel = viewModel
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Seus Assistidos"

        setupLayout()
        updateView()
    }
    
    private func setupLayout() {
        view.addSubview(viewLabel)
        view.addSubview(addNewPatientButton)
        view.addSubview(addExistingPatientButton)
        
        let buttonsStack = UIStackView(arrangedSubviews: [addNewPatientButton, addExistingPatientButton])
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 7
        buttonsStack.alignment = .center
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            viewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            viewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            addNewPatientButton.heightAnchor.constraint(equalToConstant: 50),
            addNewPatientButton.widthAnchor.constraint(equalToConstant: 229)
        ])
        
        addNewPatientButton.addTarget(self, action: #selector(didTapAddNewPatientButton), for: .touchUpInside)
        addExistingPatientButton.addTarget(self, action: #selector(didTapAddExistingPatientButton), for: .touchUpInside)
    }

    private func updateView() {
        let careRecipients = userService.fetchPatients()
        
        viewLabel.numberOfLines = 0
        viewLabel.lineBreakMode = .byWordWrapping
        viewLabel.textAlignment = .center
        
        if !careRecipients.isEmpty {
            let names = careRecipients.compactMap { $0.personalData?.name }
            viewLabel.text = names.joined(separator: "\n")
        }
    }
    
    @objc func didTapAddNewPatientButton() { delegate?.goToPatientForms() }
    
    @objc func didTapAddExistingPatientButton() { delegate?.goToTutorialAddSheet() }
}

#Preview {
    let mockService = UserServiceSession(context: AppDependencies().coreDataService.stack.context)
    let viewModel = AssociatePatientViewModel()
    AssociatePatientViewController(viewModel: viewModel, userService: mockService)
}
