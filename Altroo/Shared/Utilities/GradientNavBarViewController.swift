//
//  GradientNavBarViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 07/10/25.
//

import UIKit

class GradientNavBarViewController: UIViewController {
    var rightButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite
        configureNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        desconfigureNavBar()
    }
    
    private func desconfigureNavBar() {
        guard let nav = navigationController else { return }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.tintColor = .systemBlue
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private func configureNavBar() {
        guard let nav = navigationController else { return }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundImage = makeGradientNavBarImage()

        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.tintColor = .white
    
        configureNavBarButtons()
    }
    
    private func configureNavBarButtons() {
        let back = UIButton(type: .system)
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.setTitle(" Voltar", for: .normal)
        back.titleLabel?.font = .systemFont(ofSize: 17)
        back.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back)

        if let rightButton = rightButton {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        }
    }

    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func makeGradientNavBarImage() -> UIImage? {
        let height: CGFloat = 98
        let width: CGFloat = UIScreen.main.bounds.width
        let size = CGSize(width: width, height: height)

        let layer = CAGradientLayer()
        layer.frame = CGRect(origin: .zero, size: size)

        let firstColor = UIColor(named: "blue10")!.resolvedColor(with: traitCollection).cgColor
        let secondColor = UIColor(named: "blue50")!.resolvedColor(with: traitCollection).cgColor
        layer.colors = [firstColor, secondColor]
        layer.cornerRadius = 10

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in layer.render(in: context.cgContext) }
    }
}

// MARK: - HOW TO APPLY

final class GradientNavBarPreviewViewController: GradientNavBarViewController {
    
    override func viewDidLoad() {
        let btn = UIButton(type: .system)
        btn.setTitle("Edit 🛠️", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17)
        btn.addTarget(self, action: #selector(salvarTapped), for: .touchUpInside)
        rightButton = btn
        super.viewDidLoad()
    }

    @objc private func salvarTapped() {
        print("Edit button tapped")
    }
}

//#Preview {
//    UINavigationController(rootViewController: GradientNavBarPreviewViewController())
//}
