//
//  AddRoutineActivityViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 29/09/25.
//

import UIKit
import Combine

protocol AddTaskNavigationDelegate: AnyObject {
    func didFinishAddingTask()
}

class AddTaskViewController: TaskFormViewController {
    var viewModel: AddTaskViewModel
    weak var coordinator: TodayCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: AddTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .pureWhite
        
        configure(title: "Registrar Tarefa", subtitle: "Registre uma atividade a ser feita e sua duração ou repetições durante a semana.", confirmButtonText: "Adicionar")
        bindViewModel()
        setupContinuousButton()
        setupRepeatingDays()
        setupTimes()
        setupContent()
        
        confirmButton.addTarget(self, action: #selector(didFinishCreating), for: .touchUpInside)
        
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
    
    //MARK: - LOCAL SETUP
    func setupContinuousButton() {
        let button = PopupMenuButton(title: viewModel.continuousButtonTitle)
        insertContinuousPicker(button, showEndDate: !viewModel.isContinuous)
        continuousButton.showsMenuAsPrimaryAction = true
        continuousButton.changesSelectionAsPrimaryAction = true
        
        rebuildContinuousButton()
    }
    
    func rebuildContinuousButton() {
        let actions: [UIAction] = viewModel.continuousOptions.map { option in
            let isSelected = (option == viewModel.continuousOptions[0]) == viewModel.isContinuous
            
            return UIAction(title: option, state: isSelected ? .on : .off) { [weak self] action in
                guard let self else { return }
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
        addTimeAction()
        addTimeButton.addTarget(self, action: #selector(addTimeButtonTapped(_:)), for: .touchUpInside)
    }
    
    func addTimeAction(date: Date = .now) {
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
        viewModel.addTime(from: date)
    }
    
    
    //MARK: - ACTIONS
    @objc func addTimeButtonTapped(_ sender: UIButton) {
        addTimeAction()
    }
    
    @objc override func startDateChanged(_ picker: UIDatePicker) {
        viewModel.startDate = picker.date
    }
    
    @objc override func endDateChanged(_ picker: UIDatePicker) {
        viewModel.endDate = picker.date
    }
    
    @objc func timeChanged(_ sender: UIDatePicker) {
        let index = sender.tag
        guard index < viewModel.times.count else { return }
        viewModel.addTime(from: sender.date, at: index)
    }
    
    @objc func didFinishCreating() {
        viewModel.createTask()
        coordinator?.didFinishAddingTask()
    }
}
