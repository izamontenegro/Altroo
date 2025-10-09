//
//  TodayViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

protocol TodayViewControllerDelegate: AnyObject {
    func goTo(_ destination: TodayDestination)
}

class TodayViewController: UIViewController {
    
    weak var delegate: TodayViewControllerDelegate?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Today View"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        
        view.addSubview(scrollView)
        scrollView.addSubview(vStack)
        
        vStack.addArrangedSubview(viewLabel)
        addDelegateButtons()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            vStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            vStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
    }
    
    private func addDelegateButtons() {
        createButton(title: "Profile", action: #selector(didTapProfileView))
        createButton(title: "Edit sections", action: #selector(didTapEditSectionView))

        createButton(title: "Record Feeding", action: #selector(didTapRecordFeeding))
        createButton(title: "Record Hydration", action: #selector(didTapRecordHydration))
        createButton(title: "Record Stool", action: #selector(didTapRecordStool))
        createButton(title: "Record Urine", action: #selector(didTapRecordUrine))
        
        createButton(title: "Record Heart Rate", action: #selector(didTapRecordHeartRate))
        createButton(title: "Record Glycemia", action: #selector(didTapRecordGlycemia))
        createButton(title: "Record Blood Pressure", action: #selector(didTapRecordBloodPressure))
        createButton(title: "Record Temperature", action: #selector(didTapRecordTemperature))
        createButton(title: "Record Saturation", action: #selector(didTapRecordSaturation))
        
        createButton(title: "See All Tasks", action: #selector(didTapSeeAllTasks))
        createButton(title: "Add New Task", action: #selector(didTapAddNewTask))
        
        createButton(title: "See All Medication", action: #selector(didTapSeeAllMedication))
        createButton(title: "Add New Medication", action: #selector(didTapAddNewMedication))
        createButton(title: "Check Medication Done", action: #selector(didTapCheckMedicationDone))
        
        createButton(title: "See All Events", action: #selector(didTapSeeAllEvents))
        createButton(title: "Add New Event", action: #selector(didTapAddNewEvent))
        
        createButton(title: "Add New Symptom", action: #selector(didTapAddNewSymptom))
    }
    
    //MARK: - BUTTON ACTIONS
    @objc private func didTapProfileView() {
        delegate?.goTo(.careRecipientProfile)
    }
    
    @objc private func didTapEditSectionView() {
        delegate?.goTo(.editSection)
    }
    
    @objc private func didTapRecordFeeding() {
        delegate?.goTo(.recordFeeding)
    }
    
    @objc private func didTapRecordHydration() {
        delegate?.goTo(.recordHydration)
    }
    
    @objc private func didTapRecordStool() {
        delegate?.goTo(.recordStool)
    }
    
    @objc private func didTapRecordUrine() {
        delegate?.goTo(.recordUrine)
    }
    
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
    
    @objc private func didTapSeeAllTasks() {
        delegate?.goTo(.seeAllTasks)
    }
    
    @objc private func didTapAddNewTask() {
        delegate?.goTo(.addNewTask)
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
    
    @objc private func didTapAddNewSymptom() {
        delegate?.goTo(.addSymptom)
    }
    
    
    //UTILITY FUNC
    private func createButton(title: String, action: Selector) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        vStack.addArrangedSubview(button)
    }
}
