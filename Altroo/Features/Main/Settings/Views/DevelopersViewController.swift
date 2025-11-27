//
//  DevelopersViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//

import UIKit

class DevelopersViewController: GradientNavBarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .pureWhite
        
        setupHeaderUI()
        setupButtonsUI()
        setupCreateButton()
    }
    
    // MARK: - Subviews
    private let buttonsView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "devs".localized,
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        return label
    }()
    private let subtitleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "devs_nav_description".localized,
            labelFont: .sfPro,
            labelType: .headline,
            labelColor: .black30,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    
    private func setupHeaderUI() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    private func setupButtonsUI() {
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            buttonsView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupCreateButton() {
        let devs: [Devs] = [.izadora, .layza, .marcelle, .clara, .raissa]
        
        for dev in devs {
            let button = createDevButton(for: dev)
            buttonsView.addArrangedSubview(button)
        }
    }
    
    private func createDevButton(for dev: Devs) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = dev.tag
        
        button.setTitle(dev.name, for: .normal)
        button.setTitleColor(.pureWhite, for: .normal)
        
        button.backgroundColor = .teal20
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .rounded(ofSize: 17, weight: .medium)
        
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)
        
        button.addTarget(self, action: #selector(devButtonTapped(_:)), for: .touchUpInside)
        
        if let image = UIImage(named: dev.imageName)?.resized(to: 44) {
            let imageView = UIImageView(image: image.withRenderingMode(.alwaysOriginal))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
                
            button.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8),
                imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
            ])
        }
        
        if let icon = UIImage(systemName: "chevron.right")?.resized(to: 15) {
            let iconView = UIImageView(image: icon.withRenderingMode(.alwaysTemplate))
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.tintColor = .pureWhite
            iconView.contentMode = .scaleAspectFit
            
            button.addSubview(iconView)
            
            NSLayoutConstraint.activate([
                iconView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
                iconView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
            ])
        }

        button.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        return button
    }
    
    @objc private func devButtonTapped(_ sender: UIButton) {
        guard let dev = getDevFromTag(sender.tag) else { return }
        
        if let url = URL(string: dev.url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func getDevFromTag(_ tag: Int) -> Devs? {
        switch tag {
        case 0: return .izadora
        case 1: return .layza
        case 2: return .marcelle
        case 3: return .clara
        case 4: return .raissa
        default : return nil
        }
    }
}

// MARK: - Devs
enum Devs {
    case izadora, layza, marcelle, clara, raissa
    
    var name: String {
        switch self {
        case .izadora: return "Izadora Montenegro"
        case .layza: return "Layza Carneiro"
        case .marcelle: return "Marcelle Queiroz"
        case .clara: return "M. Clara Alexandre"
        case .raissa: return "Raissa Parente"
        }
    }
    
    var imageName: String {
        switch self {
        case .izadora: return "iza"
        case .layza: return "layza"
        case .marcelle: return "marcelle"
        case .clara: return "clara"
        case .raissa: return "raissa"
        }
    }
    
    var tag: Int {
        switch self {
        case .izadora: return 0
        case .layza: return 1
        case .marcelle: return 2
        case .clara: return 3
        case .raissa: return 4
        }
    }
    
    var url: String {
        switch self {
        case .izadora: return "https://www.linkedin.com/in/izadoramontenegro"
        case .layza: return "https://www.linkedin.com/in/layzacarneiro"
        case .marcelle: return "https://www.linkedin.com/in/marcellerq"
        case .clara: return "https://www.linkedin.com/in/mclara-de-oliveira"
        case .raissa: return "https://www.linkedin.com/in/raissa-parente-70bb25162"
        }
    }
}

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resized(to dimension: CGFloat) -> UIImage? {
        return resized(to: CGSize(width: dimension, height: dimension))
    }
}

//#Preview {
//    DevelopersViewController()
//}
