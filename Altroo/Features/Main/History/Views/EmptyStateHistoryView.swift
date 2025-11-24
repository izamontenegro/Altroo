//
//  EmptyStateHistoryView.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 21/11/25.
//

import SwiftUI

struct EmptyStateHistoryView: View {
    var body: some View {
        ZStack {
            Color.blue80
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 16) {
                Image("emptyState")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 305)
                
                VStack(spacing: 8) {
                    Text("history_empty".localized)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.blue20)
                    Text("history_empty_2".localized)
                        .font(.title3)
                        .fontWeight(.regular)
                        .foregroundStyle(.black40)
                }
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            }
            .padding(.bottom, 100)
        }
    }
}

#Preview {
    EmptyStateHistoryView()
}
