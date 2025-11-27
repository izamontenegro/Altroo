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
        case .ld1: return "Separando os medicamentos com carinho...".localized
        case .ld2: return "Organizando a rotina de cuidados...".localized
        case .ld3: return "Anotando os sinais importantes...".localized
        case .ld4: return "Verificando se está tudo bem por aí...".localized
        case .ld5: return "Preparando o melhor cuidado possível...".localized
        case .ld6: return "Checando lembretes e tarefas do dia...".localized
        case .ld7: return "Reunindo informações para facilitar seu dia...".localized
        case .ld8: return "Configurando lembrete para o remédio de hoje...".localized
        case .ld9: return "Verificando os detalhes para você cuidar de quem ama...".localized
        case .ld10: return "Deixando tudo pronto para a próxima atividade...".localized
        }
    }
}

struct LoadingView: View {
    @ObservedObject var viewModel: LoadingViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Gerando tela personalizada")
                .foregroundStyle(.pureWhite)
                .font(Font.custom("Comfortaa", size: 36))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .opacity(viewModel.showText ? 1 : 0)
                .offset(y: viewModel.showText ? 0 : 10)
                .animation(.easeOut(duration: 1.5), value: viewModel.showText)
            
            ZStack {
                Image("loading1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .offset(x: viewModel.loading ? 0 : -UIScreen.main.bounds.width)
                    .animation(.smooth(duration: 2), value: viewModel.loading)
                
                Image("loading2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .offset(x: viewModel.loading ? 0 : UIScreen.main.bounds.width)
                    .animation(.smooth(duration: 2), value: viewModel.loading)
            }
            .rotationEffect(.degrees(viewModel.rotationAngle))
            
            Text(viewModel.currentPhase.text)
                .foregroundStyle(.pureWhite)
                .font(Font.custom("Comfortaa", size: 24))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .transition(.opacity)
                .id(viewModel.currentPhase.text)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.blue50)
                .blur(radius: viewModel.brightness ? 70 : 100)
                .frame(width: UIScreen.main.bounds.width, height: viewModel.brightness ? 130 : 90)
                .animation(.easeInOut(duration: 1), value: viewModel.brightness)
        }
        .background {
            Color.blue20.ignoresSafeArea()
        }
        .onAppear {
            viewModel.startLoading()
        }
    }
}

//#Preview {
//    LoadingView(viewModel: LoadingViewModel())
//}
