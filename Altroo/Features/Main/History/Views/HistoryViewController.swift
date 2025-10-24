//
//  HistoryViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit
import SwiftUI

protocol HistoryViewControllerDelegate: AnyObject {
    func openDetailSheet(_ controller: HistoryViewController)
}

final class HistoryViewController: UIViewController {
    weak var delegate: HistoryViewControllerDelegate?

    private var hosting: UIHostingController<HistoryView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let swiftUIView = HistoryView { [weak self] in
            guard let self else { return }
            self.delegate?.openDetailSheet(self)
        }
        let hosting = UIHostingController(rootView: swiftUIView)
        self.hosting = hosting

        addChild(hosting)
        view.addSubview(hosting.view)
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: view.topAnchor),
            hosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        hosting.didMove(toParent: self)
    }
}

#Preview {
    HistoryView()
}
