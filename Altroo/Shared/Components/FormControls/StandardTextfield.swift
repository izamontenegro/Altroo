//
//  StandardTextfield.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//
import UIKit
import SwiftUI




class StandardTextfield: UITextField {
    private var containerView = UIView()

    
    init(placeholder: String = "") {
        super.init(frame: .zero)
        self.placeholder = placeholder
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    }
    
    func asView() -> UIView {
        return containerView
    }
    
    override var intrinsicContentSize: CGSize {
            CGSize(width: UIView.noIntrinsicMetric, height: 38)
    }
}

private struct TextfieldPreviewWrapper: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let field = StandardTextfield(
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
