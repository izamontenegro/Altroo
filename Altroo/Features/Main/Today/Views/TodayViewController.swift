//
//  TodayViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit
import Combine

protocol TodayViewControllerDelegate: AnyObject {
    func goTo(_ destination: TodayDestination)
}

class TodayViewController: UIViewController {
    
    var viewModel: TodayViewModel
    weak var delegate: TodayViewControllerDelegate?
    var symptomsCard: SymptomsCard
    var feedingRecords: [FeedingRecord] = []
    var dimmingView: UIView?
    
    private var cancellables = Set<AnyCancellable>()
    private var profileToolbar: ProfileToolbarContainer?
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        refreshControl.bounds = refreshControl.bounds.offsetBy(dx: 0, dy: -20)
        
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
        

    @objc private func handleRefresh() { fetchData() }
}
