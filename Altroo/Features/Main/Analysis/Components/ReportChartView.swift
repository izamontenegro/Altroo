//
//  ReportChartView.swift
//  Altroo
//
//  Created by Raissa Parente on 11/11/25.
//

import SwiftUI
import Charts

struct ReportDataSeries: Identifiable {
    let name: String
    let reportData: [ReportByAuthor]
    let color: Color
    var id: String { name }
}

struct ReportByAuthor: Equatable, Identifiable {
    var time: Date
    var reportCount: Int
    var id = UUID()
    
    static var cuidador1: [ReportByAuthor] {
        let calendar = Calendar.current
        let today = Date()
        let hours = [8, 10, 12, 14, 16, 18] // horários do dia
        
        return hours.map { hour in
            let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: today)!
            let count = Int.random(in: 1...10)
            return ReportByAuthor(time: date, reportCount: count)
        }
    }
    
    static var cuidador2: [ReportByAuthor] {
        let calendar = Calendar.current
        let today = Date()
        let hours = [9, 11, 13, 15, 17, 19]
        
        return hours.map { hour in
            let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: today)!
            let count = Int.random(in: 1...10)
            return ReportByAuthor(time: date, reportCount: count)
        }
    }
}

struct ReportChartView: View {
    let today = Date()
    var data: [ReportDataSeries] {
        [
            ReportDataSeries(name: "Cuidador 1", reportData: ReportByAuthor.cuidador1, color: .red30),
            ReportDataSeries(name: "Cuidador 2", reportData: ReportByAuthor.cuidador2, color: .blue30),
        ]
    }
    
    var body: some View {
        Chart {
            //lines
            ForEach(data, id: \.id) { caretaker in
                ForEach(caretaker.reportData, id: \.id) { data in
                    LineMark(x: .value("Hora", data.time),
                             y: .value("Registros", data.reportCount))
                }
                .interpolationMethod(.linear)
                .symbol(by: .value("Caretaker", caretaker.name))
                .foregroundStyle((caretaker.color))
            }
            
            
            //area
            ForEach(data, id: \.id) { caretaker in
                ForEach(caretaker.reportData, id: \.id) { data in
                    AreaMark(x: .value("Year", data.year),
                             y: .value("Population", data.population),
                             series: .value("Pet type", type.type),
                             stacking: .unstacked
                    )
                }
                .interpolationMethod(.linear)
                .foregroundStyle((caretaker.color.opacity(0.3)))
            }
        }
        .chartXScale(domain: today.startOfDay...today.endOfDay)
        .chartLegend(position: .bottom)
        .chartXAxis {
            AxisMarks(values: .stride(by: .hour, count: 2)) { value in
                AxisGridLine()
                AxisTick()
                if let date = value.as(Date.self) {
                    AxisValueLabel(format: .dateTime.hour(.defaultDigitsNoAMPM))
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
}

#Preview {
    ReportChartView()
}
struct PetData: Identifiable, Equatable {
    let year: Int
    
    // population is in million
    let population: Double
    
    var id: Int { year }
    
    static var catExample: [PetData] {
        [PetData(year: 2000, population: 8),
         PetData(year: 2010, population: 10),
         PetData(year: 2015, population: 8),
         PetData(year: 2022, population: 20)]
    }
    
    static var dogExample: [PetData] {
        [PetData(year: 2000, population: 6),
         PetData(year: 2010, population: 10),
         PetData(year: 2015, population: 5),
         PetData(year: 2022, population: 20)]
    }
    
    static var birdExample: [PetData] {
        [PetData(year: 2000, population: 2),
         PetData(year: 2010, population: 10),
         PetData(year: 2015, population: 5),
         PetData(year: 2022, population: 20)]
    }
    
}

struct PetDataSeries: Identifiable {
        let type: String
        let petData: [PetData]
    let color: Color
        var id: String { type }
}

struct GradientAreaChartExampleView: View {
    var allData: [PetDataSeries] { [
        PetDataSeries(type: "Cat", petData: PetData.catExample, color: .blue20),
        PetDataSeries(type: "Dog", petData: PetData.dogExample, color: .teal20),
        PetDataSeries(type: "Bird", petData: PetData.birdExample, color: .purple20)
        ]
    }

    var body: some View {
            Chart {
                ForEach(allData, id: \.id) { type in
                    ForEach(type.petData) { data in
                        AreaMark(x: .value("Year", data.year),
                                 y: .value("Population", data.population),
                                 series: .value("Pet type", type.type),
                                 stacking: .unstacked
                        )
                    }
                    .interpolationMethod(.linear)
                    .foregroundStyle(type.color.opacity(0.3))
                }
                
                ForEach(allData, id: \.id) { type in
                    
                    ForEach(type.petData) { data in
                        LineMark(x: .value("Year", data.year),
                                 y: .value("Population", data.population))
                    }
                    .interpolationMethod(.linear)
                    .symbol(by: .value("Pet type", type.type))
                    .foregroundStyle((type.color))
                }
                
            }
            .chartXScale(domain: 1998...2024)
            .chartLegend(position: .bottom)
            .chartXAxis {
                AxisMarks(values: [2000, 2010, 2015, 2022]) { value in
                    AxisGridLine()
                    AxisTick()
                    if let year = value.as(Int.self) {
                        AxisValueLabel(year.formatted(),
                                       centered: false,
                                       anchor: .top)
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .padding()
        }

}


extension Date {
    /// Retorna o início do dia (00:00)
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    /// Retorna o fim do dia (23:59:59)
    var endOfDay: Date {
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
}
