//
//  GameUIView.swift
//  TicTacToeSwiftUIGame
//
//  Created by Hakob Ghlijyan on 23.05.2024.
//

import SwiftUI

struct GameSquareView: View {
    var proxy: GeometryProxy
    
    var body: some View {
        Circle()
            .foregroundStyle(.red).opacity(0.8)
            .frame(
                width: (proxy.size.width/3) - 4,
                height: (proxy.size.width/3 - 4)
            )
    }
}

struct PlayerIndicator: View {
    var systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundStyle(.white)
    }
}
