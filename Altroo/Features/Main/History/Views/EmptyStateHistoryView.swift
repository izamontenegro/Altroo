//
//  EmptyStateHistoryView.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 21/11/25.
//

import SwiftUI

struct EmptyStateHistoryView: View {
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Color.blue80
                    .ignoresSafeArea(edges: .all)
                
                Text("Você ainda não registrou nenhuma atividade.")
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundStyle(.black40)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}
