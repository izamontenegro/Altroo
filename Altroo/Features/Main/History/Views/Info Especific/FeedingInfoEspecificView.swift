//
//  FeedingInfoEspecificView.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 20/11/25.
//

import SwiftUI

struct FeedingInfoEspecific: View {
    
    let category: String?
    let reception: String?
    let observation: String?
    
    init(category: String? = nil, reception: String? = nil, observation: String?) {
        self.category = category
        self.reception = reception
        self.observation = observation
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 50) {
                VStack(alignment: .leading, spacing: 4) {
                    if let category {
                        Text("category".localized)
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(.blue20)
                            .fontDesign(.rounded)
                        Text(category)
                            .font(.title3)
                            .fontWeight(.regular)
                            .fontDesign(.rounded)
                            .foregroundStyle(.black10)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    if let reception {
                        Text("acceptance".localized)
                            .font(.title3)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                            .foregroundStyle(.blue20)
                        Text(reception)
                            .font(.title3)
                            .fontWeight(.regular)
                            .fontDesign(.rounded)
                            .foregroundStyle(.black10)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if let observation {
                    Text("observation".localized)
                        .font(.title3)
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                        .foregroundStyle(.blue20)
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
