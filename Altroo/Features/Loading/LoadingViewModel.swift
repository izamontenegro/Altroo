//
//  LoadingViewModel.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 03/11/25.
//

import SwiftUI
import Combine

final class LoadingViewModel: ObservableObject {
    
    @Published var currentPhase: LoadingPhases = .ld1
    @Published var rotationAngle: Double = 0
    @Published var brightness: Bool = false
    @Published var loading: Bool = false
    @Published var showText: Bool = false
    
    private var timer: Timer?
    private var isAnimatingRotation = false
    
    func startLoading() {
        currentPhase = LoadingPhases.allCases.randomElement() ?? .ld1
        showText = true
        loading = true
        brightness = true
        
        startRotationCycle()
        startTextCycle()
    }
    
    func stopLoading() {
        timer?.invalidate()
        timer = nil
        isAnimatingRotation = false
    }
    
    private func startRotationCycle() {
        guard !isAnimatingRotation else { return }
        isAnimatingRotation = true
        
        func rotateCycle() {
            withAnimation(.easeIn(duration: 0.4)) {
                rotationAngle += 270
                brightness.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeOut(duration: 1.0)) {
                    self.rotationAngle += 90
                    self.brightness.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    rotateCycle()
                }
            }
        }
        rotateCycle()
    }
    
    private func startTextCycle() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1)) {
                let all = LoadingPhases.allCases.filter { $0 != self.currentPhase }
                self.currentPhase = all.randomElement() ?? .ld1
            }
        }
    }
}
