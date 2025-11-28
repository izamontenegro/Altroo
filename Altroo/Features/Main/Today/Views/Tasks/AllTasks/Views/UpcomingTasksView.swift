//
//  UpcomingTasksView.swift
//  Altroo
//
//  Created by Raissa Parente on 18/11/25.
//
import UIKit

final class UpcomingTasksView: UIView {
    var onSelectTask: ((RoutineTask) -> Void)?
    
    var taskStack: UIStackView = {
        let taskStack = UIStackView()
        taskStack.axis = .vertical
        taskStack.spacing = 16
        taskStack.alignment = .fill
        taskStack.translatesAutoresizingMaskIntoConstraints = false
        return taskStack
    }()
    
    init(viewModel: AllTasksViewModel) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupContent(with: viewModel)
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupContent(with viewModel: AllTasksViewModel) {
        let taskStack = UIStackView()
        taskStack.axis = .vertical
        taskStack.spacing = 16
        taskStack.alignment = .fill
        taskStack.translatesAutoresizingMaskIntoConstraints = false
        
        if viewModel.upcomingTasks.isEmpty {
            let emptyCard = EmptyCardView(text: "no_future_task".localized)
            taskStack.addArrangedSubview(emptyCard)

        } else {
            for task in viewModel.upcomingTasks {
                let card = UpcomingTaskCard(task: task)
                card.navigationDelegate = self
                taskStack.addArrangedSubview(card)
            }
        }
        
        addSubview(taskStack)
        
        NSLayoutConstraint.activate([
            taskStack.topAnchor.constraint(equalTo: topAnchor),
            taskStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            taskStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            taskStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            taskStack.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }

}

extension UpcomingTasksView: TaskTemplateNavigationDelegate {
    func taskTemplateDidSelect(_ template: RoutineTask) {
        onSelectTask?(template)
    }
}
