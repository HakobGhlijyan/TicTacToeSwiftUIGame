//
//  ContentView.swift
//  TicTacToeSwiftUIGame
//
//  Created by Hakob Ghlijyan on 23.05.2024.
//

import SwiftUI

struct ContentView: View {
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 3)
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameboardDisable: Bool = false
    
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
                            if isSquareOccupied(in: moves, forIndex: i) { return }
                            moves[i] = Move(player: .human, boardIndex: i)
                            isGameboardDisable = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determineComputerMovePosition(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameboardDisable = false
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .disabled(isGameboardDisable)
        .padding(8)
    }
    
    //MARK: - CHECK SQUARE IS EMPTY?
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    //MARK: - COMP GO -> POSITION
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
 
    //MARK: - CHECK FOR WIN -> PLAYER OR COMP
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        //Pattern position
        let winPatterns: Set<Set<Int>> = [
            [0,1,2],[3,4,5],[6,7,8],
            [0,3,6],[1,4,7],[2,5,8],
            [0,4,8],[2,4,6],
        ]
        
        //1 compact map -> delete for all nil position
        // and filter , see all plyaer go
        let playerMoves = moves.compactMap({ $0 }).filter({ $0.player == player })
        // make player go position
        // teper bi poluchim vse xodi player -> ego index i , dlya proverki
        //2 i budem proveryat vse set win position s set plaler
        let playerPosition = Set(playerMoves.map({ $0.boardIndex }))

        //3 proxodim po set array win posiciy , pri uslovii vnutrennego set kotoraya playerPosition, proveiv ix vernem true , to player win... uslovie budet true esli on budet raven odmomu iz set po moemu chablonu... sravnivaem ix , i naxodim takoy je set chto i v win set ax
        for pattern in winPatterns where pattern.isSubset(of: playerPosition) {
            return true
        }
        
        // esli nichego iz egogo net to false vernem
        return false
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
