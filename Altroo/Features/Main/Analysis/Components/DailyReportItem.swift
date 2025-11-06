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
    let urineColoration: UrineColorsEnum?
    let reception: String?

    let observation: String?
    let time: Date
    let author: String
    
    init(title: String, stoolColoration: StoolColorsEnum? = nil, urineColoration: UrineColorsEnum? = nil, reception: String? = nil, observation: String?, time: Date, author: String) {
        self.title = title
        self.stoolColoration = stoolColoration
        self.urineColoration = urineColoration
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
                    .font(.system(size: 13))
                    .foregroundStyle(.blue20)
            }
            
            if let stoolColoration {
                HStack {
                    Text("Coloração:")
                        .fontDesign(.rounded)
                        .font(.system(size: 13))
                        .foregroundStyle(.black20)
                    
                    Circle()
                        .frame(width: 14)
                        .foregroundStyle(Color(stoolColoration.color))
                    
                    
                    StandardLabelRepresentable(
                        labelFont: .sfPro,
                        labelType: .footnote,
                        labelWeight: .regular,
                        text: "(\(stoolColoration.displayText))",
                        color: UIColor.black20
                    )
                }
            }
            
            if let urineColoration {
                HStack {
                    Text("Coloração:")
                        .fontDesign(.rounded)
                        .font(.system(size: 13))
                        .foregroundStyle(.black20)
                    
                    Circle()
                        .frame(width: 14)
                        .foregroundStyle(Color(urineColoration.color))
                    
                    
                    StandardLabelRepresentable(
                        labelFont: .sfPro,
                        labelType: .footnote,
                        labelWeight: .regular,
                        text: "(\(urineColoration.displayText))",
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

