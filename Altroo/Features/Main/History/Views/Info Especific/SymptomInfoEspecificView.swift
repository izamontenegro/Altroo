//
//  SymptomInfoEspecificView.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 20/11/25.
//

import SwiftUI

struct SymptomInfoEspecificView: View {
    
    let title: String?
    let observation: String?
    
    init(title: String? = nil, observation: String? = nil) {
        self.title = title
        self.observation = observation
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                if let title {
                    Text("title".localized)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.blue20)
                        .fontDesign(.rounded)
                    Text(title)
                        .font(.title3)
                        .fontWeight(.regular)
                        .fontDesign(.rounded)
                        .foregroundStyle(.black10)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if let observation {
                    Text("observation".localized)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.blue20)
                        .fontDesign(.rounded)
                    Text("\(observation.isEmpty ? "no_observations".localized : observation)")
                        .font(.title3)
                        .fontWeight(.regular)
                        .fontDesign(.rounded)
                        .foregroundStyle(.black10)
                }
            }
        }
    }
}
