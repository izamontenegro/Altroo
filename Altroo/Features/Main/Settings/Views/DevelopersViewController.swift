//
//  DevelopersViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//

import UIKit

class DevelopersViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .pureWhite
        
        setupLayout()
    }
    
    // MARK: - Subviews
    private let titleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Desenvolvedoras",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        return label
    }()
    private let subtitleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Equipe responsável pela criação e desenvolvimento do Altroo.",
            labelFont: .sfPro,
            labelType: .headline,
            labelColor: .black30,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Criação de botão customizado
    private func makeButton(title: String, imageName: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(resource: .teal20)
        button.layer.cornerRadius = 8
        
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let devLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .pureWhite,
            labelWeight: .medium)
        devLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrow.tintColor = .pureWhite
        arrow.translatesAutoresizingMaskIntoConstraints = false
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        container.addSubview(devLabel)
        container.addSubview(arrow)
        button.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 0),
            container.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
            container.topAnchor.constraint(equalTo: button.topAnchor),
            container.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: -8),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 52),
            
            devLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            devLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            arrow.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            arrow.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        return button
    }
    
    // MARK: - Layout
    private func setupLayout() {
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [
            izadoraButton, layzaButton, marcelleButton, claraButton, raissaButton])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 360)
        ])
        
        [ izadoraButton, layzaButton, marcelleButton, claraButton, raissaButton].forEach {
            $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - Button action
    @objc private func didTapButton(_ sender: UIButton) {
        let links = Array(Link.allCases)
        let selectedLink = links[sender.tag].rawValue
        openLink(urlString: selectedLink)
    }
    
    // MARK: - function to open the link
    private func openLink(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: - Links
    private enum Link: String, CaseIterable {
        case layza = "https://www.linkedin.com/in/layzacarneiro"
        case izadora = "https://www.linkedin.com/in/izadoramontenegro"
        case marcelle = "https://www.linkedin.com/in/marcellerq"
        case clara = "https://www.linkedin.com/in/mclara-de-oliveira"
        case raissa = "https://www.linkedin.com/in/raissa-parente-70bb25162"
    }
    
    // MARK: - Dev Images
    private enum DevImage: String, CaseIterable {
        case layza = "layza"
        case izadora = "izadoramontenegro"
        case marcelle = "marcellerq"
        case clara = "mclara-de-oliveira"
        case raissa = "raissa-parente"
    }
    
    // MARK: - Dev buttons
    private lazy var izadoraButton = makeButton(title: "Izadora Montenegro", imageName: "iza", tag: 0)
    private lazy var layzaButton = makeButton(title: "Layza Carneiro", imageName: "layza", tag: 1)
    private lazy var marcelleButton = makeButton(title: "Marcelle Queiroz", imageName: "marcelle", tag: 2)
    private lazy var claraButton = makeButton(title: "M. Clara Alexandre", imageName: "clara", tag: 3)
    private lazy var raissaButton = makeButton(title: "Raissa Parente", imageName: "raissa", tag: 4)
}

#Preview {
    DevelopersViewController()
}
