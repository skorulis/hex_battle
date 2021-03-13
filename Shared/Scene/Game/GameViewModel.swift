//
//  GameViewModel.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import Swinject

//MARK: - Memory footprint

final class GameViewModel: ObservableObject {
    
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
    
    public func mapViewModel() -> MapViewModel? {
        return stateService?.mapViewModel()
    }
    
    func nodeState(id: Int) -> HexMapNodeState? {
        return stateService?.state?.nodes[id]
    }
    
}

// MARK: - Behaviours

extension GameViewModel {
    
    func deselect() {
        stateService?.selectedNode = nil
    }
    
}


//MARK: PServiceType

extension GameViewModel: PServiceType {
    
    static func make(_ r: Resolver) -> GameViewModel {
        return GameViewModel(stateService: r.forceResolve())
    }
}


