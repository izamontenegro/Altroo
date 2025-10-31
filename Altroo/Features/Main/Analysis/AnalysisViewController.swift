//
//  AnalysisViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

class AnalysisViewController: GradientNavBarViewController {

    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Relatórios Em breve"
        label.tintColor = .black10
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func viewDidLoad() {
        showBackButton = false
        super.viewDidLoad()

        view.backgroundColor = .blue80
        
        view.addSubview(viewLabel)
        
        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
