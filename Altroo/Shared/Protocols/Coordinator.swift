//
//  Coordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
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
    
//    func presentSheet(
//        _ vc: UIViewController,
//        from navigation: UINavigationController,
//        detents: [UISheetPresentationController.Detent] = [.medium()],
//        grabber: Bool = true,
//        animated: Bool = true
//    ) {
//        vc.modalPresentationStyle = .pageSheet
//        
//        if let sheet = vc.sheetPresentationController {
//            sheet.detents = detents
//            sheet.prefersGrabberVisible = grabber
//        }
//        
//        navigation.present(vc, animated: animated)
//    }
    
    func presentSheet(_ vc: UIViewController, from presenter: UIViewController, percentage: Double) {
        vc.modalPresentationStyle = .pageSheet

        if let sheet = vc.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
            
            let eightyID = UISheetPresentationController.Detent.Identifier("eightyPercent")
            sheet.detents = [
                .custom(identifier: eightyID) { context in
                    percentage * context.maximumDetentValue
                },
                .large()
            ]
            sheet.selectedDetentIdentifier = eightyID
            sheet.largestUndimmedDetentIdentifier = eightyID
            
        }

        presenter.present(vc, animated: true)
    }
    
    func goToRoot() {
        navigation.popToRootViewController(animated: true)
    }
}
