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
    
    private var rotationTimer: Timer?
    private var isRotating = false
    
    func startLoading() {
        currentPhase = LoadingPhases.allCases.randomElement() ?? .ld1
        showText = false
        loading = false
        brightness = false
        
        withAnimation(.easeInOut(duration: 1)) {
            showText = true
            loading = true
            brightness = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.startRotationEffect()
        }
        
        startTextCycle()
    }
    
    private func startRotationEffect() {
        guard !isRotating else { return }
        isRotating = true
        
        func rotateCycle() {
            guard self.isRotating else { return }
            
            withAnimation(.easeIn(duration: 0.6)) {
                self.rotationAngle += 260
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                guard self.isRotating else { return }
                
                withAnimation(.easeOut(duration: 1)) {
                    self.rotationAngle += 100
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    rotateCycle()
                }
            }
        }
        
        rotateCycle()
    }

    private func startTextCycle() {
        currentPhase = LoadingPhases.allCases.randomElement() ?? .ld1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 1.5)) {
                let all = LoadingPhases.allCases.filter { $0 != self.currentPhase }
                self.currentPhase = all.randomElement() ?? .ld1
            }
        }
    }
}
