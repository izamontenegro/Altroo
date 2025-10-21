//
//  StandardTextfield.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//
import UIKit

class StandardTextfield: UITextField {
    
    private var textfieldWidth: CGFloat
    private var textfieldHeight: CGFloat
    private var containerView = UIView()
    
    init(width: CGFloat, height: CGFloat, placeholder: String) {
        self.textfieldWidth = width
        self.textfieldHeight = height
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(width: 370, height: 38, placeholder: "")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    }
    
    // MARK: - Setup
    private func setupView() {

        self.textAlignment = .left
        self.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.borderStyle = .none
        self.backgroundColor = UIColor(resource: .white70)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.textColor = UIColor(resource: .black10)
        self.backgroundColor = UIColor(resource: .white70)
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: textfieldWidth),
            self.heightAnchor.constraint(equalToConstant: textfieldHeight)
        ])
    
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: containerView.topAnchor),
            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    func asView() -> UIView {
        return containerView
    }
}

import SwiftUI

private struct TextfieldPreviewWrapper: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let field = StandardTextfield(
            width: 370,
            height: 38,
            placeholder: "Maria Clara"
        )
        
        return field.asView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

//#Preview {
//    TextfieldPreviewWrapper()
//        .padding()
//}


class TestTextfield: UITextField {
    
//    private var textfieldWidth: CGFloat
//    private var textfieldHeight: CGFloat
    private var containerView = UIView()
    
//    init(width: CGFloat, height: CGFloat, placeholder: String) {
//        self.textfieldWidth = width
//        self.textfieldHeight = height
//        super.init(frame: .zero)
//
//        self.placeholder = placeholder
//        setupView()
//    }
    
    init(placeholder: String = "") {
        super.init(frame: .zero)
        self.placeholder = placeholder
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    convenience init() {
//        self.init(width: 370, height: 38, placeholder: "")
//    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    }
    
    // MARK: - Setup
    private func setupView() {

        self.textAlignment = .left
        self.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.borderStyle = .none
        self.backgroundColor = UIColor(resource: .white70)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.textColor = UIColor(resource: .black10)
        self.backgroundColor = UIColor(resource: .white70)
        self.translatesAutoresizingMaskIntoConstraints = false

//        NSLayoutConstraint.activate([
//            self.widthAnchor.constraint(equalToConstant: textfieldWidth),
//            self.heightAnchor.constraint(equalToConstant: textfieldHeight)
//        ])
//
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(self)
//
//        NSLayoutConstraint.activate([
//            self.topAnchor.constraint(equalTo: containerView.topAnchor),
//            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
//        ])
    }
    
    func asView() -> UIView {
        return containerView
    }
    
    override var intrinsicContentSize: CGSize {
            CGSize(width: UIView.noIntrinsicMetric, height: 38)
    }
}
