//
//  PersonalData.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/10/25.
//

import UIKit

protocol EditProfileViewControllerDelegate: AnyObject {
    func goToHealthProblems()
}

class EditPersonalDataViewController: GradientNavBarViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        let header = EditMedicalRecordSectionHeader(title: "Dados Pessoais", subtitle: "Preencha os campos a seguir quanto aos dados básicos da pessoa cuidada.")
        
        header.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 15
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainStack.addArrangedSubview(header)
        mainStack.addArrangedSubview(setupForms())
        
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
    }
    
    private func setupForms() -> UIView {
        let nameTextField = StandardTextfield()
        nameTextField.placeholder = "Nome do assistido"
        nameTextField.backgroundColor = .white70
        nameTextField.textColor = .black10
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
       
        let nameForms = FormSectionView(title: "Nome", content: nameTextField)
        
        return nameForms
    }
}

#Preview {
    UINavigationController(rootViewController:  EditPersonalDataViewController())
   
}
