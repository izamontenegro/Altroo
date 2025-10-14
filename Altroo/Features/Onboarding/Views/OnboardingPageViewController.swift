//
//  OnboardingPageViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 13/10/25.
//

import UIKit

class OnboardingPageViewController: UIViewController {
    private let titleText: String
    let showButton: Bool
    private let buttonTitle: String?
    
    let nextButton: StandardConfirmationButton
    private let bottomGradientLayer = CAGradientLayer()
    
    init(title: String, showButton: Bool = false, buttonTitle: String? = nil) {
        self.titleText = title
        self.showButton = showButton
        self.nextButton = StandardConfirmationButton(title: buttonTitle ?? "Próximo")
        self.buttonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite
        setupBottomGradient()
        setupLabelAndButton()
    }
    
    private func setupLabelAndButton() {
        let label = StandardLabel(
            labelText: titleText,
            labelFont: .comfortaa,
            labelType: .title3,
            labelColor: .black0
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.widthAnchor.constraint(lessThanOrEqualToConstant: 290)
        ])
        
        if showButton {
            view.addSubview(nextButton)
            nextButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                nextButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 32)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomGradientLayer.frame = view.bounds
    }
}
