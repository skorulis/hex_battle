//
//  GameViewModel.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import Swinject

//MARK: - Memory footprint

final class GameViewModel {
    
    let stateService: GameStateService?
    let player: PlayerModel
    
    @Published
    var selectedNode: Int?
    
    init(stateService: GameStateService) {
        self.player = stateService.player
        self.stateService =  stateService
        
        stateService.$selectedNode
            .assign(to: &$selectedNode)
    }
    
    public func mapViewModel() -> HexMapViewModel? {
        return stateService?.mapViewModel()
    }
    
}


//MARK: PServiceType

extension GameViewModel: PServiceType {
    
    static func make(_ r: Resolver) -> GameViewModel {
        return GameViewModel(stateService: r.forceResolve())
    }
}


