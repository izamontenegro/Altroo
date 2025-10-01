//
//  AssociateAssistedCoordinator.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 30/09/25.
//

import UIKit

final class AssociatePatientCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    private let navigation: UINavigationController
    private let patientService: PatientService
    private let factory: AssociateAssistedFactory

    var onFinish: (() -> Void)?

    init(navigation: UINavigationController, patientService: PatientService, factory: AssociateAssistedFactory) {
        self.navigation = navigation
        self.patientService = patientService
        self.factory = factory
    }

    func start() {
        let vc = factory.makeAssociateAssisted(delegate: self)
        navigation.setViewControllers([vc], animated: false)
        navigation.setNavigationBarHidden(false, animated: false)
    }
    
    enum Destination { case patientForms, comorbiditiesForms, shiftForms, tutorialAdd }
    
    private func show(destination: Destination) {
        switch destination {
        case .patientForms:
            let vc = factory.makePatientForm(delegate: self)
            navigation.pushViewController(vc, animated: true)
            
        case .comorbiditiesForms:
            let vc = factory.makeComorbiditiesForms(delegate: self)
            navigation.pushViewController(vc, animated: true)
            
        case .shiftForms:
            let vc = factory.makeShiftForms(delegate: self)
            navigation.pushViewController(vc, animated: true)
            
        case .tutorialAdd:
            let vc = factory.makeTutorialAddSheet()
            vc.modalPresentationStyle = .pageSheet
            
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            
            navigation.present(vc, animated: true)
        }
    }
}

extension AssociateAssistedCoordinator: AssociateAssistedViewControllerDelegate {
    func goToPatientForms() {
        show(destination: .patientForms)
    }
    
    func goToComorbiditiesForms() {
        show(destination: .comorbiditiesForms)
    }

    func goToShiftForms() {
        show(destination: .shiftForms)
    }
    
    func goToTutorialAddSheet() {
        show(destination: .tutorialAdd)
    }
}

extension AssociateAssistedCoordinator: ShiftFormsViewControllerDelegate {
    func shiftFormsDidFinish() {
        onFinish?()
    }
}
