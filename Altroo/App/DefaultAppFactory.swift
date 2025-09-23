//
//  DefaultAppFactory.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//
import UIKit

final class DefaultAppFactory: AppFactory {
    
    private let patientService: PatientService

    init(patientService: PatientService) {
        self.patientService = patientService
    }
    
    // MARK: - ONBOARDING FLOW
    
    func makeWelcome(delegate: WelcomeViewControllerDelegate) -> UIViewController {
        let vc = WelcomeViewController()
        vc.title = "Welcome!"
        vc.delegate = delegate
        return vc
    }
    
    func makePatientForm(delegate: WelcomeViewControllerDelegate) -> UIViewController {
        let vc = PatientFormsViewController()
        vc.title = "Patient Forms"
        vc.delegate = delegate
        return vc
    }
    
    func makeComorbiditiesForms(delegate: ComorbiditiesFormsViewControllerDelegate) -> UIViewController {
        let vc = ComorbiditiesFormsViewController()
        vc.title = "Comorbidities Forms"
        vc.delegate = delegate
        return vc
    }
    

    // MARK: - MAIN FLOW
    
    func makeToday() -> UIViewController {
        let vc = TodayViewController()
        vc.title = "Hoje"
        return vc
    }

    func makeHistory() -> UIViewController {
        let vc = HistoryViewController()
        vc.title = "Histórico"
        return vc
    }

    func makeAnalysis() -> UIViewController {
        let vc = AnalysisViewController()
        vc.title = "Análise"
        return vc
    }

    func makeAddItemSheet(delegate: AddItemsSheetViewControllerDelegate) -> UIViewController {
        let vc = AddItemsSheetViewController()
        vc.title = "Adicionar"
        vc.delegate = delegate
        return vc
    }
    
    
    
    
    func makeAddMedicine() -> UIViewController {
        let vc = AddMedicineViewController()
        return vc
    }
}
