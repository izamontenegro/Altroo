//
//  OnboardingPageViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 13/10/25.
//

import UIKit

class OnboardingPageViewController: UIViewController {
    private let titleText: String
    private let descriptionText: String
    private let bottomGradientLayer = CAGradientLayer()
    private var imageView = UIImageView()
    private let imageHeightMultiplier: CGFloat

    init(imageName: String, title: String, description: String, imageHeightMultiplier: CGFloat = 0.65) {
        self.titleText = title
        self.descriptionText = description
        self.imageHeightMultiplier = imageHeightMultiplier

        super.init(nibName: nil, bundle: nil)
        
        if let image = UIImage(named: imageName) {
            imageView.image = image
        }
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBottomGradient()
    }
    
    private func setupLayout() {
        view.backgroundColor = .pureWhite
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: imageHeightMultiplier)
        ])

        let titleLabel = StandardLabel(
            labelText: titleText,
            labelFont: .comfortaa,
            labelType: .title2,
            labelColor: .black0
        )
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center

        let descriptionLabel = StandardLabel(
            labelText: descriptionText,
            labelFont: .comfortaa,
            labelType: .body,
            labelColor: .black10.withAlphaComponent(0.75)
        )
        descriptionLabel.numberOfLines = 3
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -120)
        ])

    }
    
    private func setupBottomGradient() {
        bottomGradientLayer.colors = [
            UIColor.pureWhite.cgColor,
            UIColor(resource: .teal70).cgColor
        ]
        bottomGradientLayer.locations = [0, 1]
        bottomGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.75)
        bottomGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        bottomGradientLayer.frame = view.bounds
        view.layer.insertSublayer(bottomGradientLayer, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomGradientLayer.frame = view.bounds
    }
}

import SwiftUI
#Preview {
    OnboardingPageViewController(
        imageName: "onboarding2",
        title: "Sem mais bagunça",
        description: "Gerencie tarefas, medicamentos e ocorrências em um só lugar"
    )
}
