//
//  AddItemsSheetViewControllerDelegate.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

enum AddItemDestination { case basicNeeds, measurement, medication, routineActivity, event, symptom, close }

protocol AddItemsSheetViewControllerDelegate: AnyObject {
    func addItemsSheet(_ controller: AddItemsSheetViewController, didSelect destination: AddItemDestination)
}

class AddItemsSheetViewController: UIViewController {

    weak var delegate: AddItemsSheetViewControllerDelegate?
    
    let addBasicNeedsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Basic needs Activity", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addMeasurementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Measurement", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addMedicationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Medication", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let addRoutineActivityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Routine Activity", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addEventsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Events", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addSymptomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Symptom", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let closeSheetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        view.backgroundColor = .white

        view.addSubview(vStack)
        
        vStack.addArrangedSubview(addBasicNeedsButton)
        vStack.addArrangedSubview(addMeasurementButton)
        vStack.addArrangedSubview(addMedicationButton)
        vStack.addArrangedSubview(addRoutineActivityButton)
        vStack.addArrangedSubview(addEventsButton)
        vStack.addArrangedSubview(addSymptomButton)
        vStack.addArrangedSubview(closeSheetButton)
        

        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        addBasicNeedsButton.addTarget(self, action: #selector(didTapBasicNeeds), for: .touchUpInside)
        addMeasurementButton.addTarget(self, action: #selector(didTapMeasurement), for: .touchUpInside)
        addMedicationButton.addTarget(self, action: #selector(didTapMedication), for: .touchUpInside)
        addRoutineActivityButton.addTarget(self, action: #selector(didTapRoutineActivity), for: .touchUpInside)
        addEventsButton.addTarget(self, action: #selector(didTapEvents), for: .touchUpInside)
        addSymptomButton.addTarget(self, action: #selector(didTapSymptom), for: .touchUpInside)
        closeSheetButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }

    @objc private func didTapBasicNeeds() {
        delegate?.addItemsSheet(self, didSelect: .basicNeeds)
    }

    @objc private func didTapMeasurement() {
        delegate?.addItemsSheet(self, didSelect: .measurement)
    }

    @objc private func didTapMedication() {
        delegate?.addItemsSheet(self, didSelect: .medication)
    }

    @objc private func didTapRoutineActivity() {
        delegate?.addItemsSheet(self, didSelect: .routineActivity)
    }

    @objc private func didTapEvents() {
        delegate?.addItemsSheet(self, didSelect: .event)
    }

    @objc private func didTapSymptom() {
        delegate?.addItemsSheet(self, didSelect: .symptom)
    }

    @objc private func goBack() {
        delegate?.addItemsSheet(self, didSelect: .close)
    }

}
