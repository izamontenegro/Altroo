//
//  InfoRowPill.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 24/10/25.
//
import SwiftUI

struct InfoRowPill: View {
    let left: String
    let right: String
    var rightEmphasis: Bool = true
    
    var body: some View {
        HStack {
            Text(left)
                .font(.body)
                .fontDesign(.rounded)
                .foregroundStyle(.secondary)
            Spacer()
            Text(right)
                .fontDesign(.rounded)
                .font(.body.weight(.medium))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(.blue80))
        )
    }
}

#Preview {
    InfoRowPill(left: "Left", right: "Right")
}
