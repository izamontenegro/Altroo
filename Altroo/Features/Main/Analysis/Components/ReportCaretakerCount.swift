//
//  ReportCaretakerCount.swift
//  Altroo
//
//  Created by Raissa Parente on 07/11/25.
//


 import SwiftUI

    struct ReportCaretakerCount: View {
        let name: String
        let count: Int
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(name.abbreviatedName)
                        .font(.callout)
                    Spacer()
                    Text("\(count) registros")
                        .font(.footnote)
                        .foregroundStyle(.black30)
                }
                Divider()
            }
        }
    }
