//
//  AnalysisViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit
import SwiftUI

class AnalysisViewController: GradientNavBarViewController {
    let viewModel: DailyReportViewModel
    
    init(viewModel: DailyReportViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        showBackButton = false
        super.viewDidLoad()
        
        view.backgroundColor = .blue80

        let swiftUIView = DailyReportAppView(viewModel: viewModel)
        let hosting = UIHostingController(rootView: swiftUIView)
        
        addChild(hosting)
        view.addSubview(hosting.view)
        
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: view.topAnchor),
            hosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.mediumSpacing),
            hosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.mediumSpacing),
            hosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        hosting.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar(true)
    }
    
}
