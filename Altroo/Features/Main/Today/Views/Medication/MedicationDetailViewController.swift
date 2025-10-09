//
//  MedicationDetailViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//
import UIKit

protocol MedicationDetailViewControllerDelegate: AnyObject {
    func didTapOutOfTimeButton()
}

class MedicationDetailViewController: UIViewController {
    weak var delegate: MedicationDetailViewControllerDelegate?

    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Medication Detail View"
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

        view.backgroundColor = .white
        
        view.addSubview(viewLabel)
        view.addSubview(vStack)
        
        addDelegateButtons()
        
        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.topAnchor.constraint(equalTo: viewLabel.bottomAnchor),
        ])
    }
    
    private func addDelegateButtons() {
        createButton(title: "Taken in time", action: #selector(didTapInTimeButton))
        createButton(title: "Taken out of time", action: #selector(didTapOutOfTimeButton))
        createButton(title: "Not taken", action: #selector(didTapNotTakenButton))
    }
    
    //UTILITY FUNC
    private func createButton(title: String, action: Selector) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        vStack.addArrangedSubview(button)
    }
    
    @objc func didTapInTimeButton() {
    }
    
    @objc func didTapOutOfTimeButton() {
        delegate?.didTapOutOfTimeButton()
    }
    
    @objc func didTapNotTakenButton() {
    }
}
