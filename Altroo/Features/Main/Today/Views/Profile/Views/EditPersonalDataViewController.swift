//
//  EditPersonalDataViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 28/10/25.
//

import UIKit

final class EditPersonalDataViewController: GradientNavBarViewController {
    let viewModel: EditMedicalRecordViewModel
    
    weak var delegate: EditMedicalRecordViewControllerDelegate?
    
    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .pureWhite
        
        setupUI()
    }
    
    func setupUI() {
        let header = EditSectionHeaderView(sectionTitle: "Dados Pessoais", sectionDescription: "Preencha os campos a seguir quanto aos dados básicos da pessoa cuidada.", sectionIcon: "person.fill")
        header.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)

        ])
    }
    
    
    
}
