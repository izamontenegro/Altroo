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
    weak var coordinator: TodayCoordinator?
    
    let titleLabel = StandardLabel(labelText: "tasks".localized, labelFont: .sfPro, labelType: .title2, labelColor: .black, labelWeight: .semibold)
    
    let descriptionLabel = StandardLabel(labelText: "taskform_subtitle".localized, labelFont: .sfPro, labelType: .body, labelColor: .black, labelWeight: .regular)
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let addTaskButton: CapsuleWithCircleView = {
        let label = CapsuleWithCircleView(
            capsuleColor: .teal80,
            text: "new_task".localized,
            textColor: .teal20,
            nameIcon: "plus",
            nameIconColor: .pureWhite,
            circleIconColor: .teal20
        )
        return label
    }()
    
    private lazy var segmentedControl: StandardSegmentedControl = {
        let sc = StandardSegmentedControl(
            items: ["late".localized, "today".localized, "to_do".localized],
            height: 35,
            backgroundColor: UIColor(resource: .pureWhite),
            selectedColor: UIColor(resource: .blue30),
            selectedFontColor: UIColor(resource: .pureWhite),
            unselectedFontColor: UIColor(resource: .blue10),
            cornerRadius: 8
        )
        sc.selectedSegmentIndex = 1
        sc.applyWhiteBackgroundColor()
        sc.setContentHuggingPriority(.defaultLow, for: .horizontal)
        sc.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        sc.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        return sc
    }()
    
    private var currentContentView: UIView?

    private lazy var todayView = TodayTasksView(viewModel: viewModel)
    private lazy var lateView = LateTasksView(viewModel: viewModel)
    private lazy var upcomingView = UpcomingTasksView(viewModel: viewModel)
    
    init(viewModel: AllTasksViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue80
        
        setupAddButton()
        makeContent()
        showContent(todayView)
        bindToCardDelegateActions()
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
    
    func showContent(_ view: UIView) {
        currentContentView?.removeFromSuperview()
        currentContentView = view

        scrollView.addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            view.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    func makeContent() {
        view.addSubview(scrollView)
        makeTitle()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
        ])
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
        coordinator?.goTo(.addNewTask)
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showContent(lateView)
        case 1:
            showContent(todayView)
        case 2:
            showContent(upcomingView)
        default: break
        }
    }

}

//DEALING WITH CARD DELEGATES ON SUBVIEWS
extension AllTasksViewController {
    func bindToCardDelegateActions() {
        todayView.onSelectTask = { [weak self] task in
            self?.coordinator?.goTo(.taskDetail(task))
        }
        
        todayView.onMarkDone = { [weak self] task in
            self?.viewModel.markAsDone(task)
        }
        
        lateView.onSelectTask = { [weak self] task in
            self?.coordinator?.goTo(.taskDetail(task))
        }
        
        lateView.onMarkDone = { [weak self] task in
            self?.viewModel.markAsDone(task)
        }
        
        upcomingView.onSelectTask = { [weak self] task in
            self?.coordinator?.goTo(.templateDetail(task))
        }
    }
}
