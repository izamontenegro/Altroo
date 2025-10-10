//
//  AllTasksViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//

import UIKit
import Combine

class AllTasksViewController: GradientNavBarViewController {
    let viewModel: AllTasksViewModel
    var onTaskSelected: ((RoutineTask) -> Void)?
    
    let titleLabel = StandardLabel(labelText: "Shifts", labelFont: .sfPro, labelType: .title2, labelColor: .black, labelWeight: .semibold)
    
    let descriptionLabel = StandardLabel(labelText: "Confira os tarefas cadastradas no sistema ou adicione uma nova tarefa para visualizá-la aqui.", labelFont: .sfPro, labelType: .body, labelColor: .black, labelWeight: .regular)
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    init(viewModel: AllTasksViewModel, onTaskSelected: ((RoutineTask) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onTaskSelected = onTaskSelected
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue80
        
        makeContent()
    }
    
    func makeTitle() {
        descriptionLabel.numberOfLines = 0
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
        ])
    }
    
    func makeContent() {
        view.addSubview(scrollView)
        makeTitle()
        
        let periodStack = UIStackView()
        periodStack.axis = .vertical
        periodStack.spacing = 24
        periodStack.alignment = .fill
        periodStack.translatesAutoresizingMaskIntoConstraints = false
        
        for period in PeriodEnum.allCases {
            periodStack.addArrangedSubview(makeCardByPeriod(period))
        }
        
        scrollView.addSubview(periodStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            periodStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            periodStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            periodStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            periodStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            periodStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    func makeCardByPeriod(_ period: PeriodEnum) -> UIStackView {
        let periodTag = CapsuleIconView(iconName: period.iconName, text: period.rawValue.capitalized)
        
        let cardStack = UIStackView()
        cardStack.axis = .vertical
        cardStack.spacing = 16
        cardStack.alignment = .leading
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        
        cardStack.addArrangedSubview(periodTag)
        
        let tasks = viewModel.filterTasksByPeriod(period)
        for task in tasks {
            let card = TaskCard(task: task)
            card.cardTapAction = { [weak self] in
                self?.onTaskSelected?(task)
            }
            
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


//import SwiftUI
//struct MeuViewControllerPreview: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> some UIViewController {
//        AllTasksViewController(viewModel: AllTasksViewModel())
//    }
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
//}
//
//#Preview {
//    MeuViewControllerPreview()
//}

