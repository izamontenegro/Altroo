//
//  HistoryViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

protocol HistoryViewControllerDelegate: AnyObject {
    func openDetailSheet(_ controller: HistoryViewController)
}

class HistoryViewController: UIViewController {
    weak var delegate: HistoryViewControllerDelegate?

    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "History View"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("This is a done task", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemTeal
        
        view.addSubview(viewLabel)
        view.addSubview(detailButton)
        
        detailButton.addTarget(self, action: #selector(didTapDetailButton), for: .touchUpInside)


        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            detailButton.topAnchor.constraint(equalTo: viewLabel.bottomAnchor),
            detailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc func didTapDetailButton() {
        delegate?.openDetailSheet(self)
    }
}
