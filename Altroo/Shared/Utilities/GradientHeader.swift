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
    
    private var didSetInsets = false
    
    private var gradientView: UIView!
    private var stack: UIStackView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupGradientHeader()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let gradientView, !didSetInsets else { return }

        let headerHeight = gradientView.frame.height
        let safeTop = view.safeAreaInsets.top
        let newInset = max(0, headerHeight - safeTop)
        additionalSafeAreaInsets.top = newInset
        didSetInsets = true
    }

    private func setupGradientHeader() {
        if gradientView != nil { return }

        gradientView = UIView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gradientView)
        
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(named: "blue10")!.cgColor,
            UIColor(named: "blue50")!.cgColor
        ]
        gradient.cornerRadius = 24
        gradientView.layer.insertSublayer(gradient, at: 0)
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
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
        
        stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = Layout.smallSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        if let insideView {
            stack.addArrangedSubview(insideView)
        }
        
        gradientView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 80),
            stack.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: Layout.mediumSpacing),
            stack.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -Layout.mediumSpacing),
            stack.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -Layout.hugeSpacing)
        ])
        
        gradientView.layoutIfNeeded()
        gradient.frame = gradientView.bounds
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    func setNavbarItems(title: String, subtitle: String, view: UIView? = nil) {
        self.navTitle = title
        self.subtitle = subtitle
        self.insideView = view
    }
}


