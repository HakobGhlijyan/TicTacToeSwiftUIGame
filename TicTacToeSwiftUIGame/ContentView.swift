//
//  ContentView.swift
//  TicTacToeSwiftUIGame
//
//  Created by Hakob Ghlijyan on 23.05.2024.
//

import SwiftUI

struct ContentView: View {
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 3)
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(0..<9) { item in
                        ZStack {
                            Circle()
                                .foregroundStyle(.red).opacity(0.8)
                                .frame(
                                    width: (geometry.size.width/3) - 4,
                                    height: (geometry.size.width/3 - 4)
                                )
//                                .background(.black)
                            
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.white)
                        }
                    }
                }
                Spacer()
            }
//            .background(.blue)
        }
        .padding(4)
    }
}

#Preview {
    ContentView()
}
