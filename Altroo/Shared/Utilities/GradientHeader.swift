//
//  GradientHeader.swift
//  Altroo
//
//  Created by Raissa Parente on 29/10/25.
//
import UIKit

class GradientHeader: UIViewController {
    var navTitle: String?
    var subtitle: String?
    var insideView: UIView?
    
    let gradientView = UIView()
    private let stack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientHeader()
    }

    func setupGradientHeader() {
        guard gradientView.superview == nil else { return }

        // MARK: - Gradient View
        view.addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(named: "blue10")!.cgColor,
            UIColor(named: "blue50")!.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 24
        gradientView.layer.insertSublayer(gradientLayer, at: 0)

        let titleLabel = StandardLabel(
            labelText: navTitle ?? "",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .white,
            labelWeight: .semibold
        )

        let subtitleLabel = StandardLabel(
            labelText: subtitle ?? "",
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .blue80
        )
        subtitleLabel.numberOfLines = 0

        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = Layout.smallSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        if let insideView { stack.addArrangedSubview(insideView) }

        gradientView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 80),
            stack.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: Layout.mediumSpacing),
            stack.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -Layout.mediumSpacing),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: gradientView.bottomAnchor, constant: -Layout.largeSpacing)
        ])
        
        let bottomConstraint = gradientView.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: Layout.largeSpacing)
        bottomConstraint.priority = .defaultHigh
        bottomConstraint.isActive = true


        gradientView.layoutIfNeeded()
        gradientLayer.frame = gradientView.bounds
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = gradientView.bounds
        }
    }

    func setNavbarItems(title: String, subtitle: String, view: UIView? = nil) {
        self.navTitle = title
        self.subtitle = subtitle
        self.insideView = view
    }
}
