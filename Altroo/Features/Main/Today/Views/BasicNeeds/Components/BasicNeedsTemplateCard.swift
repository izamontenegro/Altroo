//
//  BasicNeedsTemplateCard.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 17/11/25.
//

import SwiftUI

struct BasicNeedsTemplateCard: View {
    let imageName: String
    let subtitle: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 5) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(5.4)
                    .frame(width: 110)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(subtitle.uppercased())
                        .foregroundStyle(.black20)
                        .font(.callout)
                    Text(title)
                        .font(.callout)
                        .foregroundStyle(.blue20)
                        .fontWeight(.medium)
                }
                
                Spacer()
            }
        }
        .buttonStyle(.plain)
        .padding(8)
        .background(Color.blue80)
        .frame(maxHeight: 160)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: Color.blue40.opacity(0.1), radius: 10, x: 2, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue70.opacity(0.6), lineWidth: 6)
                .blur(radius: 4)
                .offset(x: -2, y: -4)
                .mask(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [.black, .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        )

        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}
