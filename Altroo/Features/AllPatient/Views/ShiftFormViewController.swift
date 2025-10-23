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

class ShiftFormViewController: GradientNavBarViewController {
    weak var delegate: ShiftFormsViewControllerDelegate?
    private let viewModel: AddPatientViewModel
    
    init(viewModel: AddPatientViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleSection = FormTitleSection(title: "Sobre você", description: "Preencha os campos a seguir quanto a seus dados pessoais e em relação ao assistido.", totalSteps: 3, currentStep: 1)
    
    private lazy var nameSection = FormSectionView(title: "Nome", content: nameTextField, isObligatory: true)
    private lazy var nameTextField = StandardTextfield(placeholder: "Nome do cuidador")

    private let allDayToggle: StandardToggle = {
        let toggle = StandardToggle()

        return toggle
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
    
    private lazy var startSection = FormSectionView(title: "Hora inicial", content: startTimePicker)
    private lazy var endSection = FormSectionView(title: "Hora final", content: endTimePicker)
    private lazy var allDaySection = FormSectionView(title: "Dia todo", content: allDayToggle)
    
    
    private lazy var relationshipSection = FormSectionView(title: "Qual a sua relação com o assistido?*", content: relationshipButton, isObligatory: true)
    private lazy var relationshipButton: PopupMenuButton = {
        let button = PopupMenuButton(title: viewModel.selectedRelationship)
        button.backgroundColor = .blue40
        
        return button
    }()
    
    private lazy var timeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startSection, endSection, allDaySection])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var timeSection = FormSectionView(title: "Em qual período deseja receber notificações do assistido?", content: timeStack, isObligatory: true)
    
    private let doneButton = StandardConfirmationButton(title: "Concluir")
    
    private lazy var formStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleSection, nameSection, timeSection, relationshipSection, doneButton])
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite
        
        setupNavBar()
        
        view.addSubview(formStack)
        NSLayoutConstraint.activate([
            formStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.mediumSpacing),
            formStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.mediumSpacing),
            formStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.mediumSpacing),
            doneButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }
    
    private func setupNavBar() {
        setNavbarTitle("Adicionar Paciente")
    }
    
    //TODO: ADAPT TO TOGGLE
    @objc private func didTapAllDayButton() {
        let isAllDay = startTimePicker.isEnabled
        startTimePicker.isEnabled = !isAllDay
        endTimePicker.isEnabled = !isAllDay
        
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
