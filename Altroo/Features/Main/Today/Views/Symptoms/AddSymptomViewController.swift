//
//  AddSymptomViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 29/09/25.
//

import UIKit
import Combine

class AddSymptomViewController: SymptomFormViewController {
    var viewModel: AddSymptomViewModel
    var coordinator: Coordinator?
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: AddSymptomViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(title: "Adicionar Intercorrência", subtitle: "", confirmButtonText: "Adicionar")
        bindViewModel()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: .toggleTabBarVisibility, object: nil, userInfo: ["hidden": true])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: .toggleTabBarVisibility, object: nil, userInfo: ["hidden": false])
    }
    
    func bindViewModel() {
        //name textfield
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: nameTexfield)
            .compactMap { ($0.object as? UITextField)?.text }
            .assign(to: \.name, on: viewModel)
            .store(in: &cancellables)
        
        //note textfield
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: noteTexfield)
            .compactMap { ($0.object as? UITextField)?.text }
            .assign(to: \.note, on: viewModel)
            .store(in: &cancellables)
        
    }

    private func setupActions() {
          confirmButton.addTarget(self, action: #selector(didFinishCreating), for: .touchUpInside)
          datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
          timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
      }
    
    
    @objc func didFinishCreating() {
        guard viewModel.createSymptom() else { return }
        
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
