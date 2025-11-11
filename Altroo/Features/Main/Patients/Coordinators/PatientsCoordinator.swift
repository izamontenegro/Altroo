//
//  PatientsCoordinator.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 30/10/25.
//

import UIKit

final class PatientsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController
    private let factory: AppFactory //This helps decouple screen creation from navigation logic.
    
    var onFinish: (() -> Void)?
    
    private weak var tabBar: AppTabBarController?

    init(navigation: UINavigationController, factory: AppFactory) {
        self.factory = factory
        self.navigation = navigation
    }
    
    func start() {
        let vc = factory.makeAssociatePatientViewController(delegate: self, context: .patientSelection)
        navigation.pushViewController(vc, animated: true)
    }
    
    enum Destination { case patientForms, tutorialAdd, loading, mainFlow }

    private func show(_ destination: Destination) {
        switch destination {
        case .patientForms:
            let child = PatientFormsCoordinator(factory: factory)
            add(child: child)
            
            child.onFinish = { [weak self, weak child] in
                if let child = child { self?.remove(child: child) }
                self?.navigation.dismiss(animated: true)
                self?.onFinish?()
            }
            
            child.start()
            
            presentSheet(
                child.navigation,
                from: navigation,
                detents: [.large()],
                grabber: true
            )
            
        case .tutorialAdd:
            let vc = factory.makeTutorialAddSheet()
            presentSheet(vc, from: navigation)
            
        case .loading:
            // Go to the loading screen.
            let vc = factory.makeLoading()
            navigation.pushViewController(vc, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                // Animation for the transition from the loading screen to the today screen
                UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
                    self.navigation.view.alpha = 0.0
                }) { _ in
                    self.onFinish?()
                    UIView.animate(withDuration: 0.4) {
                        self.navigation.view.alpha = 1.0
                    }
                }
            }
            
        case .mainFlow:
            if let tabBar = navigation.tabBarController as? AppTabBarController {
                UIView.transition(
                    with: tabBar.view,
                    duration: 0.35,
                    options: [.transitionCrossDissolve, .curveEaseInOut],
                    animations: {
                        tabBar.selectedIndex = 2
                        tabBar.model.currentTab = .today
                    },
                    completion: { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            if let todayNav = tabBar.viewControllers?[2] as? UINavigationController,
                               let todayVC = todayNav.viewControllers.first(where: { $0 is TodayViewController }) as? TodayViewController {
                                todayVC.didTapProfileView()
                            }
                        }
                        self.onFinish?()
                    }
                )
            } else {
                onFinish?()
            }

        }
    }
}

extension PatientsCoordinator: AssociatePatientViewControllerDelegate {
    func goToMainFlow() { show(.mainFlow) }
    func goToPatientForms() { show(.patientForms) }
    func goToComorbiditiesForms() {  }
    func goToShiftForms() {  }
    func goToTutorialAddSheet() { show(.tutorialAdd) }
    func goToLoading() { show(.loading) }
}


extension PatientsCoordinator: ShiftFormsViewControllerDelegate {
    func shiftFormsDidFinish() {
        onFinish?()
    }
}

