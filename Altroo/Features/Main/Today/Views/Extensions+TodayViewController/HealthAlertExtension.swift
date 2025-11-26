//
//  HealthAlertExtension.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/11/25.
//

import UIKit
import SwiftUI

extension TodayViewController {
        
    func showHealthDataAlert() {
        guard let tabBarVC = self.tabBarController else { return }

        let dim = UIView(frame: tabBarVC.view.bounds)
        dim.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dim.alpha = 0
        dim.tag = 998
        dimmingView = dim
        tabBarVC.view.addSubview(dim)

        let alertVC = UIHostingController(
            rootView: HealthDataAlertView(
                onClose: { [weak self] in self?.closeHealthAlert() },
                onPrivacyPolicy: { [weak self] in
                    self?.dismissHealthAlertUI()
                    self?.delegate?.goToPrivacyPolicy()
                },
                onLegalNotice: { [weak self] in
                    self?.dismissHealthAlertUI()
                    self?.delegate?.goToLegalNotice()
                }
            )
        )
        
        alertVC.view.backgroundColor = .clear
        let alert = alertVC.view!
        
        alert.translatesAutoresizingMaskIntoConstraints = false
        alert.tag = 999
        alert.layer.shadowColor = UIColor.black.cgColor
        alert.layer.shadowOpacity = 0.3
        alert.layer.shadowRadius = 10
        alert.layer.shadowOffset = .zero
        alert.alpha = 0

        tabBarVC.addChild(alertVC)
        tabBarVC.view.addSubview(alert)
        alertVC.didMove(toParent: tabBarVC)

        NSLayoutConstraint.activate([
            alert.centerXAnchor.constraint(equalTo: tabBarVC.view.centerXAnchor),
            alert.centerYAnchor.constraint(equalTo: tabBarVC.view.centerYAnchor)
        ])

        UIView.animate(withDuration: 0.3) {
            dim.alpha = 1
            alert.alpha = 1
        }
    }

    @objc private func closeHealthAlert() {
        UserDefaults.standard.healthAlertSeen = true
        dismissHealthAlertUI()
    }
    
    private func dismissHealthAlertUI() {
        guard let tabBarVC = self.tabBarController else { return }

        tabBarVC.view.subviews
            .filter { $0.tag == 999 }
            .forEach { view in
                UIView.animate(withDuration: 0.2, animations: {
                    view.alpha = 0
                }, completion: { _ in
                    view.removeFromSuperview()
                })
            }

        tabBarVC.view.subviews
            .filter { $0.tag == 998 }
            .forEach { dim in
                UIView.animate(withDuration: 0.2, animations: {
                    dim.alpha = 0
                }, completion: { _ in
                    dim.removeFromSuperview()
                })
            }

        self.dimmingView = nil
    }
}
