//
//  CareRecipientInitialsView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 09/10/25.
//

import UIKit

class CareRecipientInitialsCircleView: UIView {
    let careRecipientName: String
    
    init(careRecipientName: String) {
        self.careRecipientName = careRecipientName
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewDidLoad() {
        addSubview(setupLayout())
    }
    
    func setupLayout() -> UIView {
        let avatar = UIView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.backgroundColor = .blue30
        avatar.layer.cornerRadius = 35
        avatar.layer.masksToBounds = true
        avatar.layer.borderColor = UIColor.pureWhite.cgColor
        avatar.layer.borderWidth = 4

        let initials = initialsFromName(careRecipientName)

        let initialsLabel = StandardLabel(
            labelText: careRecipientName.getInitials(),
            labelFont: .sfPro,
            labelType: .title1,
            labelColor: .pureWhite,
            labelWeight: .regular
        )
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false

        avatar.addSubview(initialsLabel)

        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 70),
            avatar.heightAnchor.constraint(equalToConstant: 70),
            initialsLabel.centerXAnchor.constraint(equalTo: avatar.centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor)
        ])

        return avatar
    }

}

private extension CareRecipientInitialsCircleView {
    func initialsFromName(_ name: String) -> String {
        let comps = name.split(separator: " ")
        let initials = comps.prefix(2).compactMap { $0.first?.uppercased() }.joined()
        return initials.isEmpty ? "?" : initials
    }
}
