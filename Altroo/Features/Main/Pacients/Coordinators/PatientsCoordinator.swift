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

    init(navigation: UINavigationController, factory: AppFactory) {
        self.factory = factory
        self.navigation = navigation
    }
    
    func start() {
//        let vc = factory.makePatientsViewController()
//        navigation.setViewControllers([vc], animated: false)
        
        let vc = factory.makeAssociatePatientViewController(delegate: self)
        navigation.pushViewController(vc, animated: true)
    }
    
    enum Destination { case patientForms }

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
        }
    }
}

extension PatientsCoordinator: AssociatePatientViewControllerDelegate {
    func goToTutorialAddSheet() { }
    func goToMainFlow() { }
    func goToPatientForms() { show(.patientForms) }
    func goToComorbiditiesForms() {  }
    func goToShiftForms() {  }
}


extension PatientsCoordinator: ShiftFormsViewControllerDelegate {
    func shiftFormsDidFinish() {
        onFinish?()
    }
}

