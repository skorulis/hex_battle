//
//  HexGameViewModel.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import Swinject

//MARK: - Memory footprint

final class HexGameViewModel {
    
    let currentPlayer: PlayerModel
    var currentLevel: String? //Level that has been selected
    
    init(currentPlayer: PlayerModel) {
        self.currentPlayer = currentPlayer
    }
    
}

//MARK: PServiceType

extension HexGameViewModel: PServiceType {
    
    static func make(_ r: Resolver) -> HexGameViewModel {
        return HexGameViewModel(currentPlayer: PlayerModel(id: 1))
    }
}

