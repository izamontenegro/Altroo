//
//  HealthDataAlert.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 30/10/25.
//

import SwiftUI

struct HealthDataAlertView: View {
    
    let cardGradient = LinearGradient(colors: [.blue30, .blue70],
                                      startPoint: .bottom,
                                      endPoint: .top)
    let lockGradient = LinearGradient(colors: [.blue70, .pureWhite],
                                      startPoint: .bottom,
                                      endPoint: .top)
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.blue20)
                    .frame(width: 338, height: 102)
                
                Text("Sua privacidade\né nossa prioridade")
                    .foregroundStyle(.pureWhite)
                    .font(Font.custom("Comfortaa", size: 22))
                    .bold()
                    .multilineTextAlignment(.center)
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    //TODO: COLOCAR AÇÃO DO BOTÃO
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.pureWhite)
                }
                .padding(.vertical, 15)
                .padding(.trailing, 10)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(cardGradient)
                    .frame(width: 300, height: 160)
                Image(systemName: "lock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(lockGradient)
            }
            
            Text("As informações de saúde do assistido são armazenadas em nuvem pessoal vinculada à conta privada do seu dispositivo, garantindo privacidade e proteção.")
                .foregroundStyle(.black10)
                .font(Font.custom("Comfortaa", size: 16))
                .multilineTextAlignment(.center)
                .padding()
            
            Button {
                //TODO: ADICIONAR NAVEGAÇÃO
            } label: {
                HStack(spacing: 8) {
                    Text("Política de Privacidade e Proteção")
                        .font(Font.custom("Comfortaa", size: 16))
                        .multilineTextAlignment(.center)
                    Image(systemName: "arrow.forward")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 14)
                        .rotationEffect(Angle(degrees: -40), anchor: .center)
                }
                .foregroundStyle(.blue30)
                .bold()
            }
            
            Button {
                //TODO: ADICIONAR NAVEGAÇÃO
            } label: {
                HStack(spacing: 8) {
                    Text("Aviso Legal")
                        .font(Font.custom("Comfortaa", size: 16))
                        .multilineTextAlignment(.center)
                    Image(systemName: "arrow.forward")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 14)
                        .rotationEffect(Angle(degrees: -40), anchor: .center)
                }
                .foregroundStyle(.blue30)
                .bold()
            }
        }
        .frame(width: 338, height: 506, alignment: .top)
        .background {
            Color.pureWhite
        }
        .mask {
            RoundedRectangle(cornerRadius: 15)
        }
    }
}
 
#Preview {
    HealthDataAlertView()
}
