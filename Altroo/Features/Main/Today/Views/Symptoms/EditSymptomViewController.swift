//
//  EditSymptomViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 14/10/25.
//
import UIKit
import Combine

class EditSymptomViewController: SymptomFormViewController {
    var viewModel: EditSymptomViewModel
    var coordinator: Coordinator?
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: EditSymptomViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(title: "Editar Intercorrência", subtitle: "", confirmButtonText: "save".localized, showDelete: true)
        bindViewModel()
        
        confirmButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
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
        
        //validation
        viewModel.$fieldErrors
            .receive(on: RunLoop.main)
            .sink { [weak self] errors in
                self?.nameSection.setError(errors["name"])
                self?.dateSection.setError(errors["date"])
            }
            .store(in: &cancellables)
        
        //update fields
        viewModel.$name
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                self?.nameTexfield.text = name
            }
            .store(in: &cancellables)
        
        viewModel.$note
            .receive(on: DispatchQueue.main)
            .sink { [weak self] note in
                self?.noteTexfield.text = note
            }
            .store(in: &cancellables)
        
        viewModel.$date
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                self?.datePicker.date = date
            }
            .store(in: &cancellables)
        
        viewModel.$time
            .receive(on: DispatchQueue.main)
            .sink { [weak self] time in
                self?.timePicker.date = time
            }
            .store(in: &cancellables)
    }
    
    
    @objc private func didTapSave() {
        guard viewModel.validateSymptom() else { return }
        viewModel.updateSymptom()
        coordinator?.goToRoot()
    }
    
    @objc private func didTapDelete() {
        viewModel.deleteSymptom()
        coordinator?.goToRoot()
    }
}

//#Preview {
//    EditSymptomViewController(viewModel: EditSymptomViewModel())
//}
