//
//  ShiftForm.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 30/09/25.
//

import UIKit

protocol ShiftFormsViewControllerDelegate: AnyObject {
    func shiftFormsDidFinish()
}

class ShiftForm: UIViewController {
    weak var delegate: ShiftFormsViewControllerDelegate?
    
    let doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Next Step", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Shift Form"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemYellow
        
        view.addSubview(viewLabel)
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.topAnchor.constraint(equalTo: viewLabel.bottomAnchor, constant: 32)
 
        ])
        
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }
    
    @objc
    func didTapDoneButton() {
        delegate?.shiftFormsDidFinish()
    }
}
