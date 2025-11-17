////
////  ReportChartView.swift
////  Altroo
////
////  Created by Raissa Parente on 11/11/25.
////
//
//import SwiftUI
//import Charts
//
//struct ReportDataSeries: Identifiable {
//    let name: String
//    let reportData: [ReportByAuthor]
//    let color: Color
//    var id: String { name }
//}
//
//struct ReportByAuthor: Equatable, Identifiable {
//    var time: Date
//    var reportCount: Int
//    var id = UUID()
//    
//    static var cuidador1: [ReportByAuthor] {
//        let calendar = Calendar.current
//        let today = Date()
//        let hours = [8, 10, 12, 14, 16, 18] // horários do dia
//        
//        return hours.map { hour in
//            let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: today)!
//            let count = Int.random(in: 1...10)
//            return ReportByAuthor(time: date, reportCount: count)
//        }
//    }
//    
//    static var cuidador2: [ReportByAuthor] {
//        let calendar = Calendar.current
//        let today = Date()
//        let hours = [9, 11, 13, 15, 17, 19]
//        
//        return hours.map { hour in
//            let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: today)!
//            let count = Int.random(in: 1...10)
//            return ReportByAuthor(time: date, reportCount: count)
//        }
//    }
//}
//
//struct ReportChartView: View {
//    let today = Date()
//    var data: [ReportDataSeries] {
//        [
//            ReportDataSeries(name: "Cuidador 1", reportData: ReportByAuthor.cuidador1, color: .red30),
//            ReportDataSeries(name: "Cuidador 2", reportData: ReportByAuthor.cuidador2, color: .blue30),
//        ]
//    }
//    
//    var body: some View {
//        Chart {
//            //lines
//            ForEach(data, id: \.id) { caretaker in
//                ForEach(caretaker.reportData, id: \.id) { data in
//                    LineMark(x: .value("Hora", data.time),
//                             y: .value("Registros", data.reportCount))
//                }
//                .interpolationMethod(.linear)
//                .symbol(by: .value("Caretaker", caretaker.name))
//                .foregroundStyle((caretaker.color))
//            }
//            
//            
//            //area
//            ForEach(data, id: \.id) { caretaker in
//                ForEach(caretaker.reportData, id: \.id) { data in
//                    AreaMark(x: .value("Year", data.year),
//                             y: .value("Population", data.population),
//                             series: .value("Pet type", type.type),
//                             stacking: .unstacked
//                    )
//                }
//                .interpolationMethod(.linear)
//                .foregroundStyle((caretaker.color.opacity(0.3)))
//            }
//        }
//        .chartXScale(domain: today.startOfDay...today.endOfDay)
//        .chartLegend(position: .bottom)
//        .chartXAxis {
//            AxisMarks(values: .stride(by: .hour, count: 2)) { value in
//                AxisGridLine()
//                AxisTick()
//                if let date = value.as(Date.self) {
//                    AxisValueLabel(format: .dateTime.hour(.defaultDigitsNoAMPM))
//                }
//            }
//        }
//        .aspectRatio(1, contentMode: .fit)
//        .padding()
//    }
//}
//
//#Preview {
//    ReportChartView()
//}
//
//
//
//extension Date {
//    var startOfDay: Date {
//        Calendar.current.startOfDay(for: self)
//    }
//    
//    var endOfDay: Date {
//        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
//    }
//}
