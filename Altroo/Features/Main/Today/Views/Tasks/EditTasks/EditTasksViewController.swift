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

        setupRepeatingDays()
        setupTimes()
        configure(title: "edit_task".localized, subtitle: "task_subtitle".localized, confirmButtonText: "save".localized, continuousButtonTitle: viewModel.continuousButtonTitle)
        rebuildContinuousButton()
        bindViewModel()
        configureNavBar()
        
        confirmButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
    }
    
    private func configureNavBar() {
        let closeButton = UIBarButtonItem(title: "close".localized, style: .done, target: self, action: #selector(closeTapped))
        closeButton.tintColor = .blue20
        navigationItem.leftBarButtonItem = closeButton
        
        let deleteButton = UIBarButtonItem(title: "delete".localized, style: .done, target: self, action: #selector(deleteTapped))
        deleteButton.tintColor = .red20
        navigationItem.rightBarButtonItem = deleteButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
    @objc func deleteTapped() {
        presentDeleteAlert()
    }
    
    func presentDeleteAlert() {
        let alertController = UIAlertController(
            title: "delete_task_confirmation_title".localized,
            message: "delete_task_confirmation_msg".localized,
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "delete".localized, style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            viewModel.deleteTask()
            dismiss(animated: true)
            coordinator?.goToRoot()
        }
        
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
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
                
                viewModel.endDate = isContinuous ? nil : .now
                reloadDurationSection(startDate: viewModel.startDate, endDate: viewModel.endDate)

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
    
    //TIME
    func setupTimes() {
        rebuildTimeViews()
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
}

