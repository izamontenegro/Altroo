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
        
        configure(title: "add_task".localized, subtitle: "task_subtitle".localized, confirmButtonText: "add".localized, continuousButtonTitle: viewModel.continuousButtonTitle)
        rebuildContinuousButton()
        bindViewModel()
        setupRepeatingDays()
        setupTimes()
        
        confirmButton.addTarget(self, action: #selector(didFinishCreating), for: .touchUpInside)
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
                
                viewModel.endDate = isContinuous ? nil : .now
                reloadDurationSection(startDate: viewModel.startDate, endDate: viewModel.endDate)
            }
            .store(in: &cancellables)
        
        //validation
        viewModel.$fieldErrors
            .receive(on: RunLoop.main)
            .sink { [weak self] errors in
                self?.nameSection.setError(errors["name"])
                self?.startSection.setError(errors["date"])
            }
            .store(in: &cancellables)
    }
    
    //MARK: - LOCAL SETUP
    
    //DATE
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
    
    
    //MARK: -TIME
    func setupTimes() {
        addTimeAction()
        addTimeButton.addTarget(self, action: #selector(addTimeButtonTapped(_:)), for: .touchUpInside)
    }
    
    func addTimeAction() {
        viewModel.addTime(from: .now)
        rebuildTimeViews()
    }
    
    func rebuildTimeViews() {
        //reset everything
        addTimeViews.removeAll()
        for view in timePickersFlowView.subviews {
            view.removeFromSuperview()
        }
        addTimeButton.removeFromSuperview()

        let count = viewModel.times.count

        //create all timepickers
        for (index, time) in viewModel.times.enumerated() {
            let picker = UIDatePicker.make(mode: .time)
            if let date = Calendar.current.date(from: time) {
                picker.date = date
            }
            picker.tag = index
            picker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
            addTimeViews.append(picker)
        }

        if count == 1 {
            // only one timepicker - inline add button
            addTimeViews.append(addTimeButton)
            
            if hourStack.arrangedSubviews.contains(addTimeButton) {
                       hourStack.removeArrangedSubview(addTimeButton)
                       addTimeButton.removeFromSuperview()
           }
            
            deleteTimeButton.removeFromSuperview()

        } else {
            //more than one timepicker - inline minus button/downline add button
            addTimeViews.append(deleteTimeButton)


            if !hourStack.arrangedSubviews.contains(addTimeButton) {
               hourStack.addArrangedSubview(addTimeButton)
            }
        }

        timePickersFlowView.reload(with: addTimeViews)
    }

    func removeAddTimeButton() {
        addTimeViews.removeLast()
        addTimeButton.removeFromSuperview()
    }
    
    func removeDeleteTimeButton() {
        addTimeViews.removeLast()
        deleteTimeButton.removeFromSuperview()
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
    
    @objc override func didDeleteLastTime() {
        guard viewModel.times.count > 1 else { return }
        
        viewModel.times.removeLast()  //remove actual date
        rebuildTimeViews()
    }
    
    @objc func timeChanged(_ sender: UIDatePicker) {
        let index = sender.tag
        guard index < viewModel.times.count else { return }
        viewModel.addTime(from: sender.date, at: index)
    }
    
    @objc func didFinishCreating() {
        guard viewModel.validateTask() else { return }
        
        viewModel.createTask()
        coordinator?.didFinishAddingTask()
    }
}
