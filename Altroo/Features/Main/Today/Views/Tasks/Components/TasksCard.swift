//
//  TasksListCard.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 20/10/25.
//

import UIKit

protocol TasksCardDelegate: AnyObject {
    func didTapTask(_ task: TaskInstance, on card: TasksCard)
}

class TasksCard: UIView {
    
    var tasks: [TaskInstance]
    weak var delegate: TasksCardDelegate?
    
    private let vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(tasks: [TaskInstance]) {
        self.tasks = tasks
        super.init(frame: .zero)
        setupUI()
        makeContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    
    private func makeContent() {
        if tasks.isEmpty {
            let emptyLabel = StandardLabel(
                labelText: "today_empty_tasks".localized,
                labelFont: .sfPro,
                labelType: .callOut,
                labelColor: .black30
            )
            vStack.addArrangedSubview(emptyLabel)
            vStack.alignment = .center
            return
        }
        
        for (index, task) in tasks.enumerated() {
            let taskCard = TaskCard(task: task)
            taskCard.tag = index
//            taskCard.cardTapAction = { [weak self] in
//                guard let self else { return }
//                self.delegate?.didTapTask(task, on: self)
//            }
            vStack.addArrangedSubview(taskCard)
        }
    }
    
    func updateTasks(_ newTasks: [TaskInstance]) {
        self.tasks = newTasks
        vStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        makeContent()
    }
}
