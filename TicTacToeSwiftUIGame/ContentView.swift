//
//  ContentView.swift
//  TicTacToeSwiftUIGame
//
//  Created by Hakob Ghlijyan on 23.05.2024.
//

import SwiftUI

struct ContentView: View {
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 3)
    // This My empty 9 places, start game
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isHumanTurn = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                LazyVGrid(columns: columns, spacing: 4) {
                    
                    ForEach(0..<9) { i in
                        
                        ZStack {
                            Circle()
                                .foregroundStyle(.red).opacity(0.8)
                                .frame(
                                    width: (geometry.size.width/3) - 4,
                                    height: (geometry.size.width/3 - 4)
                                )
                            
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.white)
                        }
                        .onTapGesture {
                            moves[i] = Move(player: isHumanTurn ? .human : .computer, boardIndex: i)
                            isHumanTurn.toggle()
                        }
                        
                    }
                }
                Spacer()
            }
        }
        .padding(8)
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

#Preview {
    ContentView()
}
