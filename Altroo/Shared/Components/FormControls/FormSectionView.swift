//
//  FormSectionView.swift
//  Altroo
//
//  Created by Raissa Parente on 09/10/25.
//
import UIKit

final class FormSectionView: UIStackView {
    private let contentContainer = UIView()
    var content: UIView
    
    private let errorStack = UIStackView()
    private let errorIcon = UIImageView()
    private var errorLabel = StandardLabel(
        labelText: "",
        labelFont: .sfPro,
        labelType: .subHeadline,
        labelColor: .red20,
        labelWeight: .regular
    )
        
    init(title: String, content: UIView, isObligatory: Bool = false, isSubsection: Bool = false, isCustomWidth: Bool = false) {
        self.content = content
        super.init(frame: .zero)
        axis = .vertical
        spacing = 8
        alignment = isCustomWidth ? .leading : .fill
        translatesAutoresizingMaskIntoConstraints = false
        
        //TITLE
        let titleLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: isSubsection ? .subHeadline : .callOut,
            labelColor: .black10,
            labelWeight: isSubsection ? .regular : .semibold
        )
        titleLabel.numberOfLines = 0
        
        //CONTENT
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        
        contentContainer.addSubview(content)
        content.pinToEdges(of: contentContainer)
        
        
        //ERROR
        if isObligatory {
            let attributed = NSMutableAttributedString(
                string: title,
                attributes: [
                    .font: titleLabel.font!,
                    .foregroundColor: UIColor.black10
                ]
            )
            let asterisk = NSAttributedString(
                string: " *",
                attributes: [
                    .font: titleLabel.font!,
                    .foregroundColor: UIColor.red10
                ]
            )
            attributed.append(asterisk)
            titleLabel.attributedText = attributed
        }
        
        let configuration = UIImage.SymbolConfiguration(textStyle: .caption1)
        errorIcon.image = UIImage(systemName: "exclamationmark.triangle", withConfiguration: configuration)
        errorIcon.tintColor = .red10
        errorIcon.setContentHuggingPriority(.required, for: .horizontal)
        errorLabel.numberOfLines = 0
        
        errorStack.axis = .horizontal
        errorStack.alignment = .center
        errorStack.spacing = 4
        errorStack.isHidden = true
        
        errorStack.addArrangedSubview(errorIcon)
        errorStack.addArrangedSubview(errorLabel)
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(contentContainer)
        
        addArrangedSubview(errorStack)
    }
    
    func setError(_ message: String?) {
        if let message, !message.isEmpty {
            errorLabel.updateLabelText(message)
            errorStack.isHidden = false
        } else {
            errorStack.isHidden = true
        }
    }
    
    func updateContent(_ newContent: UIView) {
        // remove old content
        content.removeFromSuperview()
        
        // replace reference
        content = newContent
        
        // add new content inside container
        contentContainer.addSubview(newContent)
        newContent.pinToEdges(of: contentContainer)
    }
    
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
