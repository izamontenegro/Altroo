//
//  ReportItemRow.swift
//  Altroo
//
//  Created by Raissa Parente on 04/11/25.
//

import SwiftUI

struct ReportItemRow: View {
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
        VStack(alignment: .leading, spacing: 2) {
            
            //title
            HStack {
                Text(title)
                    .font(.callout)
                
                Spacer()
                
                Text("\(DateFormatterHelper.hourFormatter(date: time)) • \(author.abbreviatedName)")
                    .font(.system(size: 13))
                    .foregroundStyle(.blue20)
            }
            .padding(.bottom, Layout.verySmallSpacing)
            
            //content
            if let stoolColoration {
                HStack {
                    Text("Coloração:")
                        .font(.system(size: 13))
                        .foregroundStyle(.black20)
                    
                    Circle()
                        .frame(width: 14)
                        .foregroundStyle(Color(stoolColoration.color))
                    
                    Text("(\(stoolColoration.displayText))")
                        .font(.footnote)
                        .foregroundStyle(.black20)
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
                    
                    Text("(\(urineColoration.displayText))")
                        .font(.footnote)
                        .foregroundStyle(.black20)
                }
            }
            
            if let reception {
                Text("Aceitação: \(reception)")
                    .font(.footnote)
                    .foregroundStyle(.black20)
            }
            
            if let observation {
                Text("\("observation".localized): \(observation.isEmpty ? "--" : observation)")
                    .font(.footnote)
                    .foregroundStyle(.black20)
            }
        }
        .fontDesign(.rounded)
    }
}
