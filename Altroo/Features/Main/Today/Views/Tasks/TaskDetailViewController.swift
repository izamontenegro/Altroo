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

    
    let vStack: UIStackView = {
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
        
        let name = InfoRowView(title: "Nome", info: taskTemplate.name ?? "Nome")
        let time = InfoRowView(title: "Horário", info: DateFormatterHelper.hourFormatter(date: taskInstance.time ?? .now))
        let repetition = StandardLabel(labelText: "Repetition", labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .semibold)
        let period = InfoRowView(title: "Interval", info: makeTimeText())
        let notes = InfoRowView(title: "Notes", info: taskTemplate.note ?? "Observação")
        
        let dayRow = makeDayRow()
        
        vStack.addArrangedSubview(name)
        vStack.addArrangedSubview(time)
        vStack.addArrangedSubview(repetition)
        vStack.addArrangedSubview(dayRow)
        vStack.addArrangedSubview(period)
        vStack.addArrangedSubview(notes)
        
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
    }
    
    private func configureNavBar() {
        navigationItem.title = "Tarefa"
        
        let closeButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeTapped))
        closeButton.tintColor = .blue10
        navigationItem.leftBarButtonItem = closeButton
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(closeTapped))
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
                
        for day in Locale.Weekday.allCases {
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
