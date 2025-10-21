//
//  ShiftFormViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 30/09/25.
//

import UIKit

protocol ShiftFormsViewControllerDelegate: AnyObject {
    func shiftFormsDidFinish()
}

class ShiftFormViewController: UIViewController {
    weak var delegate: ShiftFormsViewControllerDelegate?
    private let viewModel: AddPatientViewModel
    
    init(viewModel: AddPatientViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let label1 = StandardLabel(
        labelText: "Em quais horários você vai cuidar de seu assistido?",
        labelFont: .sfPro,
        labelType: .title3,
        labelColor: .black10,
        labelWeight: .semibold
    )
        
    private let doneButton = StandardConfirmationButton(title: "Criar")
    
    private let allDayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("O dia todo", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black40
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 38).isActive = true
        return button
    }()
    
    private let startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let endTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var startSection = FormSectionView(title: "Início", content: startTimePicker)
    private lazy var endSection = FormSectionView(title: "Término", content: endTimePicker)
    
    private lazy var timeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startSection, endSection])
        stack.axis = .horizontal
        stack.spacing = 24
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var formStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label1, timeStack, allDayButton, doneButton])
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite
        
        label1.numberOfLines = 0
        label1.lineBreakMode = .byWordWrapping
        label1.updateLabelText("Em quais horários você vai cuidar de \(viewModel.name)?")
        
        view.addSubview(formStack)
        NSLayoutConstraint.activate([
            formStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            formStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            formStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            doneButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        allDayButton.addTarget(self, action: #selector(didTapAllDayButton), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }
    
    @objc private func didTapAllDayButton() {
        let isAllDay = startTimePicker.isEnabled
        startTimePicker.isEnabled = !isAllDay
        endTimePicker.isEnabled = !isAllDay
        allDayButton.backgroundColor = isAllDay ? .teal20 : .black40
        allDayButton.setTitleColor(isAllDay ? .white : .white, for: .normal)
        
        viewModel.setShift([.afternoon, .overnight, .morning, .night])
    }
    
    @objc
    func didTapDoneButton() {
        if startTimePicker.isEnabled {
            let start = startTimePicker.date
            let end = endTimePicker.date
            let periods = PeriodEnum.shifts(for: start, end: end)
            viewModel.setShift(periods)
        }
        
        viewModel.finalizeCareRecipient()
        delegate?.shiftFormsDidFinish()
    }
}

//#Preview {
//    let mockService = UserServiceSession(context: AppDependencies().coreDataService.stack.context)
//
//    ShiftFormViewController(viewModel: AddPatientViewModel(careRecipientFacade: CareRecipientFacade(basicNeedsFacade: BasicNeedsFacadeMock(), routineActivitiesFacade: RoutineActivitiesFacadeMock(), persistenceService: CoreDataServiceMock()), userService: mockService))
//}
