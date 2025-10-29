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
    func goToMainFlow()
}

class AssociatePatientViewController: UIViewController {
    weak var delegate: AssociatePatientViewControllerDelegate?
    private let viewModel: AssociatePatientViewModel

    let viewLabel = StandardLabel(
        labelText: "Nenhum Assistido encontrado.\nClique no botão para criar.",
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
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        scroll.showsVerticalScrollIndicator = false
        return scroll
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Seus Assistidos"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .pureWhite
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black10]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        setupLayout()
        updateView()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(remoteDataChanged),
            name: .didFinishCloudKitSync,
            object: nil
        )
    }

    @objc private func remoteDataChanged() {
        DispatchQueue.main.async {
            self.updateView()
        }
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(vStack)
        view.addSubview(addNewPatientButton)
        view.addSubview(addExistingPatientButton)

        let buttonsStack = UIStackView(arrangedSubviews: [addNewPatientButton, addExistingPatientButton])
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 7
        buttonsStack.alignment = .center
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            scrollView.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor, constant: -20),

            vStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            vStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            addNewPatientButton.heightAnchor.constraint(equalToConstant: 50),
            addNewPatientButton.widthAnchor.constraint(equalToConstant: 229)
        ])

        addNewPatientButton.addTarget(self, action: #selector(didTapAddNewPatientButton), for: .touchUpInside)
        addExistingPatientButton.addTarget(self, action: #selector(didTapAddExistingPatientButton), for: .touchUpInside)
    }

    private func updateView() {
        let careRecipients = viewModel.fetchAvailableCareRecipients()
        
        vStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if careRecipients.isEmpty {
               viewLabel.numberOfLines = 0
               viewLabel.textAlignment = .center
               
               let emptyStateContainer = UIView()
               emptyStateContainer.translatesAutoresizingMaskIntoConstraints = false
               emptyStateContainer.addSubview(viewLabel)
               
               NSLayoutConstraint.activate([
                   viewLabel.centerXAnchor.constraint(equalTo: emptyStateContainer.centerXAnchor),
                   viewLabel.centerYAnchor.constraint(equalTo: emptyStateContainer.centerYAnchor),
                   viewLabel.leadingAnchor.constraint(equalTo: emptyStateContainer.leadingAnchor, constant: Layout.mediumSpacing),
                   viewLabel.trailingAnchor.constraint(equalTo: emptyStateContainer.trailingAnchor, constant: -Layout.mediumSpacing)
               ])
               
               vStack.addArrangedSubview(emptyStateContainer)
               
               NSLayoutConstraint.activate([
                   emptyStateContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
               ])
            
        } else {
            for careRecipient in careRecipients {
                let card = CareRecipientCard(
                    name: careRecipient.personalData?.name ?? "",
                    age: careRecipient.personalData?.age ?? 0,
                    careRecipient: careRecipient
                )
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCareRecipientCard(_:)))
                card.addGestureRecognizer(tapGesture)
                card.isUserInteractionEnabled = true
                
                vStack.addArrangedSubview(card)
            }
        }
    }

    @objc private func didTapCareRecipientCard(_ sender: UITapGestureRecognizer) {
        guard let card = sender.view as? CareRecipientCard,
              let careRecipient = card.careRecipient else { return }
        
        viewModel.setCurrentPatient(careRecipient)
        delegate?.goToMainFlow()
    }
    
    @objc func didTapAddNewPatientButton() { delegate?.goToPatientForms() }
    
    @objc func didTapAddExistingPatientButton() { delegate?.goToTutorialAddSheet() }
}

//#Preview {
//    let mockService = UserServiceSession(context: AppDependencies().coreDataService.stack.context)
//    let viewModel = AssociatePatientViewModel(userService: mockService)
//    AssociatePatientViewController(viewModel: viewModel)
//}
