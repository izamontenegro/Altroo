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
        let vc = factory.makeAssociatePatientViewController(delegate: self, context: .associatePatient)
        navigation.pushViewController(vc, animated: true)
    }
    
    func receivePatient(_ patient: CareRecipient) {
        let vc = factory.makeAssociatePatientViewController(delegate: self, context: .associatePatient)
        navigation.pushViewController(vc, animated: true)
        show(.receivingPatient, patient: patient)
    }
    
    enum Destination { case patientForms, tutorialAdd, loading, mainFlow, receivingPatient }
    
    private func show(_ destination: Destination, patient: CareRecipient? = nil) {
        switch destination {
        case .patientForms:
            // Go to the patient creation form.
            let child = PatientFormsCoordinator(factory: factory)
            add(child: child)
            
            child.onFinish = { [weak self, weak child] in
                if let child = child { self?.remove(child: child) }
                self?.navigation.dismiss(animated: true)
                self?.goToLoading()
            }
            
            child.start()
            
            presentSheet(
                child.navigation,
                from: navigation, percentage: 0.9
            )
            
        case .tutorialAdd:
            // Go to the tutorial on adding a patient.
            let vc = factory.makeTutorialAddSheet()
            presentSheet(
                vc,
                from: navigation, percentage: 0.9
            )
            
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
            // Go to the Today screen (main navigation flow).
            onFinish?()
            
        case .receivingPatient:
            let child = PatientFormsCoordinator(factory: factory)
            add(child: child)
            
            child.onFinish = { [weak self, weak child] in
                if let child = child { self?.remove(child: child) }
                self?.navigation.dismiss(animated: true)
                self?.goToLoading()
            }
            
            guard let patient = patient else { return }
            child.associateNewCaregiver(to: patient)
            
            presentSheet(
                child.navigation,
                from: navigation, percentage: 0.9
            )
        }
    }
}

extension AssociatePatientCoordinator: AssociatePatientViewControllerDelegate {
    func goToMainFlow() { onFinish?() }
    func goToPatientForms() { show(.patientForms) }
    func goToComorbiditiesForms() {  }
    func goToShiftForms(receivedPatientViaShare: Bool = false, patient: CareRecipient? = nil) {  }
    func goToTutorialAddSheet() { show(.tutorialAdd) }
    func goToLoading() { show(.loading) }
}
