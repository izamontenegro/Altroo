//
//  TodayTasksView.swift
//  Altroo
//
//  Created by Raissa Parente on 17/11/25.
//
import UIKit

final class TodayTasksView: UIView {
    var onSelectTask: ((TaskInstance) -> Void)?
    var onMarkDone: ((TaskInstance) -> Void)?
    
    var viewModel: AllTasksViewModel
    
    init(viewModel: AllTasksViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupContent()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupContent() {
        let periodStack = UIStackView()
        periodStack.axis = .vertical
        periodStack.spacing = 24
        periodStack.alignment = .fill
        periodStack.translatesAutoresizingMaskIntoConstraints = false
        
        for period in PeriodEnum.allCases {
            periodStack.addArrangedSubview(makeCardByPeriod(period))
        }
        
        addSubview(periodStack)
        
        NSLayoutConstraint.activate([
            periodStack.topAnchor.constraint(equalTo: topAnchor),
            periodStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            periodStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            periodStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            periodStack.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }
    
    func makeCardByPeriod(_ period: PeriodEnum) -> UIStackView {
        //HEADER
        let periodTag = CapsuleIconView(iconName: period.iconName, text: period.name)
        periodTag.backgroundColor = .blue30
        
        let timeLabel = StandardLabel(
            labelText: "\(period.startTime):00 até \(period.endTime):00",
            labelFont: .sfPro,
            labelType: .footnote,
            labelColor: .blue20)
        
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(periodTag)
        titleView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            periodTag.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            periodTag.topAnchor.constraint(equalTo: titleView.topAnchor),
            periodTag.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),

            timeLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            timeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: periodTag.trailingAnchor, constant: 8),
            timeLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
        ])
        
        let cardStack = UIStackView()
        cardStack.axis = .vertical
        cardStack.spacing = 16
        cardStack.distribution = .fill
        cardStack.alignment = .fill
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        
        cardStack.addArrangedSubview(titleView)
        
        let tasks = viewModel.filterTasksByPeriod(period)
        
        //EMPTY CONTENT
        guard !tasks.isEmpty else {
            let emptyCard = EmptyCardView(text: "Nenhuma tarefa foi criada para este período")
            cardStack.addArrangedSubview(emptyCard)
            return cardStack
        }

        //FILLED CONTENT
        for task in tasks {
            let card = TaskCard(task: task)
            card.delegate = self
            card.navigationDelegate = self

            card.translatesAutoresizingMaskIntoConstraints = false
            cardStack.addArrangedSubview(card)
            
            NSLayoutConstraint.activate([
                card.leadingAnchor.constraint(equalTo: cardStack.leadingAnchor),
                card.trailingAnchor.constraint(equalTo: cardStack.trailingAnchor)
            ])
        }
        
        return cardStack
    }


}

extension TodayTasksView: TaskCardDelegate, TaskCardNavigationDelegate {
    func taskCardDidMarkAsDone(_ task: TaskInstance) {
        onMarkDone?(task)
    }

    func taskCardDidSelect(_ task: TaskInstance) {
        onSelectTask?(task)
    }
}
