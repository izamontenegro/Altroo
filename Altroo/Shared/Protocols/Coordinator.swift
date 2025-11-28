//
//  Coordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigation: UINavigationController { get set }
    func start() async
    func goToRoot()
}

extension Coordinator {
    func add(child: Coordinator) {
        childCoordinators.append(child)
    }
    func remove(child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
    func presentSheet(
        _ vc: UIViewController,
        from navigation: UINavigationController,
        percentage: CGFloat = 0.9,
        grabber: Bool = true,
        animated: Bool = true
    ) {
        vc.modalPresentationStyle = .pageSheet
        
        let detent = UISheetPresentationController.Detent.custom { context in
            context.maximumDetentValue * percentage
        }
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [detent, .large()]
            sheet.prefersGrabberVisible = grabber
            sheet.selectedDetentIdentifier = .large
        }
        
        navigation.present(vc, animated: animated)
    }
    
    func goToRoot() {
        navigation.popToRootViewController(animated: true)
    }
}
