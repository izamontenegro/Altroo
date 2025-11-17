//
//  BasicNeedsColorCard.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 17/11/25.
//

import SwiftUI

struct BasicNeedsColorCard: View {
    let colorName: String
    let title: String
    
    let action: (() -> Void)
    
    @State var isSelected: Bool = false
    var body: some View {
            Button(action: {
                action()
                isSelected.toggle()
            }, label: {
                VStack(alignment: .leading, spacing: 5) {
                   
                    RoundedRectangle(cornerRadius: 5.4)
                        .foregroundStyle(Color(colorName))
                        .frame(maxWidth: 54, maxHeight: 30)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("COR")
                            .foregroundStyle(.black20)
                            .font(.footnote)
                        Text(title)
                            .font(.footnote)
                            .foregroundStyle(.blue20)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                }
            })
            .buttonStyle(.plain)
            .padding(6)
            .background {
                Color.blue80
            }
            .frame(maxWidth: 65, maxHeight: 95)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
    }
}

#Preview {
    BasicNeedsColorCard(colorName: "urineLight", title: "title", action: {
        print("button tapped")
    })
}
