//
//  ObservationTextfield.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 16/10/25.
//

import UIKit

protocol ObservationViewDelegate: AnyObject {
    func observationView(_ view: ObservationView, didChangeText text: String)
}

final class ObservationView: UIView, UITextViewDelegate {
    
    weak var delegate: ObservationViewDelegate?
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(resource: .white70)
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor(resource: .black10)
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 16,
                                                   bottom: 16, right: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
        textView.delegate = self
    }
    
    private func setupLayout() {
        addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 72)
        ])
        
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        delegate?.observationView(self, didChangeText: textView.text)
    }
}

class ViewController: UIViewController {
    private let observationView = ObservationView()
    private var observationText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        observationView.delegate = self
        
        view.addSubview(observationView)
        observationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            observationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            observationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            observationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

extension ViewController: ObservationViewDelegate {
    func observationView(_ view: ObservationView, didChangeText text: String) {
        observationText = text
        print("Texto atualizado: \(observationText)")
        
        // saveToCoreData(text: observationText)
    }
}

import SwiftUI

struct ObservationViewPreview: UIViewRepresentable {
    func makeUIView(context: Context) -> ObservationView {
        ObservationView()
    }
    
    func updateUIView(_ uiView: ObservationView, context: Context) {}
}

//#Preview {
//    ObservationViewPreview()
//        .padding()
//}
