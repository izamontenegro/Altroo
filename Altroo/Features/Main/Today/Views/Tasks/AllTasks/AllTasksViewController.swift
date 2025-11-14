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
    var onTaskSelected: ((TaskInstance) -> Void)?
    
    let titleLabel = StandardLabel(labelText: "Tarefas", labelFont: .sfPro, labelType: .title2, labelColor: .black, labelWeight: .semibold)
    
    let descriptionLabel = StandardLabel(labelText: "Confira os tarefas cadastradas no sistema ou adicione uma nova tarefa para visualizá-la aqui.", labelFont: .sfPro, labelType: .body, labelColor: .black, labelWeight: .regular)
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let addTaskButton: CapsuleWithCircleView = {
        let label = CapsuleWithCircleView(
            text: "Nova Tarefa",
            textColor: .teal20,
            nameIcon: "plus",
            nameIconColor: .pureWhite,
            circleIconColor: .teal20
        )
        return label
    }()
    
    private lazy var segmentedControl: StandardSegmentedControl = {
        let sc = StandardSegmentedControl(
            items: ["Em atraso", "Hoje", "A seguir"],
            height: 35,
            backgroundColor: UIColor(resource: .pureWhite),
            selectedColor: UIColor(resource: .blue30),
            selectedFontColor: UIColor(resource: .pureWhite),
            unselectedFontColor: UIColor(resource: .blue10),
            cornerRadius: 8
        )

        sc.applyWhiteBackgroundColor()
        sc.setContentHuggingPriority(.defaultLow, for: .horizontal)
        sc.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
//        let action1 = UIAction(title: "Diário", handler: { _ in
//            self.setSwiftUIView(DailyReportAppView(viewModel: self.viewModel))
//        })
//        let action2 = UIAction(title: "Periódico", handler: {  _ in
//            self.setSwiftUIView(IntervalReportAppView())
//        })
//        sc.setAction(action1, forSegmentAt: 0)
//        sc.setAction(action2, forSegmentAt: 1)
        return sc
    }()

    
    init(viewModel: AllTasksViewModel, onTaskSelected: ((TaskInstance) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onTaskSelected = onTaskSelected
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue80
        
        setupAddButton()
        makeContent()
    }
    
    func makeTitle() {
        descriptionLabel.numberOfLines = 0
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(segmentedControl)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                        
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            segmentedControl.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
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
            
            periodStack.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            periodStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            periodStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            periodStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            periodStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
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
            let emptyCard = makeEmptyCard()
            cardStack.addArrangedSubview(emptyCard)
            
            NSLayoutConstraint.activate([
                emptyCard.leadingAnchor.constraint(equalTo: cardStack.leadingAnchor),
                emptyCard.trailingAnchor.constraint(equalTo: cardStack.trailingAnchor),
                emptyCard.heightAnchor.constraint(equalToConstant: 80)
            ])
            
            return cardStack
        }

        //FILLED CONTENT
        for task in tasks {
            let card = TaskCard(task: task)
            card.delegate = self

            
            card.translatesAutoresizingMaskIntoConstraints = false
            cardStack.addArrangedSubview(card)
            
            NSLayoutConstraint.activate([
                card.leadingAnchor.constraint(equalTo: cardStack.leadingAnchor),
                card.trailingAnchor.constraint(equalTo: cardStack.trailingAnchor)
            ])
        }
        
        return cardStack
    }
    
    func makeEmptyCard() -> UIView {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .pureWhite
        card.layer.cornerRadius = 10
    
        let label = StandardLabel(
            labelText: "Nenhuma tarefa foi criada para este período",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black30)
            
        card.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: card.centerYAnchor),
        ])

        return card
    }
    
    private func setupAddButton() {
        self.rightButton = addTaskButton
        setupAddButtonTap()
    }
    
    private func setupAddButtonTap() {
        addTaskButton.enablePressEffect()

        addTaskButton.onTap = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self?.didTapAddButton()
            }
        }
    }
    
    @objc func didTapAddButton() {
        
    }
}

extension AllTasksViewController: TaskCardDelegate {
    func taskCardDidSelect(_ task: TaskInstance) {
        onTaskSelected?(task)
    }
    
    func taskCardDidMarkAsDone(_ task: TaskInstance) {
        viewModel.markAsDone(task)
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


