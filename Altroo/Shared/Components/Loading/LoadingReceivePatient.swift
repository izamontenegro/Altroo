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
    @State private var syncingAnimationOffset: CGFloat = -250
    @State private var brightness = false

    var body: some View {
        ZStack {
            Color.white.opacity(0.7)
            
            VStack(spacing: 14) {
                Spacer()
                
                logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 165, height: 165)
                    .rotationEffect(.degrees(rotation))
                    .onAppear {
                        startRotationStep()
                    }
                
                Text(showSyncing ? "Sincronizando..." : "Carregando...")
                    .font(.custom("Comfortaa-Regular", size: 24))
                    .fontWeight(.semibold)
                    .foregroundColor(.blue30)
                    .opacity(textOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            textOpacity = 0.3
                        }
                    }
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 20)
                        .foregroundColor(.blue60)
                    
                    if isSyncing {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 100, height: 20)
                            .foregroundColor(.blue30)
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
                
                Spacer()
            }
            .onAppear {
                if !isSyncing {
                    animateProgress()
                } else {
                    showSyncing = true
                }
            }
            .padding(.bottom, 100)

            VStack {
                Spacer()
                Ellipse()
                    .fill(.blue60)
                    .blur(radius: brightness ? 70 : 100)
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: brightness ? 130 : 90)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            brightness.toggle()
                        }
                    }
            }
        }
        .ignoresSafeArea()
    }

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

    private func animateProgress() {
        withAnimation(.linear(duration: duration * 5)) {
            progress = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 5) {
            if isSyncing {
                showSyncing = true
            }
        }
    }
}
