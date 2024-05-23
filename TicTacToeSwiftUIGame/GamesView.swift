//
//  ContentView.swift
//  TicTacToeSwiftUIGame
//
//  Created by Hakob Ghlijyan on 23.05.2024.
//

import SwiftUI

struct GamesView: View {
    @StateObject private var viewModel = GamesViewModel()
        
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 4) {
                    ForEach(0..<9) { i in
                        ZStack {
                            GameSquareView(proxy: geometry)
                            PlayerIndicator(systemImageName: viewModel.moves[i]?.indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                Spacer()
            }
        }
        .disabled(viewModel.isGameboardDisable)
        .padding(8)
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: .default(alertItem.buttonTitle, action: {
                    viewModel.restartGame()
                })
            )
        }
    }
}

#Preview {
    GamesView()
}

