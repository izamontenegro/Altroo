//
//  AddRoutineActivityViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 29/09/25.
//

import UIKit
import Combine

class AddTaskViewController: GradientNavBarViewController {
    var viewModel: AddTaskViewModel
    private var cancellables = Set<AnyCancellable>()


    let titleLabel = StandardLabel(labelText: "Add Tasks", labelFont: .sfPro, labelType: .title2, labelColor: .black, labelWeight: .semibold)
    
    let addButton = StandardConfirmationButton(title: "Add")
    
    let nameTexfield = StandardTextfield()
    let noteTexfield = StandardTextfield()
    
    let startDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.tintColor = .teal50
        datePicker.translatesAutoresizingMaskIntoConstraints = true
        return datePicker
    }()
    
    var endDateSection: UIView!
    
    let endDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.tintColor = .teal50
        datePicker.translatesAutoresizingMaskIntoConstraints = true
        return datePicker
    }()
    
    let contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let dateStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
        
    init(viewModel: AddTaskViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
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
        
        //isContinuous
        viewModel.$isContinuous
            .receive(on: RunLoop.main)
            .sink { [weak self] isContinuous in
                guard let self else { return }
                
                if isContinuous {
                    removeEndDate()
                } else {
                    addEndDate()
                }
            }
            .store(in: &cancellables)
            
    }
    
    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        
        setupContent()
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            contentStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        ])
    }
    
    func setupContent() {
        view.addSubview(contentStack)
        //name
        nameTexfield.placeholder = "Enter task name"
        let nameSection = makeSection(title: "Name", content: nameTexfield)
        contentStack.addArrangedSubview(nameSection)
        
        //time
        
        
        //repeat
        let weekdayRow = makeDayRow()
        let repeatSection = makeSection(title: "Repeat", content: weekdayRow)
        contentStack.addArrangedSubview(repeatSection)
        
        //duration
            //start
        startDatePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
        let startSection = makeSection(title: "Start", content: startDatePicker)
            //end
        endDatePicker.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)
        endDateSection = makeSection(title: "End", content: endDatePicker)
            //picker
        let continuousButton = PopupMenuButton(title: viewModel.continuousButtonTitle)
        let pickActionClosure = { [self](action: UIAction) in
            self.viewModel.isContinuous.toggle()
        }
        var menuChildren: [UIMenuElement] = []
        for option in viewModel.continuousOptions {
            menuChildren.append(UIAction(title: option, handler: pickActionClosure))
        }
        continuousButton.menu = UIMenu(options: .displayInline, children: menuChildren)
        continuousButton.showsMenuAsPrimaryAction = true
        continuousButton.changesSelectionAsPrimaryAction = true
        
        let durationSection = makeSection(title: "Duration", content: continuousButton)
        
            //stack
        dateStack.addArrangedSubview(startSection)
        dateStack.addArrangedSubview(durationSection)
        contentStack.addArrangedSubview(dateStack)
        
        
        //notes
        noteTexfield.placeholder = "Enter observations"
        let noteSection = makeSection(title: "Notes", content: noteTexfield)
        contentStack.addArrangedSubview(noteSection)
        
    }
    
    func makeSection(title: String, content: UIView) -> UIStackView {
        let titleSection = StandardLabel(labelText: title, labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .semibold)
        
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(titleSection)
        stackView.addArrangedSubview(content)
        
        return stackView
    }
    
    func makeDayRow() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
                
        for day in Locale.Weekday.allCases {
            //TODO: CHANGE FROM BUTTONS TO TAG
            let tag = PrimaryStyleButton(title: day.rawValue.first!.uppercased())
            stackView.addArrangedSubview(tag)
        }
        
        return stackView
    }
    
    func addEndDate() {
        dateStack.insertArrangedSubview(endDateSection, at: 1)
    }
    
    func removeEndDate() {
        endDateSection.removeFromSuperview()
    }
    
    @objc func startDateChanged(_ picker: UIDatePicker) {
        viewModel.startDate = picker.date
    }

    @objc func endDateChanged(_ picker: UIDatePicker) {
        viewModel.endDate = picker.date
    }

}


import SwiftUI
struct MyViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        AddTaskViewController(viewModel: AddTaskViewModel())
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

#Preview {
    MyViewControllerPreview()
}
