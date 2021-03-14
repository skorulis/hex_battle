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
    
}

// MARK: - Data access

extension GameViewModel {
    
    public func mapViewModel() -> MapViewModel? {
        return stateService?.mapViewModel()
    }
    
    func nodeState(id: Int) -> HexMapNodeState? {
        return stateService?.state?.nodes[id]
    }
    
    func builtCount(type: NodeType) -> Int {
        return playerState.readyBuildings[type] ?? 0
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
    
    func buildNode(type: NodeType) -> () -> Void {
        return {
            guard let nodeId = self.selectedNode else { return }
            let ownerId = self.player.id
            self.stateService?.buildNode(type: type, nodeId: nodeId, owner: ownerId)
        }
    }
    
}


//MARK: PServiceType

extension GameViewModel: PServiceType {
    
    static func make(_ r: Resolver) -> GameViewModel {
        return GameViewModel(stateService: r.forceResolve())
    }
}


