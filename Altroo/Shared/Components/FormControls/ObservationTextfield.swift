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

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(resource: .black40)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(resource: .white70)
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor(resource: .black10)
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    init(placeholder: String) {
        super.init(frame: .zero)
        placeholderLabel.text = placeholder
        setupLayout()
        textView.delegate = self
    }

    @MainActor required init?(coder: NSCoder) {
        super.init(coder: coder)
        placeholderLabel.text = "Digite algo..."
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor(resource: .black10)
        setupLayout()
        textView.delegate = self
    }

    private func setupLayout() {
        addSubview(textView)
        addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 72),

            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 12),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 20),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -20)
        ])

        updatePlaceholderVisibility()
    }

    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
        delegate?.observationView(self, didChangeText: textView.text)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
