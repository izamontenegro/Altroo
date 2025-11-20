//
//  StoolInfoEspecificView.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 20/11/25.
//

import SwiftUI

struct StoolInfoEspecificView: View {
    
    let type: StoolTypesEnum?
    let stoolColoration: StoolColorsEnum?
    let observation: String?
    
    init(type: StoolTypesEnum? = nil, stoolColoration: StoolColorsEnum? = nil, observation: String? = nil) {
        self.type = type
        self.stoolColoration = stoolColoration
        self.observation = observation
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 40) {
                VStack(alignment: .leading, spacing: 4) {
                    if let type {
                        Text("Tipo")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(.blue20)
                            .fontDesign(.rounded)
                        Text("\(type.displayText)")
                            .font(.title3)
                            .fontWeight(.regular)
                            .fontDesign(.rounded)
                            .foregroundStyle(.black10)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    if let stoolColoration {
                        Text("Coloração")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(.blue20)
                        HStack(spacing: 8) {
                            Text("\(stoolColoration.displayText)")
                                .font(.title3)
                                .fontWeight(.regular)
                                .fontDesign(.rounded)
                                .foregroundStyle(.black10)
                            ZStack {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(.blue80)
                                    .frame(width: 45, height: 25)
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color(stoolColoration.color))
                                    .frame(width: 39, height: 19)
                            }
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
