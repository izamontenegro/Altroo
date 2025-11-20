//
//  HydratationInfoEspecificView.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 20/11/25.
//

import SwiftUI

struct HydrationInfoEspecificView: View {
    
    let added: String?
    
    init(added: String? = nil) {
        self.added = added
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let added {
                Text("Adicionados")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.blue20)
                    .fontDesign(.rounded)
                Text(added)
                    .font(.title3)
                    .fontWeight(.regular)
                    .fontDesign(.rounded)
                    .foregroundStyle(.black10)
            }
        }
    }
}
