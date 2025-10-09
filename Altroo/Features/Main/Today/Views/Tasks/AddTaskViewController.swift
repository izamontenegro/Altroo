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
    
    let titleLabel = StandardLabel(labelText: "Adicionar Tarefas", labelFont: .sfPro, labelType: .title2, labelColor: .black, labelWeight: .semibold)
    
    let addButton = StandardConfirmationButton(title: "Adicionar")
    
    let nameTexfield = StandardTextfield()
    let noteTexfield = StandardTextfield()
    
    var hourPickers: [UIDatePicker] = []
    let addTimeButton = PrimaryStyleButton(title: "Novo Horário")
    
    let startDatePicker: UIDatePicker = UIDatePicker.make(mode: .date)
    
    var endDateSection: UIView!
    
    let endDatePicker: UIDatePicker = UIDatePicker.make(mode: .date)
    
    let hourStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    let contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fill
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
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            contentStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    
    func setupContent() {
        view.addSubview(contentStack)
        //name
        nameTexfield.placeholder = "Nome da tarefa"
        let nameSection = FormSectionView(title: "Nome", content: nameTexfield)
        contentStack.addArrangedSubview(nameSection)
        
        //time
        let hourSection = makeHourSection()
        contentStack.addArrangedSubview(hourSection)
        
        //repeat
        let weekdayRow = makeDayRow()
        let repeatSection = FormSectionView(title: "Repetir", content: weekdayRow)
        contentStack.addArrangedSubview(repeatSection)
        
        //duration
        //start
        startDatePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
        let startSection = FormSectionView(title: "Início", content: startDatePicker)
        //end
        endDatePicker.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)
        endDateSection = FormSectionView(title: "Término", content: endDatePicker)
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
        
        let durationSection = FormSectionView(title: "Duração", content: continuousButton)
        
        //stack
        dateStack.addArrangedSubview(startSection)
        dateStack.addArrangedSubview(durationSection)
        contentStack.addArrangedSubview(dateStack)
        
        
        //notes
        noteTexfield.placeholder = "Enter observations"
        let noteSection = FormSectionView(title: "Observações", content: noteTexfield)
        contentStack.addArrangedSubview(noteSection)
        
    }
    
    func makeDayRow() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for day in Locale.Weekday.allCases {
            let button = PrimaryStyleButton(title: day.rawValue.first!.uppercased())
            button.backgroundColor = .black40
            
            button.associatedData = day
            button.addTarget(self, action: #selector(didClickDayButton(_:)), for: .touchUpInside)
            
            
            stackView.addArrangedSubview(button)
        }
        
        return stackView
    }
    
    func makeHourSection() -> UIStackView {
        let hourSection = FormSectionView(title: "Horário", content: hourStack)
 
        addTimeButton.addTarget(self, action: #selector(didAddTime), for: .touchUpInside)
        hourStack.addArrangedSubview(addTimeButton)
        return hourSection
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
    
    @objc func timeChanged(_ sender: UIDatePicker) {
        let index = sender.tag
        guard index < viewModel.times.count else { return }
        viewModel.times[index] = sender.date
    }
    
    @objc func didClickDayButton(_ sender: PrimaryStyleButton) {
        let day = sender.associatedData as! Locale.Weekday
        
        if viewModel.repeatingDays.contains(day) {
            viewModel.repeatingDays.removeAll(where: {$0 == day})
            sender.backgroundColor = .black40

        } else {
            viewModel.repeatingDays.append(sender.associatedData as! Locale.Weekday)
            sender.backgroundColor = .teal20
        }

        print(viewModel.repeatingDays)
    }
    
    @objc func didAddTime() {
        let newPicker = UIDatePicker.make(mode: .time)
        
        let index = viewModel.times.count
        newPicker.tag = index
        
        viewModel.times.append(newPicker.date)
        
        newPicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
        
        if let addTimeButton = hourStack.arrangedSubviews.last {
            hourStack.insertArrangedSubview(newPicker, at: hourStack.arrangedSubviews.count - 1)
        } else {
            hourStack.addArrangedSubview(newPicker)
        }
        
        hourPickers.append(newPicker)
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




