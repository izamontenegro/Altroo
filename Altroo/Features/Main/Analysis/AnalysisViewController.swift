//
//  AnalysisViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit
import SwiftUI

class AnalysisViewController: GradientHeader {
    let viewModel: DailyReportViewModel
    
    private lazy var reportPicker: StandardSegmentedControl = {
        let sc = StandardSegmentedControl(
            items: ["Diário", "Mensal"],
            height: 35,
            backgroundColor: UIColor(resource: .white80),
            selectedColor: UIColor(resource: .blue30),
            selectedFontColor: UIColor(resource: .pureWhite),
            unselectedFontColor: UIColor(resource: .blue10),
            cornerRadius: 8
        )
        sc.setContentHuggingPriority(.defaultLow, for: .horizontal)
        sc.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return sc
    }()
    
    init(viewModel: DailyReportViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setNavbarItems(title: "Relatório", subtitle: "Preencha o período desejado e acompanhe de forma centralizada os registros feitos no aplicativo.", view: reportPicker)
        super.viewDidLoad()
        view.backgroundColor = .blue80

        let swiftUIView = DailyReportAppView(viewModel: viewModel)
        let hosting = UIHostingController(rootView: swiftUIView)
        
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
    }
}
