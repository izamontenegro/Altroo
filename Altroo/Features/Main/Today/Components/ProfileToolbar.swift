//
//  ProfileToolbar.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 14/10/25.
//

import UIKit
import SwiftUI

struct CurveCustom: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let centerX = rect.width / 2
            let radius = rect.width / 0.38

            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addArc(center: CGPoint(x: centerX, y: 0),
                        radius: radius,
                        startAngle: .degrees(0),
                        endAngle: .degrees(180),
                        clockwise: false)
            path.closeSubpath()
        }
    }
}

class ProfileToolbar: UIView {
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let curveView = UIHostingController(
            rootView: CurveCustom()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue10, Color.blue50]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 1630)
        )
        
        curveView.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(curveView.view)

        NSLayoutConstraint.activate([
            curveView.view.topAnchor.constraint(equalTo: topAnchor),
            curveView.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            curveView.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            curveView.view.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        let headerProfile = HeaderProfile(name: "teste", frame: CGRect(x: 0, y: 0, width: 300, height: 90))
        addSubview(headerProfile)
        
        
        let editButton = CapsuleWithCircleView()
        addSubview(editButton)
        
        NSLayoutConstraint.activate([
            headerProfile.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            headerProfile.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            headerProfile.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            headerProfile.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
}

#Preview {
    ProfileToolbar()
}
