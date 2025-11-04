//
//  EditTasksViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 16/10/25.
//
import UIKit
import Combine

class EditTaskViewController: TaskFormViewController {
    weak var coordinator: TodayCoordinator?
    var viewModel: EditTaskViewModel
    private var cancellables = Set<AnyCancellable>()

    
    init(viewModel: EditTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
        setupContinuousButton()
        setupRepeatingDays()
        setupTimes()
        configure(title: "Editar Tarefa", subtitle: "Registre uma atividade a ser feita e sua duração ou repetições durante a semana.", confirmButtonText: "Salvar", showDelete: true)
        bindViewModel()
        
        confirmButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
    }
    
    func bindViewModel() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: nameTexfield)
            .compactMap { ($0.object as? UITextField)?.text }
            .assign(to: \.name, on: viewModel)
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: noteTexfield)
            .compactMap { ($0.object as? UITextField)?.text }
            .assign(to: \.note, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.$name
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                self?.nameTexfield.text = name
            }
            .store(in: &cancellables)
        
        viewModel.$note
            .receive(on: DispatchQueue.main)
            .sink { [weak self] note in
                self?.noteTexfield.textView.text = note
            }
            .store(in: &cancellables)
        
        viewModel.$startDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                self?.startDatePicker.date = date
            }
            .store(in: &cancellables)
        
        viewModel.$endDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                if let date {
                    self?.endDatePicker.date = date
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isContinuous
            .receive(on: RunLoop.main)
            .sink { [weak self] isContinuous in
                guard let self else { return }
                self.continuousButton.setTitle(self.viewModel.continuousButtonTitle, for: .normal)
                
                self.rebuildContinuousButton()
                
                if isContinuous {
                    removeEndDate()
                } else {
                    addEndDate()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$repeatingDays
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weekdays in
                guard let self else { return }
                
                self.weekdayRow.updateSelectedDays(weekdays)
            }
            .store(in: &cancellables)
    }
    
    func setupContinuousButton() {
        let button = PopupMenuButton(title: viewModel.continuousButtonTitle)
        insertContinuousPicker(button, showEndDate: viewModel.isContinuous)
        continuousButton.showsMenuAsPrimaryAction = true
        continuousButton.changesSelectionAsPrimaryAction = true
        
        rebuildContinuousButton()
    }
    
    func rebuildContinuousButton() {
        let actions: [UIAction] = viewModel.continuousOptions.map { option in
            let isSelected: Bool
            if option == viewModel.continuousOptions[0] {
                isSelected = viewModel.isContinuous
            } else {
                isSelected = !viewModel.isContinuous
            }
            
            return UIAction(title: option, state: isSelected ? .on : .off) { [weak self] action in
                guard let self else { return }
                //state
                self.viewModel.isContinuous = (action.title == self.viewModel.continuousOptions[0])
            }
        }
        
        continuousButton.menu = UIMenu(options: .singleSelection, children: actions)
    }
    
    func setupRepeatingDays() {
        weekdayRow.didSelectDay = { [weak self] day, isSelected in
            guard let self else { return }
            if isSelected {
                self.viewModel.repeatingDays.append(day)
            } else {
                self.viewModel.repeatingDays.removeAll { $0 == day }
            }
        }
    }
    
    func setupTimes() {
        for components in viewModel.times {
            if let date = Calendar.current.date(from: components) {
                addTimeAction(date: date, isInitial: true)
            }
        }
        
        addTimeButton.addTarget(self, action: #selector(addTimeButtonTapped(_:)), for: .touchUpInside)
    }
    
    func addTimeAction(date: Date = .now, isInitial: Bool = false) {
        let newPicker = UIDatePicker.make(mode: .time)
        newPicker.date = date
        newPicker.tag = hourPickers.count
        newPicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
        
        if let _ = hourStack.arrangedSubviews.last as? PrimaryStyleButton {
            hourStack.insertArrangedSubview(newPicker, at: hourStack.arrangedSubviews.count - 1)
        } else {
            hourStack.addArrangedSubview(newPicker)
        }
        hourPickers.append(newPicker)
        
        
        if !isInitial {
            let index = viewModel.times.count
            viewModel.addTime(from: newPicker.date)
        }

    }
    
    @objc func timeChanged(_ sender: UIDatePicker) {
        let index = sender.tag
        
        if index < viewModel.times.count {
           viewModel.addTime(from: sender.date, at: index)
        }
    }
    
    @objc override func startDateChanged(_ picker: UIDatePicker) {
        viewModel.startDate = picker.date
    }
    
    @objc override func endDateChanged(_ picker: UIDatePicker) {
        viewModel.endDate = picker.date
    }
    
    @objc func addTimeButtonTapped(_ sender: UIButton) {
        addTimeAction()
    }
    
    @objc private func saveChanges() {
        guard viewModel.updateTask() else { return }
        coordinator?.goToRoot()
    }
    
    @objc private func deleteTask() {
        viewModel.deleteTask()
        coordinator?.goToRoot()
    }
}

