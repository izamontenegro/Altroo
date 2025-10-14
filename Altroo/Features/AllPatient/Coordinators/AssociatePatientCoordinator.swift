//
//  AssociatePatientCoordinator.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 30/09/25.
//

import UIKit

final class AssociatePatientCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigation: UINavigationController
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

    enum Destination { case patientForms, comorbiditiesForms, shiftForms, tutorialAdd, mainFlow }

    private func show(_ destination: Destination) {
        switch destination {
        case .patientForms:
            let vc = factory.makePatientFormViewController(delegate: self)
            navigation.pushViewController(vc, animated: true)
        case .comorbiditiesForms:
            let vc = factory.makeComorbiditiesFormViewController(delegate: self)
            navigation.pushViewController(vc, animated: true)
        case .shiftForms:
            let vc = factory.makeShiftFormViewController(delegate: self)
            navigation.pushViewController(vc, animated: true)
        case .tutorialAdd:
            let vc = factory.makeTutorialAddSheet()
            vc.modalPresentationStyle = .pageSheet
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            navigation.present(vc, animated: true)
        case .mainFlow:
            onFinish?()
        }
    }
}

extension AssociatePatientCoordinator: AssociatePatientViewControllerDelegate {
    func goToMainFlow() { onFinish?() }
    func goToPatientForms() { show(.patientForms) }
    func goToComorbiditiesForms() { show(.comorbiditiesForms) }
    func goToShiftForms() { show(.shiftForms) }
    func goToTutorialAddSheet() { show(.tutorialAdd) }
}

extension AssociatePatientCoordinator: ShiftFormsViewControllerDelegate {
    func shiftFormsDidFinish() {
        onFinish?()
    }
}
