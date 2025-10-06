//
//  StandardTextfield.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//
import UIKit

class StandardTextfield: UITextField {
    init() {
        super.init(frame: .zero)
        borderStyle = .roundedRect
        backgroundColor = UIColor(resource: .teal80)
        font = UIFont.systemFont(ofSize: 18)
        placeholder = "Maria Clara"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK: PREVIEW
import SwiftUI
private struct TextfieldPreviewWrapper: UIViewRepresentable {
    func updateUIView(_ uiView: StandardTextfield, context: Context) {
    }
    
    func makeUIView(context: Context) -> StandardTextfield {
        return StandardTextfield()
    }
}

#Preview {
    TextfieldPreviewWrapper()
}

