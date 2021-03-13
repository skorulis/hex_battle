//
//  GameView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import SwiftUI

// MARK: - Memory footprint

struct GameView {
    
    init(viewModel: HexGameViewModel) {
        
    }
    
}

// MARK: - Rendering

extension GameView: View {
    
    var body: some View {
        EmptyView()
    }
}

// MARK: - Previews

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        let player = PlayerModel(id: 1)
        GameView(viewModel: HexGameViewModel(player: player))
    }
}

