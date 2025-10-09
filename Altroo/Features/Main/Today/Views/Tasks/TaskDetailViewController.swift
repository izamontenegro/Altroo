//
//  TaskDetailViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 07/10/25.
//

import UIKit

class TaskDetailViewController: UIViewController {
    var task: MockTask
    
    let vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(task: MockTask) {
        self.task = task
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
        
        let name = InfoRowView(title: "Name", info: task.name)
        let time = InfoRowView(title: "Time", info: DateFormatterHelper.hourFormatter(date: task.time))
        let repetition = StandardLabel(labelText: "Repetition", labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .semibold)
        let period = InfoRowView(title: "Interval", info: task.period.rawValue.capitalized)
        let notes = InfoRowView(title: "Notes", info: task.note)
        
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
    
    func configureNavBar() {
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
    
    func makeDayRow() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
//        stackView.spacing = 11
        stackView.translatesAutoresizingMaskIntoConstraints = false
                
        for day in Locale.Weekday.allCases {
            //TODO: CHANGE FROM BUTTONS TO TAG
            let tag = PrimaryStyleButton(title: day.rawValue.first!.uppercased())
            if task.daysOfTheWeek.contains(day) {
                tag.backgroundColor = .blue30
            } else {
                tag.backgroundColor = .black40
            }
            stackView.addArrangedSubview(tag)
        }
        
        return stackView
    }
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc func editTapped() {
        dismiss(animated: true)
    }
}

#Preview {
    TaskDetailViewController(task: MockTask(
        name: "Ensure home is secure",
        note: "Lock doors, turn off lights, and set the alarm.",
        period: .night,
        frequency: "Daily",
        reminder: true,
        time: Date(),
        daysOfTheWeek: [.monday, .friday, .saturday, .thursday]
    ))
}
