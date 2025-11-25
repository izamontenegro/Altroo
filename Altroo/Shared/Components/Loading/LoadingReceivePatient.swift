//
//  LoadingReceivePatient.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/11/25.
//

import SwiftUI

struct LoadingReceivePatientView: View {
    let logo: Image
    let duration: Double = 1.5
    let pause: Double = 0.5
    let isSyncing: Bool
    
    @State private var rotation: Double = 0
    @State private var textOpacity: Double = 1
    @State private var progress: CGFloat = 0
    @State private var showSyncing: Bool = false
    @State private var brightness = false
    
    @State private var minDuration: Double = 4
    @State private var loadingStartedAt = Date()
    @State private var didReachEndOnce = false
    @State private var isInitialLoading: Bool = true
    
    var body: some View {
        ZStack {
            Color.blue80.ignoresSafeArea()
            
            VStack(spacing: 14) {
                Spacer()
                
                logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 165, height: 165)
                    .rotationEffect(.degrees(rotation))
                    .onAppear { startRotationStep() }
                
                Text(showSyncing ? "Sincronizando..." : "Carregando...")
                    .font(.custom("Comfortaa-Regular", size: 24))
                    .fontWeight(.semibold)
                    .foregroundColor(.blue30)
                    .opacity(textOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            textOpacity = 0.3
                        }
                    }
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 20)
                        .foregroundColor(.blue60)
                    
                    if isInitialLoading {
                        // Initial loading screen is always animated
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: progressBarWidth, height: 20)
                            .foregroundColor(.blue30)
                    }
                    else if isSyncing {
                        // After 4 seconds, if still synchronizing → full bar
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 250, height: 20)
                            .foregroundColor(.blue30)
                    } else {
                        // If finish early → use accelerated end progress
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: progressBarWidth, height: 20)
                            .foregroundColor(.blue30)
                    }
                }
                .frame(maxWidth: 250)
                
                Spacer()
            }
            .onAppear { animateProgress() }
            .onChange(of: isSyncing) { _, newValue in
                if newValue == false && !didReachEndOnce {
                    accelerateProgressToEnd()
                }
            }
            .padding(.bottom, 100)
            
            VStack {
                Spacer()
                Ellipse()
                    .fill(.blue60)
                    .blur(radius: brightness ? 70 : 100)
                    .frame(width: UIScreen.main.bounds.width * 0.8,
                           height: brightness ? 130 : 90)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            brightness.toggle()
                        }
                    }
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Progress Animations
    
    private func animateProgress() {
        loadingStartedAt = Date()
        isInitialLoading = true
        progress = 0
        
        withAnimation(.linear(duration: minDuration)) {
            progress = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + minDuration) {
            didReachEndOnce = true
            isInitialLoading = false
            
            if isSyncing {
                showSyncing = true
            }
        }
    }
    
    private func accelerateProgressToEnd() {
        let remaining = max(0, 1 - progress)
        
        let fastDuration = max(0.15, min(0.8, remaining * 0.5))
        
        withAnimation(.linear(duration: fastDuration)) {
            progress = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + fastDuration) {
            didReachEndOnce = true
            isInitialLoading = false
        }
    }
    
    // MARK: - Rotation Animation
    
    private func startRotationStep() {
        func rotateOnce() {
            withAnimation(.linear(duration: duration)) {
                rotation += 360
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration + pause) {
                rotateOnce()
            }
        }
        rotateOnce()
    }
    
    private var progressBarWidth: CGFloat {
        250 * progress
    }
}
