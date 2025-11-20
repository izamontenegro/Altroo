//
//  UrineInfoEspecificView.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 20/11/25.
//

import SwiftUI

struct UrineInfoEspecificView: View {
    
    let urineColoration: UrineColorsEnum?
    let observation: String?
    
    init(urineColoration: UrineColorsEnum? = nil, observation: String?) {
        self.urineColoration = urineColoration
        self.observation = observation
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                if let urineColoration {
                    Text("Coloração")
                        .font(.title3)
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                        .foregroundStyle(.blue20)
                    
                    HStack(spacing: 8) {
                        Text("\(urineColoration.displayText)")
                            .font(.title3)
                            .fontWeight(.regular)
                            .fontDesign(.rounded)
                            .foregroundStyle(.black10)
                        ZStack {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(.blue80)
                                .frame(width: 45, height: 25)
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(urineColoration.color))
                                .frame(width: 39, height: 19)
                        }
                    }
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
