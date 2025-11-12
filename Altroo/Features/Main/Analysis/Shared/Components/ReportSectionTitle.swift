//
//  ReportSectionTitle.swift
//  Altroo
//
//  Created by Raissa Parente on 07/11/25.
//

import SwiftUI

struct ReportSectionTitle: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.title3)
            .foregroundStyle(.blue20)
            .fontDesign(.rounded)
            .fontWeight(.medium)
    }
}
