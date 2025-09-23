//
//  AppFactory.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

protocol AppFactory {
    // MARK: - ONBOARDING FLOW
    func makeWelcome(delegate: WelcomeViewControllerDelegate) -> UIViewController
    func makePatientForm(delegate: WelcomeViewControllerDelegate) -> UIViewController
    func makeComorbiditiesForms(delegate: ComorbiditiesFormsViewControllerDelegate) -> UIViewController
    
    // MARK: - MAIN FLOW
    func makeToday() -> UIViewController
    func makeHistory() -> UIViewController
    func makeAnalysis() -> UIViewController
    func makeAddItemSheet(delegate: AddItemsSheetViewControllerDelegate) -> UIViewController
    
    func makeAddMedicine() -> UIViewController
    
}
