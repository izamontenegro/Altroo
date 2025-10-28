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
    private var imageViews: [UIImageView] = []
    private var animations: [(_ imageView: UIImageView) -> Void] = []
    private var imageHeights: [CGFloat?] = []

    init(imageNames: [String], imageHeights: [CGFloat?] = [], title: String, description: String, animations: [(_ imageView: UIImageView) -> Void]) {
        self.titleText = title
        self.descriptionText = description
        self.animations = animations
        self.imageHeights = imageHeights

        super.init(nibName: nil, bundle: nil)
        
        self.imageViews = imageNames.compactMap { name in
            guard let image = UIImage(named: name) else { return nil }
            let iv = UIImageView(image: image)
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBottomGradient()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImages()
    }

    private func setupLayout() {
        view.backgroundColor = .pureWhite
        for iv in imageViews {
            view.addSubview(iv)
            NSLayoutConstraint.activate([
                iv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.mediumSpacing),
                iv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                iv.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            
            if let image = iv.image {
                let aspect = image.size.height / image.size.width
                
                let heightConstraint = iv.heightAnchor.constraint(equalTo: iv.widthAnchor, multiplier: aspect)
                heightConstraint.isActive = imageHeights.isEmpty
                
                let maxHeightConstraint = iv.heightAnchor.constraint(lessThanOrEqualToConstant: 400)
                maxHeightConstraint.isActive = true
            }
        }


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

        if let lastImageView = imageViews.last {
            NSLayoutConstraint.activate([
                textStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
                textStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                textStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                textStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                textStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
            ])
        }

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
    
//    private func animateImages() {
//        for iv in imageViews {
//            iv.layer.removeAllAnimations()
//            iv.alpha = 1
//            iv.transform = .identity
//        }
//
//        for (index, iv) in imageViews.enumerated() {
//            guard index < animations.count else { continue }
//            animations[index](iv)
//        }
//    }
    
    private func animateImages() {
        // 🔄 reseta tudo antes de animar
        for iv in imageViews {
            iv.layer.removeAllAnimations()
            iv.alpha = 1
            iv.transform = .identity
        }

        // 🔥 executa as animações definidas externamente
        for (index, iv) in imageViews.enumerated() {
            guard index < animations.count else { continue }
            animations[index](iv)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomGradientLayer.frame = view.bounds
    }
}

import Lottie

extension OnboardingPageViewController {
    @discardableResult
    func addLottieAnimation(named name: String) -> Self {
        let animationView = LottieAnimationView(name: name)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor)
        ])
        
        animationView.play()
        return self
    }
}


import SwiftUI
#Preview {
    OnboardingPageViewController(
        imageNames: [],
        title: "Sem mais bagunça",
        description: "Gerencie necessidades básicas, medicamentos, tarefas, ocorrências, tudo em um só lugar",
        animations: []
    ).addLottieAnimation(named: "onboarding_page2")
}
