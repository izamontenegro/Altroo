//
//  TaskInfoEspecificView.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 20/11/25.
//

import SwiftUI

struct TaskInfoEspecificView: View {
    
    let title: String?
    let observation: String?
    
    init(title: String? = nil, observation: String?) {
        self.title = title
        self.observation = observation
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                if let title {
                    Text("Título")
                        .font(.title3)
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                        .foregroundStyle(.blue20)
                    Text(title)
                        .font(.title3)
                        .fontWeight(.regular)
                        .fontDesign(.rounded)
                        .foregroundStyle(.black10)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if let observation {
                    Text("Observação")
                        .font(.title3)
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                        .foregroundStyle(.blue20)
                    Text("\(observation.isEmpty ? "Sem observações." : observation)")
                        .font(.title3)
                        .fontWeight(.regular)
                        .fontDesign(.rounded)
                        .foregroundStyle(.black10)
                }
            }
        }
    }
}
