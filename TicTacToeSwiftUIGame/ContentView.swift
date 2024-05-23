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
    @State private var alertItem: AlertItem?
    
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
                            isGameboardDisable = true // proverka , a posle tolko otkluvhenie
                            
                            // Comp Go
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
                    }
                }
                Spacer()
            }
        }
        .disabled(isGameboardDisable)
        .padding(8)
        .alert(item: $alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: .default(alertItem.buttonTitle, action: {
                    // restart game
                    restartGame()
                })
            )
        }
    }
    
    //MARK: - CHECK SQUARE IS EMPTY?
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    //MARK: - COMP GO -> POSITION
    /*
     IF AI CAN WIN, THEN WIN
     IF AI CAN'T WIN . THEN BLOCK
     IF SI CAN'T BLOCK , THEN TAKE MIDDLE SQUARE
     IF AI CAN'T TAKE MIDDLE SQUARE , TAKE RANDOM AVAILABLE SQUARE
     */
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        // 1 - IF AI CAN WIN, THEN WIN
        //Pattern position
        let winPatterns: Set<Set<Int>> = [
            [0,1,2],[3,4,5],[6,7,8],
            [0,3,6],[1,4,7],[2,5,8],
            [0,4,8],[2,4,6],
        ]
        // compact map -> delete for all nil position
        // and filter , see all computer go
        let computerMoves = moves.compactMap({ $0 }).filter({ $0.player == .computer })
        // make player go position
        // teper bi poluchim vse xodi computer -> ego index i , dlya proverki
        //2 i budem proveryat vse set win position s set computer
        let computerPosition = Set(computerMoves.map({ $0.boardIndex }))
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPosition)
            // v win posiciyex proxodim po vsem pattent , i vichitaem vse posicii iz posiciy comp, [0,1,2] mi imeem 0 , 1,2  ostayutsya .. esli 0,1 to ostayotsya 2 i on win positon
            if winPatterns.count == 1 {
                // teper proverka ma to on svobodet li..
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                //esli krug ne zanyat to ... vernet true
                if isAvaiable { return winPositions.first! }
                // vozrochaem sluchaynuyu posiciyu kotoraya 1 na i ona dast viigrat
            }
        }
        
        // 2 - IF AI CAN'T WIN . THEN BLOCK
        // compact map -> delete for all nil position
        // and filter , see all computer go
        let humanMoves = moves.compactMap({ $0 }).filter({ $0.player == .human })
        // make player go position
        // teper bi poluchim vse xodi computer -> ego index i , dlya proverki
        //2 i budem proveryat vse set win position s set computer
        let humanPosition = Set(humanMoves.map({ $0.boardIndex }))
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPosition)
            // v win posiciyex proxodim po vsem pattent , i vichitaem vse posicii iz posiciy comp, [0,1,2] mi imeem 0 , 1,2  ostayutsya .. esli 0,1 to ostayotsya 2 i on win positon
            if winPatterns.count == 1 {
                // teper proverka ma to on svobodet li..
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                //esli krug ne zanyat to ... vernet true
                if isAvaiable { return winPositions.first! }
                // vozrochaem sluchaynuyu posiciyu kotoraya 1 na i ona dast viigrat
            }
        }
        
        // 3 - IF SI CAN'T BLOCK , THEN TAKE MIDDLE SQUARE
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare) {
            return centerSquare
        }
        //esli comp ne mojet 1 ostavit win posiciyu,  2 ne mojet block my position, to .. on proverit i postavit svoy xod v 4 kub v seredinu
        
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
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        // budem cherez compact map sobitat vse xodi, i esli ett xodi budut ravni 9 , vse sdelani , to draw nichya, to vernet true
        return moves.compactMap({ $0 }).count == 9
    }
 
    func restartGame() {
        moves = Array(repeating: nil, count: 9)
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
