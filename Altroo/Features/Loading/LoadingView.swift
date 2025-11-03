//
//  LoadingView.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 02/11/25.
//

import SwiftUI

enum LoadingPhases: CaseIterable {
    case ld1, ld2, ld3, ld4, ld5, ld6 ,ld7, ld8, ld9, ld10
    
    var text: String {
        switch self {
        case .ld1: return "Separando os medicamentos com carinho..."
        case .ld2: return "Organizando a rotina de cuidados..."
        case .ld3: return "Anotando os sinais importantes..."
        case .ld4: return "Verificando se está tudo bem por aí..."
        case .ld5: return "Preparando o melhor cuidado possível..."
        case .ld6: return "Checando lembretes e tarefas do dia..."
        case .ld7: return "Reunindo informações para facilitar seu dia..."
        case .ld8: return "Configurando lembrete para o remédio de hoje..."
        case .ld9: return "Verificando os detalhes para você cuidar de quem ama..."
        case .ld10: return "Deixando tudo pronto para a próxima atividade..."
        }
    }
}

struct LoadingView: View {
    
    @State private var showText = false
    @State private var loading = false
    @State private var brightness = false
    @State private var currentPhase: LoadingPhases = .ld1
    @State private var nextPhase: LoadingPhases = .ld2
    @State private var rotationAngle: Double = 0
    @State private var isAnimatingRotation = false
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Gerando tela personalizada")
                .foregroundStyle(.pureWhite)
                .font(Font.custom("Comfortaa", size: 36))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .opacity(showText ? 1 : 0)
                .offset(y: showText ? 0 : 10)
                .animation(.easeOut(duration: 1.5), value: showText)
            
            ZStack {
                Image("loading1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .offset(x: loading ? 0 : -UIScreen.main.bounds.width)
                    .animation(.smooth(duration: 2), value: loading)
                
                Image("loading2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .offset(x: loading ? 0 : UIScreen.main.bounds.width)
                    .animation(.smooth(duration: 2), value: loading)
            }
            .rotationEffect(.degrees(rotationAngle))
            
            Text(currentPhase.text)
                .foregroundStyle(.pureWhite)
                .font(Font.custom("Comfortaa", size: 24))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .transition(.opacity)
                .id(currentPhase.text)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.blue50)
                .blur(radius: brightness ? 70 : 100)
                .frame(width: UIScreen.main.bounds.width, height: brightness ? 130 : 90)
                .animation(.easeInOut(duration: 1), value: brightness)
        }
        .background {
            Color.blue20
                .ignoresSafeArea()
        }
        .onAppear {
            currentPhase = LoadingPhases.allCases.randomElement() ?? .ld1
            nextPhase = getNextRandom(excluding: currentPhase)
            
            showText = false
            loading = false
            brightness = false
            rotationAngle = 0
            
            withAnimation {
                showText = true
                loading = true
                brightness = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                startLoadingCycle()
            }
        }
    }
    
    private func startLoadingCycle() {
        guard !isAnimatingRotation else { return }
        isAnimatingRotation = true
        
        func rotateCycle() {
            withAnimation(.easeIn(duration: 0.4)) {
                rotationAngle += 270
                brightness.toggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeOut(duration: 1.0)) {
                    rotationAngle += 90
                    brightness.toggle()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    rotateCycle()
                }
            }
        }
        
        rotateCycle()
    }
    
    private func getNextRandom(excluding current: LoadingPhases) -> LoadingPhases {
        let all = LoadingPhases.allCases.filter { $0 != current }
        return all.randomElement() ?? .ld1
    }
}

#Preview {
    LoadingView()
}
