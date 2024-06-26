//
//  GamesViewModel.swift
//  TicTacToeSwiftUIGame
//
//  Created by Hakob Ghlijyan on 23.05.2024.
//

import SwiftUI

final class GamesViewModel: ObservableObject {
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 3)
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisable: Bool = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for i: Int) {
        // Player Go
        if isSquareOccupied(in: moves, forIndex: i) { return }
        moves[i] = Move(player: .human, boardIndex: i)
        
        //check for win condition or draw
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContent.humanWin
            return
        }
        
        if checkForDraw(in: moves) {
            alertItem = AlertContent.draw
            return
        }
        
        isGameboardDisable = true
        
        // Comp Go
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameboardDisable = false
            
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContent.computerWin
                return
            }
            
            if checkForDraw(in: moves) {
                alertItem = AlertContent.draw
                return
            }
        }
    }

    //MARK: - CHECK SQUARE IS EMPTY?
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    //MARK: - COMP GO -> POSITION
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        // 1 - IF AI CAN WIN, THEN WIN
        let winPatterns: Set<Set<Int>> = [
            [0,1,2],[3,4,5],[6,7,8],
            [0,3,6],[1,4,7],[2,5,8],
            [0,4,8],[2,4,6],
        ]
        let computerMoves = moves.compactMap({ $0 }).filter({ $0.player == .computer })
        let computerPosition = Set(computerMoves.map({ $0.boardIndex }))
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPosition)
            if winPatterns.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaiable { return winPositions.first! }
            }
        }
        
        // 2 - IF AI CAN'T WIN . THEN BLOCK
        let humanMoves = moves.compactMap({ $0 }).filter({ $0.player == .human })
        let humanPosition = Set(humanMoves.map({ $0.boardIndex }))
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPosition)
            if winPatterns.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaiable { return winPositions.first! }
            }
        }
        
        // 3 - IF SI CAN'T BLOCK , THEN TAKE MIDDLE SQUARE
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare) {
            return centerSquare
        }

        // 4 - IF AI CAN'T TAKE MIDDLE SQUARE , TAKE RANDOM AVAILABLE SQUARE
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
        
        let playerMoves = moves.compactMap({ $0 }).filter({ $0.player == player })
        let playerPosition = Set(playerMoves.map({ $0.boardIndex }))

        for pattern in winPatterns where pattern.isSubset(of: playerPosition) {
            return true
        }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap({ $0 }).count == 9
    }
 
    func restartGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
