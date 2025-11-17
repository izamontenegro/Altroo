//
//  LateTasksView.swift
//  Altroo
//
//  Created by Raissa Parente on 17/11/25.
//
import UIKit

final class LateTasksView: UIView {
    init(viewModel: AllTasksViewModel) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupContent(with: viewModel)
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupContent(with viewModel: AllTasksViewModel) {
        let dayStack = UIStackView()
        dayStack.axis = .vertical
        dayStack.spacing = 16
        dayStack.alignment = .fill
        dayStack.translatesAutoresizingMaskIntoConstraints = false
        

        for day in viewModel.daysOfLateTasks {
            dayStack.addArrangedSubview(makeLateCardByDay(day, with: viewModel))
        }
        
        addSubview(dayStack)
        
        NSLayoutConstraint.activate([
            dayStack.topAnchor.constraint(equalTo: topAnchor),
            dayStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            dayStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayStack.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }
    
    func makeLateCardByDay(_ day: Date, with viewModel: AllTasksViewModel) -> UIStackView {
        //HEADER
        let dayLabel = StandardLabel(
            labelText: "\(DateFormatterHelper.historyDateNumber(from: day)) - \(DateFormatterHelper.historyWeekdayShort(from: day))",
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .pureWhite)
        
        let titleView = UIView()
        titleView.backgroundColor = .blue50
        titleView.layer.cornerRadius = 4
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(dayLabel)
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 12),
            dayLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 10),
            dayLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -10),
        ])
        
        let cardStack = UIStackView()
        cardStack.axis = .vertical
        cardStack.spacing = 8
        cardStack.distribution = .fill
        cardStack.alignment = .fill
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        
        cardStack.addArrangedSubview(titleView)
        
        //CONTENT
        let tasks = viewModel.filterLateTasksByDay(day)

        for task in tasks {
            let card = TaskCard(task: task)
//            card.delegate = self

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
