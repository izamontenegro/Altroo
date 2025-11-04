//
//  AssociatePatientCoordinator.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 30/09/25.
//

import UIKit

final class AssociatePatientCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController
    private let factory: AssociatePatientFactory

    var onFinish: (() -> Void)?

    init(navigation: UINavigationController, factory: AssociatePatientFactory) {
        self.navigation = navigation
        self.factory = factory
    }

    func start() {
        let vc = factory.makeAssociatePatientViewController(delegate: self)
        navigation.pushViewController(vc, animated: true)
    }

    enum Destination { case patientForms, tutorialAdd, mainFlow }

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
        case .mainFlow:
            onFinish?()
        }
    }
}

extension AssociatePatientCoordinator: AssociatePatientViewControllerDelegate {
    func goToMainFlow() { onFinish?() }
    func goToPatientForms() { show(.patientForms) }
    func goToComorbiditiesForms() {  }
    func goToShiftForms() {  }
    func goToTutorialAddSheet() { show(.tutorialAdd) }
}

extension AssociatePatientCoordinator: ShiftFormsViewControllerDelegate {
    func shiftFormsDidFinish() {
        onFinish?()
    }
}
