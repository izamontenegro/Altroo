//
//  BasicNeedsColorCard.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 17/11/25.
//
import SwiftUI

struct BasicNeedsColorCard: View {
    let colorName: UIColor
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            VStack(alignment: .leading, spacing: 5) {
                RoundedRectangle(cornerRadius: 5.4)
                    .foregroundStyle(Color(uiColor: colorName))
                    .frame(height: 30)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("COR")
                        .foregroundStyle(.black20)
                        .font(.system(size: 13))
                    Text(title)
                        .font(.system(size: 13))
                        .foregroundStyle(.blue20)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false,
                                        vertical: true) 
                }
                
                Spacer()
            }
        })
        .buttonStyle(.plain)
        .padding(4)
        .background {
            Color.blue80
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    BasicNeedsColorCard(
        colorName: .brown,
        title: "title",
        isSelected: true,
        action: {
            print("button tapped")
        }
    )
}
