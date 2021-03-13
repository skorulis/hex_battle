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
    
    @Published
    var playerState: PlayerState
    
    init(stateService: GameStateService) {
        let playerId = stateService.player.id
        self.player = stateService.player
        self.stateService = stateService
        self.playerState = stateService.playerStates[playerId]!
        
        stateService.$selectedNode
            .assign(to: &$selectedNode)
        
        stateService.$playerStates
            .map({$0[playerId]!})
            .assign(to: &$playerState)
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
    
    func startConstruction(type: NodeType) -> () -> Void {
        return {
            self.stateService?.startConstruction(player: self.player.id, type: type)
        }
    }
    
}


//MARK: PServiceType

extension GameViewModel: PServiceType {
    
    static func make(_ r: Resolver) -> GameViewModel {
        return GameViewModel(stateService: r.forceResolve())
    }
}


