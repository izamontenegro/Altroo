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
    
    private let defaultHeight: CGFloat = 20
    private var defaultWidth: CGFloat { defaultHeight * 1.8 }
    
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
    override var intrinsicContentSize: CGSize {
            return CGSize(width: defaultWidth, height: defaultHeight)
     }
    
    private func setupView() {
        backgroundColor = .clear
        
        backgroundView.backgroundColor = offColor
        backgroundView.layer.cornerRadius = defaultHeight / 2
        backgroundView.layer.shadowColor = UIColor.black10.cgColor
        backgroundView.layer.shadowOpacity = 0.2
        backgroundView.layer.shadowOffset = CGSize(width: 2, height: 2)
        backgroundView.layer.shadowRadius = 3
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        thumbView.backgroundColor = offThumbColor
        thumbView.layer.cornerRadius = (defaultHeight - 8) / 2
        thumbView.layer.shadowColor = UIColor.black10.cgColor
        thumbView.layer.shadowOpacity = 0.2
        thumbView.layer.shadowOffset = CGSize(width: 1, height: 1)
        thumbView.layer.shadowRadius = 2
        thumbView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(thumbView)
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggle))
        addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let thumbSize = bounds.height - 8
        
        backgroundView.frame = bounds
        backgroundView.layer.cornerRadius = bounds.height / 2
        
        let thumbY = (bounds.height - thumbSize) / 2
        let thumbX = isOn ? bounds.width - thumbSize - 4 : 4
        thumbView.frame = CGRect(x: thumbX, y: thumbY, width: thumbSize, height: thumbSize)
        thumbView.layer.cornerRadius = thumbSize / 2
        
        backgroundView.backgroundColor = isOn ? onColor : offColor
        thumbView.backgroundColor = isOn ? onThumbColor : offThumbColor
    }
    
    // MARK: - Actions
    @objc func toggle() {
        print(">> toggle() chamado, estado atual: \(isOn)")

        setOn(!isOn, animated: true)
        sendActions(for: .valueChanged)
    }
    
    func setOn(_ on: Bool, animated: Bool) {
        print(">> setOn chamado com \(on)")
        guard isOn != on else { return }
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
