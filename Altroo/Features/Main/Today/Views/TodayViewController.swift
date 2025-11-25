//
//  TodayViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit
import Combine
import SwiftUI

protocol TodayViewControllerDelegate: AnyObject {
    func goTo(_ destination: TodayDestination)
    func goToSymptomDetail(with symptom: Symptom)
    func goToPrivacyPolicy()
    func goToLegalNotice()
    func openTaskDetail(with task: TaskInstance)
}

class TodayViewController: UIViewController {
    
    var viewModel: TodayViewModel
    weak var delegate: TodayViewControllerDelegate?
    var symptomsCard: SymptomsCard
    var feedingRecords: [FeedingRecord] = []
    
    private var dimmingView: UIView?
    private var cancellables = Set<AnyCancellable>()

    private var profileToolbar: ProfileToolbarContainer?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black30
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    let vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(delegate: TodayViewControllerDelegate? = nil, viewModel: TodayViewModel) {
        self.delegate = delegate
        self.viewModel = viewModel
        self.symptomsCard = SymptomsCard(symptoms: viewModel.todaySymptoms)
        
        super.init(nibName: nil, bundle: nil)
        
        self.symptomsCard.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue80
        
        guard let careRecipient = viewModel.currentCareRecipient else { return }
        let toolbar = ProfileToolbarContainer(careRecipient: careRecipient)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.delegate = self
        self.profileToolbar = toolbar

        scrollView.refreshControl = refreshControl
        
        view.addSubview(scrollView)
        scrollView.addSubview(vStack)
        view.addSubview(toolbar)
        
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: view.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Layout.bigButtonBottomPadding),
            
            vStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            vStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30),
            vStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            vStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        setupBindings()
        showHealthAlertIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        showTabBar(true)
        fetchData()
        showHealthAlertIfNeeded()
    }
    
    private func fetchData() {
        viewModel.fetchAllTodaySymptoms()
        viewModel.fetchStoolQuantity()
        viewModel.fetchUrineQuantity()
        viewModel.fetchAllPeriodTasks()
        viewModel.fetchWaterQuantity()
        
        self.feedingRecords = viewModel.fetchFeedingRecords()
        
        symptomsCard.updateSymptoms(viewModel.todaySymptoms)
        addSections()
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    private func showHealthAlertIfNeeded() {
        if !UserDefaults.standard.healthAlertSeen {
            showHealthDataAlert()
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
            //"today_empty_tasks".localized
            let normalText = "Nenhuma tarefa cadastrada para o turno da "
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
    
    private func setupBindings() {
        viewModel.$currentCareRecipient
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newRecipient in
                guard let self = self else { return }
                self.updateHeader(with: newRecipient)
            }
            .store(in: &cancellables)
        
        viewModel.$waterQuantity
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                self.addSections()
                
            }
            .store(in: &cancellables)
        
        viewModel.$waterMeasure
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                self.addSections()
                
            }
            .store(in: &cancellables)
    }
    
    private func updateHeader(with careRecipient: CareRecipient?) {
        guard let careRecipient = careRecipient else { return }

        if let toolbar = profileToolbar {
            toolbar.update(with: careRecipient)
        } else {
            let toolbar = ProfileToolbarContainer(careRecipient: careRecipient)
            toolbar.translatesAutoresizingMaskIntoConstraints = false
            toolbar.delegate = self
            self.profileToolbar = toolbar
            view.addSubview(toolbar)

            NSLayoutConstraint.activate([
                toolbar.topAnchor.constraint(equalTo: view.topAnchor),
                toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                toolbar.heightAnchor.constraint(equalToConstant: 250)
            ])
        }
    }
    
    private func addSections() {
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
    
    private func showHealthDataAlert() {
        guard let tabBarVC = self.tabBarController else { return }

        let dim = UIView(frame: tabBarVC.view.bounds)
        dim.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dim.alpha = 0
        dim.tag = 998
        dimmingView = dim
        tabBarVC.view.addSubview(dim)

        let alertVC = UIHostingController(
            rootView: HealthDataAlertView(
                onClose: { [weak self] in self?.closeHealthAlert() },
                onPrivacyPolicy: { [weak self] in
                    self?.dismissHealthAlertUI()
                    self?.delegate?.goToPrivacyPolicy()
                },
                onLegalNotice: { [weak self] in
                    self?.dismissHealthAlertUI()
                    self?.delegate?.goToLegalNotice()
                }
            )
        )
        
        alertVC.view.backgroundColor = .clear
        let alert = alertVC.view!
        
        alert.translatesAutoresizingMaskIntoConstraints = false
        alert.tag = 999
        alert.layer.shadowColor = UIColor.black.cgColor
        alert.layer.shadowOpacity = 0.3
        alert.layer.shadowRadius = 10
        alert.layer.shadowOffset = .zero
        alert.alpha = 0

        tabBarVC.addChild(alertVC)
        tabBarVC.view.addSubview(alert)
        alertVC.didMove(toParent: tabBarVC)

        NSLayoutConstraint.activate([
            alert.centerXAnchor.constraint(equalTo: tabBarVC.view.centerXAnchor),
            alert.centerYAnchor.constraint(equalTo: tabBarVC.view.centerYAnchor)
        ])

        UIView.animate(withDuration: 0.3) {
            dim.alpha = 1
            alert.alpha = 1
        }
    }

    @objc private func closeHealthAlert() {
        UserDefaults.standard.healthAlertSeen = true
        dismissHealthAlertUI()
    }
    
    private func dismissHealthAlertUI() {
        guard let tabBarVC = self.tabBarController else { return }

        tabBarVC.view.subviews
            .filter { $0.tag == 999 }
            .forEach { view in
                UIView.animate(withDuration: 0.2, animations: {
                    view.alpha = 0
                }, completion: { _ in
                    view.removeFromSuperview()
                })
            }

        tabBarVC.view.subviews
            .filter { $0.tag == 998 }
            .forEach { dim in
                UIView.animate(withDuration: 0.2, animations: {
                    dim.alpha = 0
                }, completion: { _ in
                    dim.removeFromSuperview()
                })
            }

        self.dimmingView = nil
    }

    @objc private func handleRefresh() {
        fetchData()
    }
}
