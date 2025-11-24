//
//  TaskDetailViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 07/10/25.
//

import UIKit

class TaskDetailViewController: UIViewController {
    var taskInstance: TaskInstance
    var taskTemplate: RoutineTask
    
    var onEditTapped: ((TaskInstance) -> Void)?
    
    lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(task: TaskInstance) {
        self.taskInstance = task
        self.taskTemplate = task.template!
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        let name = InfoRowView(title: "name".localized, info: taskTemplate.name ?? "name".localized)
        let time = InfoRowView(title: String(localized: "time"), info: DateFormatterHelper.hourFormatter(date: taskInstance.time ?? .now))
        let repetition = StandardLabel(labelText: "Repetição", labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .semibold)
        let period = InfoRowView(title: "Intervalo", info: makeTimeText())
        let notes = InfoRowView(title: "observation".localized, info: taskTemplate.note ?? "observation".localized)
        
        let dayRow = makeDayRow()
        
        vStack.addArrangedSubview(name)
        vStack.addArrangedSubview(time)
        vStack.addArrangedSubview(repetition)
        vStack.addArrangedSubview(dayRow)
        vStack.addArrangedSubview(period)
        vStack.addArrangedSubview(notes)
        
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.mediumSpacing),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.mediumSpacing),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.mediumSpacing),
        ])
    }
    
    private func configureNavBar() {
        navigationItem.title = "task".localized
        
        let closeButton = UIBarButtonItem(title: "close".localized, style: .done, target: self, action: #selector(closeTapped))
        closeButton.tintColor = .blue10
        navigationItem.leftBarButtonItem = closeButton
        
        let editButton = UIBarButtonItem(title: "edit".localized, style: .plain, target: self, action: #selector(editTapped))
        editButton.tintColor = .blue10
        navigationItem.rightBarButtonItem = editButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationItem.scrollEdgeAppearance = appearance
        
    }
    
    private func makeDayRow() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for day in Locale.Weekday.allWeekDays {
            //TODO: CHANGE FROM BUTTONS TO TAG
            let tag = PrimaryStyleButton(title: day.rawValue.first!.uppercased())
            if taskTemplate.daysOfTheWeek!.contains(day.rawValue) {
                tag.backgroundColor = .blue30
            } else {
                tag.backgroundColor = .black40
            }
            stackView.addArrangedSubview(tag)
        }
        
        return stackView
    }
    
    private func makeTimeText() -> String {
        if let start = taskTemplate.startDate, let end = taskTemplate.endDate {
            let timeLabelText = "\(DateFormatterHelper.fullDayFormatter(date: start)) - \(DateFormatterHelper.fullDayFormatter(date: end))"
            
            return timeLabelText
            
        } else if let start = taskTemplate.startDate {
            let timeLabelText = "\(DateFormatterHelper.fullDayFormatter(date: start)) - Contínuo"
            
            return timeLabelText
        } else {
            return ""
        }
    }
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc func editTapped() {
        dismiss(animated: true)
        onEditTapped?(taskInstance)
    }
}

//#Preview {
//    TaskDetailViewController(task: MockTask(
//        name: "Administer medications",
//        note: "Check medication log for proper dosage and timing.",
//        reminder: true,
//        time: Calendar.current.date(from: DateComponents(hour: 7, minute: 30))!,
//        daysOfTheWeek: [.friday, .sunday],
//        startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 10))!,
//        endDate: nil
//    )
//    )
//}
