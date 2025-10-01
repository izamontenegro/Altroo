//
//  TodayViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

protocol TodayViewControllerDelegate: AnyObject {
    func GoToProfileView()
}

class TodayViewController: UIViewController {
    
    weak var delegate: TodayViewControllerDelegate?

    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Today View"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Profile View", for: .normal)
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

        view.backgroundColor = .systemTeal
        
        view.addSubview(vStack)
        
        vStack.addArrangedSubview(profileButton)
        vStack.addArrangedSubview(viewLabel)
        
        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        profileButton.addTarget(self, action: #selector(didTapProfileView), for: .touchUpInside)
    }
    
    @objc private func didTapProfileView() {
        delegate?.GoToProfileView()
    }
}
