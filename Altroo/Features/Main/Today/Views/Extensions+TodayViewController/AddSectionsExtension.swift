//
//  AddSectionsExtension.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/11/25.
//

import UIKit

extension TodayViewController {
    func addSections() {
        var configs = TodaySectionManager.shared.load()
        
        if configs.isEmpty || configs.first(where: { $0.type == .basicNeeds })?.subitems == nil {
            let defaultSubitems = [
                SubitemConfig(title: "feeding".localized, isVisible: true),
                SubitemConfig(title: "hydration".localized, isVisible: true),
                SubitemConfig(title: "stool".localized, isVisible: true),
                SubitemConfig(title: "urine".localized, isVisible: true)
            ]
            let basicNeedsConfig = TodaySectionConfig(
                type: .basicNeeds,
                isVisible: true,
                order: 0,
                subitems: defaultSubitems
            )
            let tasksConfig = TodaySectionConfig(
                type: .tasks,
                isVisible: true,
                order: 1,
                subitems: nil
            )
            let intercurrencesConfig = TodaySectionConfig(
                type: .intercurrences,
                isVisible: true,
                order: 2,
                subitems: nil
            )
            configs = [basicNeedsConfig, tasksConfig, intercurrencesConfig]
            TodaySectionManager.shared.save(configs)
        }
        
        vStack.arrangedSubviews.forEach {
            vStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        for config in configs.sorted(by: { $0.order < $1.order }) {
            guard config.isVisible else { continue }
            
            switch config.type {
            case .basicNeeds:
                let section = BasicNeedsSectionBuilder(
                    viewModel: viewModel,
                    delegate: delegate,
                    feedingRecords: feedingRecords
                ).build(from: config)
                
                vStack.addArrangedSubview(StandardLabel(
                    labelText: "today_section_basic_needs".localized,
                    labelFont: .sfPro,
                    labelType: .title2,
                    labelColor: .black10,
                    labelWeight: .semibold
                ))
                vStack.addArrangedSubview(section)
                
            case .tasks:
                let taskHeader = TaskHeader()
                taskHeader.delegate = self
                vStack.addArrangedSubview(taskHeader)
                vStack.addArrangedSubview(makeCardByPeriod())
                
            case .intercurrences:
                let symptomHeader = IntercurrenceHeader()
                symptomHeader.delegate = self
                vStack.addArrangedSubview(symptomHeader)
                vStack.addArrangedSubview(symptomsCard)
            }
        }
    }
    
    func makeCardByPeriod() -> UIView {
        let cardStack = UIStackView()
        cardStack.axis = .vertical
        cardStack.spacing = 16
        cardStack.alignment = .fill
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        
        let tasks = viewModel.periodTasks
        
        if tasks.isEmpty {
            let emptyCard = EmptyCardView(text: "")
            let normalText = "today_empty_tasks".localized
            let normalString = NSMutableAttributedString(string:normalText)

            let boldText = PeriodEnum.current.name
            let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]
            let boldString = NSMutableAttributedString(string:boldText, attributes:attrs)

            normalString.append(boldString)
            
            emptyCard.label.attributedText = normalString
            cardStack.addArrangedSubview(emptyCard)
        } else {
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
        }
        
        return cardStack
    }
}
