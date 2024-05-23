//
//  Alert.swift
//  TicTacToeSwiftUIGame
//
//  Created by Hakob Ghlijyan on 23.05.2024.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContent {
    static let humanWin = AlertItem(
        title: Text("You Win!!"),
        message: Text("You are so smart. You best your own AI"),
        buttonTitle: Text("Hell yaeh")
    )
    static let computerWin = AlertItem(
        title: Text("You Lost!!"),
        message: Text("You programed a super AI"),
        buttonTitle: Text("Rematch???")
    )
    static let draw = AlertItem(
        title: Text("Draw!!"),
        message: Text("What a battle of wits we have here..."),
        buttonTitle: Text("Try Again!!!")
    )
}
