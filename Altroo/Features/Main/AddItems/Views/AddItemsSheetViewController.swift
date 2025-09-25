//
//  AddItemsSheetViewControllerDelegate.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

protocol AddItemsSheetViewControllerDelegate: AnyObject {
    func AddItemsSheetGoToNext()
   
    func AddItemsSheetGoBack()
}

class AddItemsSheetViewController: UIViewController {

    weak var delegate: AddItemsSheetViewControllerDelegate?
    
    let addRoutineActivityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Routine Activity", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addBasicNeedsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Basic needs Activity", for: .normal)
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
        view.backgroundColor = .systemIndigo

        view.addSubview(vStack)
        
        vStack.addArrangedSubview(addRoutineActivityButton)
        vStack.addArrangedSubview(addEventsButton)
        vStack.addArrangedSubview(addBasicNeedsButton)
        vStack.addArrangedSubview(addSymptomButton)
        

        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc
    private func goToNext() {
        delegate?.AddItemsSheetGoToNext()
    }
    
    @objc
    private func goBack() {
        delegate?.AddItemsSheetGoBack()
    }
}
