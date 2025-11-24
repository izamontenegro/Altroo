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
    
    let header = StandardHeaderView(title: "Adicionar Intercorrência", subtitle: "Selecione uma das opções listadas de intercorrências ou crie uma nova.")
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private var currentContentView: UIView?
    private lazy var chooseOptionView = ChooseSymptomOptionView(viewModel: viewModel)

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
        
//        configure(title: "add_intercurrence".localized, subtitle: "", confirmButtonText: "add".localized)
//        bindViewModel()
//        setupActions()
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
    
    func showContent(_ view: UIView) {
        currentContentView?.removeFromSuperview()
        currentContentView = view

        scrollView.addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            view.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    func makeContent() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    
    @objc func didFinishCreating() {
        guard viewModel.validateSymptom() else { return }
        
        viewModel.createSymptom()
        coordinator?.goToRoot()
    }
    
    @objc func dateChanged(_ picker: UIDatePicker) {
        viewModel.date = picker.date
    }
    
    @objc func timeChanged(_ picker: UIDatePicker) {
        viewModel.time = picker.date
    }
    
    
}


//#Preview {
//    AddSymptomViewController(viewModel: AddSymptomViewModel(careRecipientFacade: Car))
//}
