//
//  AppTabBarController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

final class AppTabBarController: UITabBarController {
    var onPlusTapped: (() -> Void)?

    private let plusButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "plus"), for: .normal)
        b.backgroundColor = .systemBlue
        b.tintColor = .white
        b.layer.cornerRadius = 28
        b.layer.shadowOpacity = 0.2
        b.layer.shadowRadius = 6
        b.layer.shadowOffset = .init(width: 0, height: 4)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(plusButton)
        plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
        tabBar.itemPositioning = .centered
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size: CGFloat = 56
        plusButton.frame = CGRect(
            x: view.bounds.width - size - 16,
            y: tabBar.frame.minY - size/2 - 8,
            width: size,
            height: size
        )
    }

    @objc private func didTapPlus() { onPlusTapped?() }
}
