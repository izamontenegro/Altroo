//
//  HistoryViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import SwiftUI
import UIKit

protocol HistoryViewControllerDelegate: AnyObject {
    func openDetailSheet(_ controller: HistoryViewController, item: HistoryItem)
}

final class HistoryViewController: GradientHeader {
    let viewModel: HistoryViewModel
    weak var delegate: HistoryViewControllerDelegate?
    
    private var hosting: UIHostingController<HistoryView>?
    
    init(viewModel: HistoryViewModel,
         delegate: HistoryViewControllerDelegate? = nil,
         hosting: UIHostingController<HistoryView>? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.hosting = hosting
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        setNavbarItems(title: "Histórico", subtitle: "Preencha o período desejado e acompanhe de forma centralizada os registros feitos no aplicativo.")

        super.viewDidLoad()
        
        view.backgroundColor = .blue80

        let swiftUIView = HistoryView(viewModel: viewModel)
        
        let hosting = UIHostingController(rootView: swiftUIView)
        self.hosting = hosting
        
        addChild(hosting)
        view.addSubview(hosting.view)
        
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: gradientView.bottomAnchor),
            hosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        hosting.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar(true)
        if viewModel.sections.isEmpty { viewModel.reloadHistory() }
    }
    
}

