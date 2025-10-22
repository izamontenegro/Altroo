//
//  TutorialAddSheet.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 30/09/25.
//

import UIKit

class TutorialAddSheet: UIViewController {

    private lazy var closeButton: UIBarButtonItem = {
        return UIBarButtonItem(
            title: "Fechar",
            style: .plain,
            target: self,
            action: #selector(didTapClose)
        )
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 50
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .pureWhite
        setupNavigationBar()
        setupIconViews()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = ""
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func makeIconView(text: String) -> PulseIcon {
        let iconView = PulseIcon(text: text,
                                 color: UIColor(resource: .teal10),
                                 iconColor: UIColor(resource: .pureWhite),
                                 shadowColor: UIColor(resource: .teal60))
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 60),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor)
        ])
        
        return iconView
    }
    
    private func setupIconViews() {
        let icon1 = makeIconView(text: "1")
        let icon2 = makeIconView(text: "2")
        let icon3 = makeIconView(text: "3")
        
        stackView.addArrangedSubview(icon1)
        stackView.addArrangedSubview(icon2)
        stackView.addArrangedSubview(icon3)
        
        view.addSubview(stackView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -250)
        ])
    }
}

//#Preview {
//    UINavigationController(rootViewController: TutorialAddSheet())
//}
