//
//  LoadingReceivePatient.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 24/11/25.
//

import SwiftUI

struct LoadingReceivePatientView: View {
    let logo: Image
    let duration: Double
    let isSyncing: Bool

    @State private var progress: CGFloat = 0
    @State private var textOpacity: Double = 1
    @State private var showSyncing: Bool = false
    @State private var rotation: Double = 0
    @State private var syncingAnimationOffset: CGFloat = -250

    var body: some View {
        ZStack {
            Color.white.opacity(0.7)
            
            VStack(spacing: 40) {
                logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(rotation))
                    .onAppear {
                        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                            rotation = 360
                        }
                    }
                
                Text(showSyncing ? "Sincronizando..." : "Carregando...")
                    .font(.custom("Comfortaa-Regular", size: 24))
                    .fontWeight(.semibold)
                    .foregroundColor(.blue30)
                    .opacity(textOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                            textOpacity = 0.3
                        }
                    }
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 20)
                        .foregroundColor(Color.blue.opacity(0.3))
                    
                    if isSyncing {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 100, height: 20)
                            .foregroundColor(.blue60)
                            .offset(x: syncingAnimationOffset)
                            .onAppear {
                                let animation = Animation.linear(duration: 1).repeatForever(autoreverses: false)
                                withAnimation(animation) {
                                    syncingAnimationOffset = 250
                                }
                            }
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: progressBarWidth, height: 20)
                            .foregroundColor(.blue30)
                            .animation(.linear(duration: duration), value: progress)
                    }
                }
                .frame(maxWidth: 250)
            }
            .onAppear {
                if !isSyncing {
                    animateProgress()
                } else {
                    showSyncing = true
                }
            }
            .padding()
        }
        .ignoresSafeArea()
    }

    private var progressBarWidth: CGFloat {
        250 * progress
    }

    private func animateProgress() {
        withAnimation(.linear(duration: duration)) {
            progress = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if isSyncing {
                showSyncing = true
            }
        }
    }
}

import SwiftUI

@main
struct LoadingTestApp: App {
    var body: some Scene {
        WindowGroup {
            LoadingReceivePatientView(
                logo: Image(systemName: "accessibility"),
                duration: 5,
                isSyncing: false
            )
        }
    }
}
