//
//  ShiftFormViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 30/09/25.
//

import UIKit
import Combine

protocol ShiftFormsViewControllerDelegate: AnyObject {
    func shiftFormsDidFinish()
}

class ShiftFormViewController: GradientNavBarViewController {
    private var cancellables = Set<AnyCancellable>()

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
        toggle.setContentHuggingPriority(.required, for: .horizontal)
        toggle.setContentCompressionResistancePriority(.required, for: .horizontal)
        toggle.contentHorizontalAlignment = .leading

        return toggle
    }()
    
    private let startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.setContentHuggingPriority(.required, for: .horizontal)
        picker.setContentCompressionResistancePriority(.required, for: .horizontal)
        picker.contentHorizontalAlignment = .leading
        return picker
    }()
    
    private let endTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.setContentHuggingPriority(.required, for: .horizontal)
        picker.setContentCompressionResistancePriority(.required, for: .horizontal)
        picker.contentHorizontalAlignment = .leading
        return picker
    }()
    
    private lazy var startSection = FormSectionView(title: "Hora inicial", content: startTimePicker)
    private lazy var endSection = FormSectionView(title: "Hora final", content: endTimePicker)
    private lazy var allDaySection = FormSectionView(title: "Dia inteiro", content: allDayToggle)
    
    
    private lazy var relationshipSection = FormSectionView(title: "Qual a sua relação com o assistido?", content: relationshipButton, isObligatory: true)
    private lazy var relationshipButton: PopupMenuButton = {
        let button = PopupMenuButton(title: viewModel.selectedRelationship)
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.backgroundColor = .blue40
        
        let actions: [UIAction] = viewModel.relationshipOptions.map { option in
            let isSelected = (option == viewModel.selectedRelationship)
            return UIAction(title: option, state: isSelected ? .on : .off) { [weak self] action in
                guard let self else { return }
                self.viewModel.selectedRelationship = action.title
                
                self.relationshipButton.setTitle(action.title, for: .normal)
            }
        }
        
        button.menu = UIMenu(options: .singleSelection, children: actions)
        
        return button
    }()
    
    private lazy var timeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startSection, endSection, allDaySection])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var timeSection = FormSectionView(title: "Em qual período deseja receber notificações do assistido?", content: timeStack)
    
    private let doneButton = StandardConfirmationButton(title: "Concluir")
    
    private lazy var formStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleSection, nameSection, timeSection, relationshipSection])
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite
        
        setupNavBar()
        bindViewModel()
        
        view.addSubview(formStack)
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            formStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.mediumSpacing),
            formStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.mediumSpacing),
            formStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.mediumSpacing),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.mediumSpacing),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupNavBar() {
        setNavbarTitle("Adicionar Paciente")
    }
    
    private func bindViewModel() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: nameTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .assign(to: \.userName, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.$selectedRelationship
               .receive(on: RunLoop.main)
               .sink { [weak self] newValue in
                   self?.relationshipButton.setTitle(newValue, for: .normal)
               }
               .store(in: &cancellables)
        
        viewModel.$userNameError
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.nameSection.setError(error)
            }
            .store(in: &cancellables)
    }

    
    //TODO: ADAPT TO TOGGLE
    @objc private func didTapAllDayButton() {
        let isAllDay = startTimePicker.isEnabled
        startTimePicker.isEnabled = !isAllDay
        endTimePicker.isEnabled = !isAllDay
        
        viewModel.isAllDay.toggle()
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    func didTapDoneButton() {
        guard viewModel.validateUser() else { return }

        viewModel.finalizeUser(startDate: startTimePicker.date, endDate: endTimePicker.date)
        viewModel.finalizeCareRecipient()
        delegate?.shiftFormsDidFinish()
    }
}

extension ShiftFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//#Preview {
//    let mockService = UserServiceSession(context: AppDependencies().coreDataService.stack.context)
//
//    ShiftFormViewController(viewModel: AddPatientViewModel(careRecipientFacade: CareRecipientFacade(basicNeedsFacade: BasicNeedsFacadeMock(), routineActivitiesFacade: RoutineActivitiesFacadeMock(), persistenceService: CoreDataServiceMock()), userService: mockService))
//}
