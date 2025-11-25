//
//  AddSymptomViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 29/09/25.
//

import UIKit
import Combine

class AddSymptomViewController: UIViewController {
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
    
    private var currentContentView: (Int, UIView)?
    private lazy var chooseOptionView: (Int, UIView) = (1, ChooseSymptomOptionView(viewModel: viewModel))
    private lazy var detailOptionView: (Int, UIView) = (2, DetailSymptomOptionView(viewModel: viewModel))

    init(viewModel: AddSymptomViewModel) {
        self.viewModel = viewModel
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
    }
    
    
    func bindViewModel() {
        Publishers.CombineLatest(viewModel.$selectedSymptom, viewModel.$name)
            .sink { [weak self] selected, name in
                let canProceed = selected != nil || !name.isEmpty
                self?.updateConfirmationButtonState(enabled: canProceed)
            }
            .store(in: &cancellables)
    }
    
//    func bindViewModel() {
//        //name textfield
//        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: nameTexfield)
//            .compactMap { ($0.object as? UITextField)?.text }
//            .assign(to: \.name, on: viewModel)
//            .store(in: &cancellables)
//        
//        //note textfield
//        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: noteTexfield)
//            .compactMap { ($0.object as? UITextField)?.text }
//            .assign(to: \.note, on: viewModel)
//            .store(in: &cancellables)
//        
//        //validation
//        viewModel.$fieldErrors
//            .receive(on: RunLoop.main)
//            .sink { [weak self] errors in
//                self?.nameSection.setError(errors["name"])
//                self?.dateSection.setError(errors["date"])
//            }
//            .store(in: &cancellables)
//        
//    }

//    private func setupActions() {
//          confirmButton.addTarget(self, action: #selector(didFinishCreating), for: .touchUpInside)
//          datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
//          timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
//      }
    
    
    func makeContent() {
        view.addSubview(scrollView)
        scrollView.addSubview(titleSection)
        scrollView.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            titleSection.topAnchor.constraint(equalTo: scrollView.topAnchor),
            titleSection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            titleSection.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            titleSection.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            confirmButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            confirmButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        ])
        
        confirmButton.addTarget(self, action: #selector(tapConfirmButton), for: .touchUpInside)
        updateConfirmationButtonState(enabled: false)
    }
    
    func showContent(_ view: (Int, UIView)) {
        currentContentView = view
        view.1.removeFromSuperview()
        scrollView.addSubview(view.1)

        NSLayoutConstraint.activate([
            view.1.topAnchor.constraint(equalTo: titleSection.bottomAnchor, constant: 16),
            view.1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            view.1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            view.1.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            confirmButton.topAnchor.constraint(equalTo: view.1.bottomAnchor, constant: 24)
        ])
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
        showContent(detailOptionView)
    }
    
    func didFinishCreating() {
        guard viewModel.validateSymptom() else { return }
        
        viewModel.createSymptom()
        coordinator?.goToRoot()
    }
    
    private func updateConfirmationButtonState(enabled: Bool) {
        confirmButton.isUserInteractionEnabled = enabled
        UIView.animate(withDuration: 0.2) {
            self.confirmButton.backgroundColor = enabled ? .teal20 : .white50
        }
    }
}


//#Preview {
//    AddSymptomViewController(viewModel: AddSymptomViewModel(careRecipientFacade: Car))
//}
