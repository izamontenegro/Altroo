//
//  OnboardingPageViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 13/10/25.
//

import UIKit

class OnboardingPageViewController: UIViewController {
    private let imageName: String
    private let titleText: String
    private let descriptionText: String
    private let bottomGradientLayer = CAGradientLayer()

    init(imageName: String, title: String, description: String) {
        self.imageName = imageName
        self.titleText = title
        self.descriptionText = description
        super.init(nibName: nil, bundle: nil)
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
        view.backgroundColor = .systemBackground

        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

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

        let textStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        textStack.axis = .vertical
        textStack.spacing = 8
        textStack.alignment = .fill
        textStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textStack)

        var constraints = [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            textStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            textStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            textStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            textStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ]

        if let image = imageView.image {
            let aspectRatio = image.size.height / image.size.width
            constraints.append(
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: aspectRatio)
            )
        }

        NSLayoutConstraint.activate(constraints)
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
    OnboardingPageViewController(imageName: "onboard1",
                                             title: "Bem-vindo!",
                                             description: "Conheça nosso aplicativo.")

}
