//
//  AddSymptomViewModel.swift
//  Altroo
//
//  Created by Raissa Parente on 13/10/25.
//
import Foundation
import Combine

class AddSymptomViewModel {
    @Published var name: String = ""
    @Published var time: [DateComponents] = []
    @Published var date: Date = .now
    @Published var note: String = ""
}
