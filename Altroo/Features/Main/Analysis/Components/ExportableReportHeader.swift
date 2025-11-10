//
//  ExportableReportHeader.swift
//  Altroo
//
//  Created by Raissa Parente on 07/11/25.
//
import SwiftUI

struct ExportableReportHeader: View {
    let title: String
    let registerStartDate: Date
    var registerEndDate: Date? = nil
    var registerStartTime: Date? = nil
    var registerEndTime: Date? = nil

    let exportDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Image("altroohorizontal")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            }
            
            HStack {
                Text("Período: ")
                //daily
                if let start = registerStartTime, let end = registerEndTime {
                    Text("\(DateFormatterHelper.longDayYearString(from: registerStartDate)) • \(DateFormatterHelper.timeHMString(from: start)) às \(DateFormatterHelper.timeHMString(from: end))")
                    .fontWeight(.medium)
                }

            }
            .font(.callout)
            
            HStack {
                Text("Exportado: ")
                Text(DateFormatterHelper.longDayYearString(from: exportDate))
                    .fontWeight(.medium)
            }
            .font(.callout)
            
            Text("O relatório gerado pelo Altroo é totalmente baseado nos registros feitos pelo usuário no aplicativo. Caso alguma informação não apareça, significa que ela não foi registrada.")
                .font(.subheadline)
        }
        .fontDesign(.rounded)
        .foregroundStyle(.black10)
    }
}
