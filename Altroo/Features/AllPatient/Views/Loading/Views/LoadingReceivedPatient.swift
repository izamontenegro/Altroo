//
//  LoadingReceivedPatient.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 18/11/25.
//

import UIKit

final class LoadingReceivedPatient: UIViewController {

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .pureWhite
        return spinner
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Carregando paciente compartilhado"
        label.textColor = .pureWhite
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .teal50
        
        setupLayout()
        spinner.startAnimating()
    }

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [spinner, messageLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
