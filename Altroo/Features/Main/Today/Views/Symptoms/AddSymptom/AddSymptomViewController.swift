//
//  AddSymptomViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 29/09/25.
//

import UIKit
import Combine

enum Mode {
    case create
    case edit(existing: Symptom)
}

class AddSymptomViewController: UIViewController {
    let mode: Mode
    var viewModel: AddSymptomViewModel
    var coordinator: Coordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var titleSection = FormTitleSection(title: "Adicionar Intercorrência", description: "Selecione uma das opções listadas de intercorrências ou crie uma nova.", totalSteps: 2, currentStep: currentContentView?.0 ?? 1)
    
    let confirmButton = StandardConfirmationButton(title: "Próximo")
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var contentPlaceholder: UIView {
        return stackView.arrangedSubviews[1]
    }
    
    private var currentContentView: (Int, UIView)?
    private lazy var chooseOptionView: (Int, UIView) = (1, ChooseSymptomOptionView(viewModel: viewModel))
    private lazy var detailOptionView: (Int, UIView) = (2, DetailSymptomOptionView(viewModel: viewModel))

    init(viewModel: AddSymptomViewModel, mode: Mode) {
        self.viewModel = viewModel
        self.mode = mode

        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        makeContent()
        showContent(chooseOptionView)
        bindViewModel()
        configureNavBar()
    }
    
    func bindViewModel() {
        Publishers.CombineLatest(viewModel.$selectedSymptom, viewModel.$name)
            .sink { [weak self] selected, name in
                let canProceed = selected != nil || !name.isEmpty
                self?.updateConfirmationButtonState(enabled: canProceed)
            }
            .store(in: &cancellables)
    }
    
    private func configureNavBar() {
        switch mode {
        case .create:
            let closeButton = UIBarButtonItem(title: "Fechar", style: .done, target: self, action: #selector(closeTapped))
            closeButton.tintColor = .blue20
            navigationItem.rightBarButtonItem = closeButton
        case .edit(let existing):
            let deleteButton = UIBarButtonItem(title: "Deletar", style: .done, target: self, action: #selector(deleteTapped))
            deleteButton.tintColor = .red20
            navigationItem.rightBarButtonItem = deleteButton
        }

        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    @objc func deleteTapped() {
        viewModel.deleteSymptom()
    }
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc func backTapped() {
        showContent(chooseOptionView)
    }
    
    func makeContent() {
        view.addSubview(scrollView)
        scrollView.addSubview(titleSection)
        scrollView.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            titleSection.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            titleSection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            titleSection.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            titleSection.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            confirmButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32)
        ])
        
        confirmButton.addTarget(self, action: #selector(tapConfirmButton), for: .touchUpInside)
        updateConfirmationButtonState(enabled: false)
    }
    
    func showContent(_ view: (Int, UIView)) {
        currentContentView?.1.removeFromSuperview()
        currentContentView = view
        view.1.removeFromSuperview()
        scrollView.addSubview(view.1)

        NSLayoutConstraint.activate([
            view.1.topAnchor.constraint(equalTo: titleSection.bottomAnchor, constant: 16),
            view.1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            view.1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            view.1.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            view.1.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -24)
        ])
        
        updateTitleSection()
    }
    
    
    @objc func tapConfirmButton() {
        switch currentContentView?.0 {
        case 1:
            proceedToNext()
        case 2:
            didFinishCreating()
        default:
            break
        }
    }
    
    func proceedToNext() {
        if let selectedSymptom = viewModel.selectedSymptom {
            viewModel.name = selectedSymptom.displayText
        }
        addBackButton()
        showContent(detailOptionView)
    }
    
    func didFinishCreating() {
        guard viewModel.validateSymptom() else { return }
        
        viewModel.createSymptom()
        dismiss(animated: true)
    }
    
    func addBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setTitle("Voltar", for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .blue20
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func updateConfirmationButtonState(enabled: Bool) {
        confirmButton.isUserInteractionEnabled = enabled
        UIView.animate(withDuration: 0.2) {
            self.confirmButton.backgroundColor = enabled ? .teal20 : .white50
        }
    }
    
    func updateTitleSection() {
        let page = currentContentView?.0 ?? 1

        switch mode {
        case .create:
            let title = "Adicionar Intercorrência"
            let desc = page == 1
                ? "Selecione uma das opções listadas de intercorrências ou crie uma nova."
                : "Descreva a intercorrência que aconteceu com o paciente acompanhado."
            titleSection.updateContent(title: title, description: desc, currentStep: page)

        case .edit:
            let title = "Editar Intercorrência"
            let desc = page == 1
                ? "Selecione uma das opções listadas de intercorrências ou crie uma nova."
                : "Descreva a intercorrência que aconteceu com o paciente acompanhado."
            titleSection.updateContent(title: title, description: desc, currentStep: page)
        }
    }

}
