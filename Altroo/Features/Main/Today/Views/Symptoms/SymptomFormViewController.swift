//
//  SymptomFormViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 14/10/25.
//
import UIKit

class SymptomFormViewController: GradientNavBarViewController {
    let titleLabel = StandardHeaderView(title: "", subtitle: "")
    
    let confirmButton = StandardConfirmationButton(title: "")
    let deleteButton = OutlineButton(title: "Deletar", color: .red20)
    
    private var confirmBottomConstraint: NSLayoutConstraint?
    
    let nameTexfield = StandardTextfield()
    let noteTexfield = StandardTextfield()
    
    let timePicker: UIDatePicker = UIDatePicker.make(mode: .time)
    let datePicker: UIDatePicker = UIDatePicker.make(mode: .date)
    
    lazy var nameSection = FormSectionView(title: "Nome", content: nameTexfield)
    lazy var dateSection = FormSectionView(title: "Data", content: datePicker)

    let contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        nameTexfield.delegate = self
        noteTexfield.delegate = self
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(confirmButton)
        
        setupContent()
        
        NSLayoutConstraint.activate([
            
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.mediumSpacing),
            contentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.mediumSpacing),
            contentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Layout.mediumSpacing),
            
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupContent() {
        view.addSubview(contentStack)
        contentStack.addArrangedSubview(titleLabel)
        
        //name
        nameTexfield.placeholder = "Nome da intercorrência"
        contentStack.addArrangedSubview(nameSection)
        
        //notes
        noteTexfield.placeholder = "Enter observations"
        let noteSection = FormSectionView(title: "Observações", content: noteTexfield)
        contentStack.addArrangedSubview(noteSection)
        
        //time
        let timeSection = FormSectionView(title: "Horário", content: timePicker)
                
        //date and time
        let dateTimeStack = UIStackView(arrangedSubviews: [dateSection, timeSection])
        dateTimeStack.axis = .horizontal
        dateTimeStack.distribution = .equalSpacing
        dateTimeStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(dateTimeStack)
    }
    
    func configure(title: String, subtitle: String, confirmButtonText: String, showDelete: Bool = false) {
        titleLabel.update(title: title, subtitle: subtitle)
        confirmButton.updateTitle(confirmButtonText)
        
        if showDelete {
            deleteButton.updateColor(.red10)
            view.addSubview(deleteButton)
            NSLayoutConstraint.activate([
                deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.smallButtonBottomPadding)
            ])
            confirmBottomConstraint = confirmButton.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -Layout.mediumSpacing)
            confirmBottomConstraint?.isActive = true
        } else {
            deleteButton.removeFromSuperview()
            confirmBottomConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.smallButtonBottomPadding)
            confirmBottomConstraint?.isActive = true
        }
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SymptomFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
