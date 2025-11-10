//
//  ProgressBarView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 10/11/25.
//

import UIKit

final class MedicalRecordProgressBarView: UIView {
    private let trackView = UIView()
    private let fillView = UIView()
    private let gradientLayer = CAGradientLayer()
    private var fillWidthConstraint: NSLayoutConstraint?
    
    var progress: CGFloat {
        didSet { updateProgress() }
    }
    
    init(
        height: CGFloat = 15,
        cornerRadius: CGFloat = 8,
        trackColor: UIColor = .blue80,
        startColor: UIColor = .blue10,
        endColor: UIColor = .blue50,
        progress: CGFloat
    ) {
        self.progress = progress
        super.init(frame: .zero)
        
        trackView.translatesAutoresizingMaskIntoConstraints = false
        trackView.backgroundColor = trackColor
        trackView.layer.cornerRadius = cornerRadius
        
        fillView.translatesAutoresizingMaskIntoConstraints = false
        fillView.layer.cornerRadius = cornerRadius
        fillView.clipsToBounds = true
        
        addSubview(trackView)
        trackView.addSubview(fillView)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        fillView.layer.insertSublayer(gradientLayer, at: 0)
        
        NSLayoutConstraint.activate([
            trackView.topAnchor.constraint(equalTo: topAnchor),
            trackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            trackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            trackView.heightAnchor.constraint(equalToConstant: height),
            
            fillView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor),
            fillView.centerYAnchor.constraint(equalTo: trackView.centerYAnchor),
            fillView.heightAnchor.constraint(equalTo: trackView.heightAnchor)
        ])
        
        fillWidthConstraint = fillView.widthAnchor.constraint(equalTo: trackView.widthAnchor, multiplier: 0)
        fillWidthConstraint?.isActive = true
        updateProgress()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = fillView.bounds
        gradientLayer.cornerRadius = fillView.layer.cornerRadius
    }
    
    private func updateProgress() {
        let clamped = max(0, min(1, progress))
        fillWidthConstraint?.isActive = false
        fillWidthConstraint = fillView.widthAnchor.constraint(equalTo: trackView.widthAnchor, multiplier: clamped)
        fillWidthConstraint?.isActive = true
        setNeedsLayout()
        layoutIfNeeded()
        gradientLayer.frame = fillView.bounds
    }
}
