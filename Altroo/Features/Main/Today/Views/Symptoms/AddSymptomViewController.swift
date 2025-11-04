//
//  AddSymptomViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 29/09/25.
//

import UIKit
import Combine

class AddSymptomViewController: GradientNavBarViewController {
    var viewModel: AddSymptomViewModel
    var coordinator: Coordinator?
    private var cancellables = Set<AnyCancellable>()

    let titleLabel = StandardLabel(labelText: "Adicionar Intercorrência", labelFont: .sfPro, labelType: .title2, labelColor: .black, labelWeight: .semibold)
    
    let addButton = StandardConfirmationButton(title: "Adicionar")
    
    let nameTexfield = StandardTextfield()
    let noteTexfield = StandardTextfield()
    
    let contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(viewModel: AddSymptomViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        nameTexfield.delegate = self
        noteTexfield.delegate = self
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
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

    
    func setupUI() {
        view.backgroundColor = .white

        view.addSubview(titleLabel)
        view.addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(didFinishCreating), for: .touchUpInside)
        
        setupContent()
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            contentStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Layout.bigButtonBottomPadding),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    
    func setupContent() {
        view.addSubview(contentStack)
        //name
        nameTexfield.placeholder = "Nome da intercorrência"
        let nameSection = FormSectionView(title: "Nome", content: nameTexfield)
        contentStack.addArrangedSubview(nameSection)
        
        //notes
        noteTexfield.placeholder = "Enter observations"
        let noteSection = FormSectionView(title: "Observações", content: noteTexfield)
        contentStack.addArrangedSubview(noteSection)
        
        //time
        let timePicker: UIDatePicker = UIDatePicker.make(mode: .time)
        let timeSection = FormSectionView(title: "Horário", content: timePicker)
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)


        //start
        let datePicker: UIDatePicker = UIDatePicker.make(mode: .date)
        let dateSection = FormSectionView(title: "Data", content: datePicker)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        //date and time
        let dateTimeStack = UIStackView(arrangedSubviews: [])
        dateTimeStack.axis = .horizontal
        dateTimeStack.distribution = .equalSpacing
        dateTimeStack.translatesAutoresizingMaskIntoConstraints = false
        dateTimeStack.addArrangedSubview(dateSection)
        dateTimeStack.addArrangedSubview(timeSection)
        contentStack.addArrangedSubview(dateTimeStack)
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

extension AddSymptomViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//#Preview {
//    AddSymptomViewController(viewModel: AddSymptomViewModel(careRecipientFacade: Car))
//}
