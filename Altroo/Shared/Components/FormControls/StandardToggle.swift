//
//  StandardToggle.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//
import UIKit

class StandardToggle: UIControl {
    
    private let backgroundView = UIView()
    private let thumbView = UIView()
    
    private(set) var isOn = false
    
    var onColor: UIColor = .blue30
    var offColor: UIColor = .white70
    var onThumbColor: UIColor = .white70
    var offThumbColor: UIColor = .pureWhite
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupGesture()
    }
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .clear
        
        let height = bounds.height
        let width = height * 1.8
        if frame.width != width {
            frame.size.width = width
        }
        backgroundView.frame = bounds
        backgroundView.layer.cornerRadius = height / 2
        
        backgroundView.backgroundColor = offColor
        backgroundView.layer.shadowColor = UIColor.black10.cgColor
        backgroundView.layer.shadowOpacity = 0.2
        backgroundView.layer.shadowOffset = CGSize(width: 2, height: 2)
        backgroundView.layer.shadowRadius = 3
        
        
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        
        thumbView.backgroundColor = offThumbColor
        thumbView.layer.shadowColor = UIColor.black10.cgColor
        thumbView.layer.shadowOpacity = 0.2
        thumbView.layer.shadowOffset = CGSize(width: 1, height: 1)
        thumbView.layer.shadowRadius = 2
        
        addSubview(thumbView)
        thumbView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggle))
        addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = bounds.height
        let width = height * 1.8
        let thumbSize = bounds.height - 8
        
        if frame.width != width {
            frame.size.width = width
        }
        
        backgroundView.frame = bounds
        backgroundView.layer.cornerRadius = height / 2
        
        let thumbY = (height - thumbSize) / 2
        let thumbX = isOn ? width - thumbSize - 4 : 4
        thumbView.frame = CGRect(x: thumbX, y: thumbY, width: thumbSize, height: thumbSize)
        thumbView.layer.cornerRadius = thumbSize / 2
    }
    
    // MARK: - Actions
    @objc private func toggle() {
        setOn(!isOn, animated: true)
        sendActions(for: .valueChanged)
    }
    
    func setOn(_ on: Bool, animated: Bool) {
        isOn = on
        let thumbSize = bounds.height - 8
        let newX = on ? bounds.width - thumbSize - 4 : 4
        
        UIView.animate(withDuration: animated ? 0.4 : 0.0,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: [.curveEaseInOut]) {
            
            self.thumbView.frame.origin.x = newX
            self.thumbView.backgroundColor = on ? self.onThumbColor : self.offThumbColor
            self.backgroundView.backgroundColor = on ? self.onColor : self.offColor
        }
    }
}

import SwiftUI

private struct StandardTogglePreviewWrapper: UIViewRepresentable {
    func updateUIView(_ uiView: StandardToggle, context: Context) { }
    
    func makeUIView(context: Context) -> StandardToggle {
        return StandardToggle()
    }
}

//#Preview {
//    StandardTogglePreviewWrapper()
//        .frame(width: 50, height: 30)
//}

// TODO: USAR ISSO NA VIEW CONTROLLER !!
//class ViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.systemGray6
//
//        let toggle = StandardToggle(frame: CGRect(x: 100, y: 200, width: 50, height: 30))
//        toggle.onColor = UIColor.systemTeal
//        toggle.offColor = UIColor.systemGray5
//        view.addSubview(toggle)
//
//        toggle.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
//    }
//
//    @objc func switchChanged(_ sender: StandardToggle) {
//        print("Switch state: \(sender.isOn)")
//    }
//}
