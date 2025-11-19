//
//  TaskDetailViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 07/10/25.
//

import UIKit

enum TaskDetailMode {
    case instance(TaskInstance)
    case template(RoutineTask)
}

class TaskDetailViewController: UIViewController {
    private lazy var taskTemplate: RoutineTask = {
        switch mode {
        case .instance(let inst): return inst.template!
        case .template(let tpl): return tpl
        }
    }()
    
    private lazy var taskInstance: TaskInstance? = {
        switch mode {
        case .instance(let inst): return inst
        case .template(let tpl): return nil
        }
    }()
    
    var onEditTapped: ((TaskInstance) -> Void)?
    
    lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let mode: TaskDetailMode

    init(mode: TaskDetailMode) {
        self.mode = mode
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
        
        let time: UIView = {
            switch mode {
            case .instance(let inst):
                return InfoRowView(
                    title: "Horário",
                    info: DateFormatterHelper.hourFormatter(date: inst.time ?? .now),
                    isLate: inst.isLateDay || inst.isLatePeriod
                )
            case .template(let tpl):
                let label = StandardLabel(labelText: "Horários", labelFont: .sfPro, labelType: .callOut, labelColor: .black40)
                let times = makeTimesRow()
                
                let stack = UIStackView(arrangedSubviews: [label, times])
                stack.translatesAutoresizingMaskIntoConstraints = false
                return stack
            }
        }()
        let repetition = StandardLabel(labelText: "Repetição", labelFont: .sfPro, labelType: .callOut, labelColor: .black40)
        let period = InfoRowView(title: "Duração", info: makeTimeText())
        let notes = InfoRowView(title: "Observação", info: taskTemplate.note ?? "Observação")
        
        let dayRow = makeDayRow()
        
        vStack.addArrangedSubview(name)
        vStack.addArrangedSubview(time)
        vStack.addArrangedSubview(repetition)
        vStack.setCustomSpacing(6, after: repetition)
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
        navigationItem.title = "Tarefa"
        
        let closeButton = UIBarButtonItem(title: "Fechar", style: .done, target: self, action: #selector(closeTapped))
        closeButton.tintColor = .blue10
        navigationItem.leftBarButtonItem = closeButton
        
        let editButton = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(editTapped))
        editButton.tintColor = .blue10
        navigationItem.rightBarButtonItem = editButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationItem.scrollEdgeAppearance = appearance
        
    }
    
    private func makeDayRow() -> FlowLayoutView {
        var tags: [UIView] = []
        for day in taskTemplate.weekdays {
            let tag = DayTagView(text: day.localizedSymbol(style: .short).capitalized)
            tags.append(tag)
        }
        
        let row = FlowLayoutView(views: tags, maxWidth: view.bounds.width)
        return row
    }
    
    private func makeTimesRow() -> FlowLayoutView {
        var tags: [UIView] = []
        
        for time in taskTemplate.allTimes! {
            let tag = DayTagView(text: "\(time.hour):\(time.minute)")
            tags.append(tag)
        }
        
        let row = FlowLayoutView(views: tags, maxWidth: view.bounds.width)
        return row
    }
    
    
    private func makeTimeText() -> String {
        if let start = taskTemplate.startDate, let end = taskTemplate.endDate {
            let timeLabelText = "\(DateFormatterHelper.fullDayFormatter(date: start)) - \(DateFormatterHelper.fullDayFormatter(date: end))"
            
            return timeLabelText
            
        } else if let start = taskTemplate.startDate {
            let timeLabelText = "\(DateFormatterHelper.fullDayFormatter(date: start)) - Sem data final"
            
            return timeLabelText
        } else {
            return ""
        }
    }
    
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc func editTapped() {
        guard let taskInstance else { return }
        dismiss(animated: true)
        onEditTapped?(taskInstance)
    }
}

