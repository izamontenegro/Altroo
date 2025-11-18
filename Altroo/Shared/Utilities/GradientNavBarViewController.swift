//
//  GradientNavBarViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 07/10/25.
//

import UIKit

class GradientNavBarViewController: UIViewController {
    var rightButton: UIButton?
    var isRightButtonCancel = false
    var showBackButton: Bool = true
    var text: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        configureNavBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        configureNavBarTitle()
    }
    
    private func configureNavBarButtons() {
        if showBackButton {
            let back = UIButton(type: .system)
            back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            back.setTitle("back".localized, for: .normal)
            back.titleLabel?.font = .systemFont(ofSize: 17)
            back.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back)
        } else {
            navigationItem.leftBarButtonItem = nil
        }
        
        if isRightButtonCancel {
            let cancel = UIButton(type: .system)
            cancel.setTitle("cancel".localized, for: .normal)
            cancel.titleLabel?.font = .systemFont(ofSize: 17)
            cancel.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancel)
        }

        if let rightButton = rightButton {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        }
    }
    
    private func configureNavBarTitle() {
        guard let text else { return }
        
        let title = StandardLabel(labelText: text, labelFont: .sfPro, labelType: .body, labelColor: .white)
        navigationItem.titleView = title
    }

    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func handleCancel() {
        navigationController?.popToRootViewController(animated: true)
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
    
    func setNavbarTitle(_ title: String) {
        self.text = title
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
