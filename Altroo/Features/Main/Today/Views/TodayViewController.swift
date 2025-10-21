//
//  TodayViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

protocol TodayViewControllerDelegate: AnyObject {
    func goTo(_ destination: TodayDestination)
    func goToSymptomDetail(with symptom: Symptom)
}

class TodayViewController: UIViewController {
    var viewModel: TodayViewModel
    weak var delegate: TodayViewControllerDelegate?
    var onTaskSelected: ((TaskInstance) -> Void)?
    var symptomsCard: SymptomsCard
    var feedingRecords: [FeedingRecord] = []
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(delegate: TodayViewControllerDelegate? = nil, viewModel: TodayViewModel, onTaskSelected: ((TaskInstance) -> Void)? = nil) {
        self.delegate = delegate
        self.viewModel = viewModel
        self.symptomsCard = SymptomsCard(symptoms: viewModel.todaySymptoms)

        super.init(nibName: nil, bundle: nil)
        
        self.symptomsCard.delegate = self
        self.onTaskSelected = onTaskSelected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue80
        
        guard let careRecipient = viewModel.currentCareRecipient else { return }
        let profileToolbar = ProfileToolbarContainer(careRecipient: careRecipient)
        profileToolbar.translatesAutoresizingMaskIntoConstraints = false
        profileToolbar.delegate = self
        
        view.addSubview(profileToolbar)
        view.addSubview(scrollView)
        scrollView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            profileToolbar.topAnchor.constraint(equalTo: view.topAnchor),
            profileToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileToolbar.heightAnchor.constraint(equalToConstant: 174)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: profileToolbar.bottomAnchor, constant: -30),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -45),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            vStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            vStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -0),
            vStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            vStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        view.bringSubviewToFront(profileToolbar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        viewModel.fetchAllTodaySymptoms()
        viewModel.fetchStoolQuantity()
        viewModel.fetchUrineQuantity()
        viewModel.fetchAllPeriodTasks()
        viewModel.fetchWaterQuantity()
        
        feedingRecords = viewModel.fetchFeedingRecords()
        
        symptomsCard.updateSymptoms(viewModel.todaySymptoms)
        addSections()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
        
    func makeCardByPeriod() -> UIView {
        let cardStack = UIStackView()
        cardStack.axis = .vertical
        cardStack.spacing = 16
        cardStack.alignment = .fill
        cardStack.translatesAutoresizingMaskIntoConstraints = false

        let tasks = viewModel.periodTasks

        if tasks.isEmpty {
            let container = UIView()
            container.backgroundColor = .pureWhite
            container.layer.cornerRadius = 12
            container.translatesAutoresizingMaskIntoConstraints = false
            container.heightAnchor.constraint(equalToConstant: 80).isActive = true

            let emptyLabel = StandardLabel(
                labelText: "Nenhuma tarefa registrada.",
                labelFont: .sfPro,
                labelType: .callOut,
                labelColor: .black30
            )
            emptyLabel.textAlignment = .center
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false

            container.addSubview(emptyLabel)
            NSLayoutConstraint.activate([
                emptyLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                emptyLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 8),
                emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -8)
            ])

            cardStack.addArrangedSubview(container)
        } else {
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
        }

        return cardStack
    }
    
    private func addSections() {
        var configs = TodaySectionManager.shared.load()

        if configs.isEmpty || configs.first(where: { $0.type == .basicNeeds })?.subitems == nil {
            let defaultSubitems = [
                SubitemConfig(title: "Alimentação", isVisible: true),
                SubitemConfig(title: "Hidratação", isVisible: true),
                SubitemConfig(title: "Fezes", isVisible: true),
                SubitemConfig(title: "Urina", isVisible: true)
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
                let visibleItems = config.subitems?.filter(\.isVisible).map(\.title) ?? []
                let title = StandardLabel(labelText: "Necessidades Básicas", labelFont: .sfPro, labelType: .title2, labelColor: .black10, labelWeight: .semibold)
                
                let sectionStack = UIStackView()
                sectionStack.axis = .vertical
                sectionStack.spacing = 16
                
                if visibleItems.contains("Alimentação") {
                    let feedingCard = RecordCard(title: "Alimentação", iconName: "takeoutbag.and.cup.and.straw.fill", contentView: FeedingCardRecord(title: "Café da manhã", status: .partial))
                    feedingCard.onAddButtonTap = { [weak self] in
                        self?.delegate?.goTo(.recordFeeding)
                    }
                    sectionStack.addArrangedSubview(feedingCard)
                }
                if visibleItems.contains("Hidratação") {
                    let iconName: String
                    if #available(iOS 17.0, *) {
                        iconName = "waterbottle.fill"
                    } else {
                        iconName = "drop.fill"
                    }

                    let hydrationCard = RecordCard(
                        title: "Hidratação",
                        iconName: iconName,
                        showPlusButton: false,
                        contentView: WaterRecord(currentQuantity: "\(viewModel.waterQuantity)", goalQuantity: "2L")
                    )
                    viewModel.onWaterQuantityUpdated = { [weak self] newValue in
                        DispatchQueue.main.async {
                            (hydrationCard.contentView as? WaterRecord)?.updateQuantity("\(newValue)")
                        }
                    }
                    hydrationCard.onAddButtonTap = { [weak self] in
                        self?.delegate?.goTo(.recordHydration)
                    }
                    sectionStack.addArrangedSubview(hydrationCard)
                }

                if visibleItems.contains("Fezes") || visibleItems.contains("Urina") {
                    let bottomRow = UIStackView()
                    bottomRow.axis = .horizontal
                    bottomRow.spacing = 16
                    bottomRow.distribution = .fillEqually
                    if visibleItems.contains("Fezes") {
                        let stoolCard = RecordCard(title: "Fezes", iconName: "toilet.fill", contentView: QuantityRecordContent(quantity: viewModel.todayStoolQuantity))
                        stoolCard.onAddButtonTap = { [weak self] in
                            self?.delegate?.goTo(.recordStool)
                        }
                        
                        bottomRow.addArrangedSubview(stoolCard)
                    }
                    if visibleItems.contains("Urina") {
                        let urineCard = RecordCard(title: "Urina", iconName: "toilet.fill", contentView: QuantityRecordContent(quantity: viewModel.todayUrineQuantity))
                        urineCard.onAddButtonTap = { [weak self] in
                            self?.delegate?.goTo(.recordUrine)
                        }
                        
                        bottomRow.addArrangedSubview(urineCard)
                    }
                    sectionStack.addArrangedSubview(bottomRow)
                }

                vStack.addArrangedSubview(title)
                vStack.addArrangedSubview(sectionStack)

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
    
    // MARK: - BUTTON ACTIONS
    @objc private func didTapRecordHeartRate() {
        delegate?.goTo(.recordHeartRate)
    }
    @objc private func didTapRecordGlycemia() {
        delegate?.goTo(.recordGlycemia)
    }
    @objc private func didTapRecordBloodPressure() {
        delegate?.goTo(.recordBloodPressure)
    }
    @objc private func didTapRecordTemperature() {
        delegate?.goTo(.recordTemperature)
    }
    @objc private func didTapRecordSaturation() {
        delegate?.goTo(.recordSaturation)
    }
    @objc private func didTapSeeAllMedication() {
        delegate?.goTo(.seeAllMedication)
    }
    @objc private func didTapAddNewMedication() {
        delegate?.goTo(.addNewMedication)
    }
    @objc private func didTapCheckMedicationDone() {
        delegate?.goTo(.checkMedicationDone)
    }
    @objc private func didTapSeeAllEvents() {
        delegate?.goTo(.seeAllEvents)
    }
    @objc private func didTapAddNewEvent() {
        delegate?.goTo(.addNewEvent)
    }
}

extension TodayViewController: SymptomsCardDelegate {
    func tappedSymptom(_ symptom: Symptom, on card: SymptomsCard) {
        delegate?.goToSymptomDetail(with: symptom)
    }
}

extension TodayViewController: TaskCardDelegate {
    func taskCardDidSelect(_ task: TaskInstance) {
        onTaskSelected?(task)
    }
    
    func taskCardDidMarkAsDone(_ task: TaskInstance) {
        viewModel.markAsDone(task)
    }
}

extension TodayViewController: TaskHeaderDelegate {
    func didTapAddTask() {
        delegate?.goTo(.addNewTask)
    }
    
    func didTapSeeTask() {
        delegate?.goTo(.seeAllTasks)
    }
}

extension TodayViewController: IntercurrenceHeaderDelegate {
    func didTapAddIntercurrence() {
        delegate?.goTo(.addSymptom)
    }
}

extension TodayViewController: ProfileToolbarDelegate {
    func didTapProfileView() {
        delegate?.goTo(.careRecipientProfile)
    }
    
    func didTapEditCapsuleView() {
        delegate?.goTo(.editSection)
    }
}
