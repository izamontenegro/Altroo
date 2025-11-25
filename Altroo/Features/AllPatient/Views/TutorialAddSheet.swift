//
//  TutorialAddSheet.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 30/09/25.
//

import UIKit

class TutorialAddSheet: UIViewController {
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Layout.mediumSpacing
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .pureWhite
        configureNavBar()
        setupContent()
    }
    
    private func makeIconView(text: String) -> PulseIcon {
        let iconView = PulseIcon(text: text, color: UIColor(resource: .teal30), iconColor: .pureWhite, shadowColor: UIColor(resource: .teal60))
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 50),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor)
        ])
        
        return iconView
    }
    
    private func setupContent() {
        let mainTitle = StandardLabel(
            labelText: "Tutorial",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        mainTitle.numberOfLines = 0
        
        let subTitle = StandardLabel(
            labelText: "tutorial_subtitle".localized,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black30,
            labelWeight: .regular
        )
        subTitle.numberOfLines = 0
        
        stackView.addArrangedSubview(mainTitle)
        stackView.setCustomSpacing(0, after: mainTitle)
        stackView.addArrangedSubview(subTitle)
        
        let line1 = makeLine(title: "step_one_title".localized, description: "step_one_subtitle".localized, iconText: "1")
        let line2 = makeLine(title: "step_two_title".localized, description: "step_two_subtitle".localized, iconText: "2")
        let line3 = makeLine(title: "step_three_title".localized, description: "step_three_subtitle".localized, iconText: "3")
        
        stackView.addArrangedSubview(line1)
        stackView.addArrangedSubview(line2)
        stackView.addArrangedSubview(line3)
        
        view.addSubview(stackView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Layout.largeSpacing),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Layout.mediumSpacing),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: safeArea.trailingAnchor, constant: -Layout.mediumSpacing)
        ])
    }
    
    private func makeLine(title: String, description: String, iconText: String) -> UIStackView {
        let titleLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .teal10,
            labelWeight: .medium
        )
        titleLabel.numberOfLines = 0

        let descriptionLabel = StandardLabel(
            labelText: description,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black10,
            labelWeight: .regular
        )
        descriptionLabel.numberOfLines = 0

        let textStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        textStack.axis = .vertical
        textStack.spacing = 0
        textStack.alignment = .leading
        textStack.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let iconView = makeIconView(text: iconText)
        iconView.setContentHuggingPriority(.required, for: .horizontal)

        let lineStack = UIStackView(arrangedSubviews: [iconView, textStack])
        lineStack.axis = .horizontal
        lineStack.spacing = 16
        lineStack.alignment = .center
        lineStack.translatesAutoresizingMaskIntoConstraints = false
        lineStack.distribution = .fill

        return lineStack
    }
    
    private func configureNavBar() {
        let closeButton = UIBarButtonItem(title: "close".localized, style: .done, target: self, action: #selector(didTapClose))
        closeButton.tintColor = .blue30
        navigationItem.leftBarButtonItem = closeButton

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

}

//#Preview {
//    UINavigationController(rootViewController: TutorialAddSheet())
//}
