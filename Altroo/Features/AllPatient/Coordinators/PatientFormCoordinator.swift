//
//  PatientFormCoordinator.swift
//  Altroo
//
//  Created by Raissa Parente on 29/10/25.
//
import UIKit

final class PatientFormsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController
    private let factory: AssociatePatientFactory
    var onFinish: (() -> Void)?

    init(factory: AssociatePatientFactory) {
        self.factory = factory
        self.navigation = UINavigationController()
    }

    func start() {
        goToPatientForms()
    }
}

extension PatientFormsCoordinator: AssociatePatientViewControllerDelegate {
    func goToMainFlow() { onFinish?() }
    func goToPatientForms() {
        let vc = factory.makePatientFormViewController(delegate: self)
        navigation.setViewControllers([vc], animated: false)
    }
    func goToComorbiditiesForms() {
        let vc = factory.makeComorbiditiesFormViewController(delegate: self)
        navigation.pushViewController(vc, animated: true)
    }
    func goToShiftForms() {
        let vc = factory.makeShiftFormViewController(delegate: self)
        navigation.pushViewController(vc, animated: true)
    }
    func goToTutorialAddSheet() { }
}

//extension PatientFormsCoordinator: PatientFormViewControllerDelegate {
//    func goToComorbidities() {
//        let vc = factory.makeComorbiditiesFormViewController(delegate: self)
//        navigation.pushViewController(vc, animated: true)
//    }
//}
//
//extension PatientFormsCoordinator: ComorbiditiesFormViewControllerDelegate {
//    func goToShiftForms() {
//        let vc = factory.makeShiftFormViewController(delegate: self)
//        navigation.pushViewController(vc, animated: true)
//    }
//}
//

extension PatientFormsCoordinator: ShiftFormsViewControllerDelegate {
    func shiftFormsDidFinish() {
        onFinish?()
    }
}
