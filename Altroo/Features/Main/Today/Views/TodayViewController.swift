//
//  TodayViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

protocol TodayViewControllerDelegate: AnyObject {
    func goToCareRecipientProfileView()
    func goToEditSectionView()
    
    func goToRecordFeeding()
    func goToRecordHydration()
    func goToRecordStool()
    func goToRecordUrine()
    
    func goToRecordHeartRate()
    func goToRecordGlycemia()
    func goToRecordBloodPressure()
    func goToRecordTemperature()
    func goToRecordSaturation()
    
    func goToSeeAllTasks()
    func goToAddNewTask()
    
    func goToSeeAllMedication()
    func goToAddNewMedication()
    func goToCheckMedicationDone()
    
    func goToSeeAllEvents()
    func goToAddNewEvent()
    
    func goToAddNewSymptom()
    func goToSymptomDetail(with symptom: Symptom)
}

class TodayViewController: UIViewController {
    var viewModel: TodayViewModel
    weak var delegate: TodayViewControllerDelegate?
    
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
    
    var symptomsCard: SymptomsCard
    
    init(viewModel: TodayViewModel) {
        //TODO: Feed real symptoms
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
        
        
        view.backgroundColor = UIColor(named: "blue80")
        
        view.addSubview(scrollView)
        scrollView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            vStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            vStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            vStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            vStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
        ])
        
        addSections()
    }
    
    private func addSections() {
            // Profile & Edit
            vStack.addArrangedSubview(makeSection(title: "Profile", buttons: [("Abrir", #selector(didTapProfileView))]))
            vStack.addArrangedSubview(makeSection(title: "Edit Sections", buttons: [("Abrir", #selector(didTapEditSectionView))]))

            // Basic Needs
            vStack.addArrangedSubview(makeSection(title: "Necessidades Básicas", buttons: [
                ("Alimentação", #selector(didTapRecordFeeding)),
                ("Hidratação", #selector(didTapRecordHydration)),
                ("Fezes", #selector(didTapRecordStool)),
                ("Urina", #selector(didTapRecordUrine))
            ]))

            // Tasks
            vStack.addArrangedSubview(makeSection(title: "Tarefas", buttons: [
                ("Adicionar Tarefa", #selector(didTapAddNewTask)),
                ("Ver Todas", #selector(didTapSeeAllTasks))
            ]))

            // Symptoms
            vStack.addArrangedSubview(makeSection(title: "Sintomas", buttons: [
                ("Adicionar Sintoma", #selector(didTapAddNewSymptom))
            ]))
            vStack.addArrangedSubview(symptomsCard)
        }

        // MARK: - Section Factory
        private func makeSection(title: String, buttons: [(String, Selector)]) -> UIView {
            let section = UIView()
            section.translatesAutoresizingMaskIntoConstraints = false

            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false

            section.addSubview(titleLabel)
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: section.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: section.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: section.trailingAnchor)
            ])

            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 12
            stack.translatesAutoresizingMaskIntoConstraints = false
            section.addSubview(stack)

            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
                stack.leadingAnchor.constraint(equalTo: section.leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: section.trailingAnchor),
                stack.bottomAnchor.constraint(equalTo: section.bottomAnchor)
            ])

            for (title, selector) in buttons {
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.backgroundColor = .teal20
                button.setTitleColor(.white, for: .normal)
                button.layer.cornerRadius = 8
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                button.addTarget(self, action: selector, for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.heightAnchor.constraint(equalToConstant: 44).isActive = true
                stack.addArrangedSubview(button)
            }

            return section
        }
    
    // MARK: - BUTTON ACTIONS
    @objc private func didTapProfileView() { delegate?.goToCareRecipientProfileView() }
    @objc private func didTapEditSectionView() { delegate?.goToEditSectionView() }
    @objc private func didTapRecordFeeding() { delegate?.goToRecordFeeding() }
    @objc private func didTapRecordHydration() { delegate?.goToRecordHydration() }
    @objc private func didTapRecordStool() { delegate?.goToRecordStool() }
    @objc private func didTapRecordUrine() { delegate?.goToRecordUrine() }
    
    @objc private func didTapAddNewTask() { delegate?.goToAddNewTask() }
    @objc private func didTapSeeAllTasks() { delegate?.goToSeeAllTasks() }
    
    @objc private func didTapAddNewSymptom() { delegate?.goToAddNewSymptom() }
}

extension TodayViewController: SymptomsCardDelegate {
    func tappedSymptom(_ symptom: Symptom, on card: SymptomsCard) {
        delegate?.goToSymptomDetail(with: symptom)
    }
}
