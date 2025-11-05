//
//  DailyReportItem.swift
//  Altroo
//
//  Created by Raissa Parente on 04/11/25.
//

import SwiftUI

struct DailyReportItem: View {
    let title: String
    
    let stoolColoration: StoolColorsEnum?
//    let urineColoration: StoolColorsEnum?
    let reception: String?

    let observation: String?
    let time: Date
    let author: String
    
    init(title: String, stoolColoration: StoolColorsEnum? = nil, reception: String? = nil, observation: String?, time: Date, author: String) {
        self.title = title
        self.stoolColoration = stoolColoration
        self.reception = reception
        self.observation = observation
        self.time = time
        self.author = author
    }
    
    var body: some View {
        VStack (spacing: Layout.smallSpacing) {
            HStack {
                StandardLabelRepresentable(
                    labelFont: .sfPro,
                    labelType: .callOut,
                    labelWeight: .regular,
                    text: title,
                    color: UIColor.black10
                )
                
                Spacer()
                
                Text("\(DateFormatterHelper.hourFormatter(date: time)) • \(author)")
                    .fontDesign(.rounded)
                    .font(.footnote)
                    .foregroundStyle(.blue20)
            }
            
            if let stoolColoration {
                HStack {
                    Text("Coloração:")
                        .fontDesign(.rounded)
                        .font(.footnote)
                        .foregroundStyle(.black20)
                    
                    Circle()
                        .frame(width: 16)
                        .foregroundStyle(.urineYellow)
                    
                    
                    StandardLabelRepresentable(
                        labelFont: .sfPro,
                        labelType: .footnote,
                        labelWeight: .regular,
                        text: "(Amarelo Claro)",
                        color: UIColor.black20
                    )
                }
            }
            
            if let reception {
                StandardLabelRepresentable(
                    labelFont: .sfPro,
                    labelType: .footnote,
                    labelWeight: .regular,
                    text: "Aceitação: \(reception)",
                    color: UIColor.black20
                )
            }
            
            if let observation {
                StandardLabelRepresentable(
                    labelFont: .sfPro,
                    labelType: .footnote,
                    labelWeight: .regular,
                    text: "Observação: \(observation)",
                    color: UIColor.black20
                )
            }
        }
    }
}

