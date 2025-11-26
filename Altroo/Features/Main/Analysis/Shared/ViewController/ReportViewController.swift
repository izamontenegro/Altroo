//
//  AnalysisViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit
import SwiftUI

class ReportViewController: GradientHeader {
    let viewModel: DailyReportViewModel
    
    private var hostingController: UIHostingController<AnyView>?
    
    private lazy var reportPicker: StandardSegmentedControl = {
        let sc = StandardSegmentedControl(
            items: ["Diário", "Periódico"],
            height: 35,
            backgroundColor: UIColor(resource: .white80),
            selectedColor: UIColor(resource: .blue30),
            selectedFontColor: UIColor(resource: .pureWhite),
            unselectedFontColor: UIColor(resource: .blue10),
            cornerRadius: 8
        )
        sc.setContentHuggingPriority(.defaultLow, for: .horizontal)
        sc.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let action1 = UIAction(title: "Diário", handler: { _ in
            self.setSwiftUIView(DailyReportAppView(viewModel: self.viewModel))
        })
        let action2 = UIAction(title: "Periódico", handler: {  _ in
            self.setSwiftUIView(IntervalReportAppView())
        })
        sc.setAction(action1, forSegmentAt: 0)
        sc.setAction(action2, forSegmentAt: 1)
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
        setNavbarItems(title: "report".localized, subtitle: "Selecione o período e veja um resumo dos seus registros, podendo exportar em PDF para compartilhar.")
        super.viewDidLoad()
        view.backgroundColor = .blue70
        
        setSwiftUIView(DailyReportAppView(viewModel: viewModel))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar(true)
        viewModel.feedArrays()
    }
    
    private func setSwiftUIView<V: View>(_ swiftUIView: V) {
           let anyView = AnyView(swiftUIView)
           
           if let hosting = hostingController {
               hosting.rootView = anyView
           } else {
               let hosting = UIHostingController(rootView: anyView)
               hostingController = hosting
               
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
       }
}
