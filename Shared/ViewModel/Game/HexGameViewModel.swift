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
    
    let player: PlayerModel
    
    init(player: PlayerModel) {
        self.player = player
    }
    
}

//MARK: PServiceType

extension HexGameViewModel: PServiceType {
    
    static func make(_ r: Resolver) -> HexGameViewModel {
        return HexGameViewModel(player: PlayerModel(id: 1))
    }
}

