//
//  ControlsViewModel.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 22/3/21.
//

import Foundation
import Swinject

final class ControlsViewModel: ObservableObject {
    
    private var stateService: GameStateService?
    
    @Published
    var selectedNodeId: Int?
    
    @Published
    var playerState: PlayerState
    
    init(stateService: GameStateService?) {
        self.stateService = stateService
        
        let playerId = stateService?.playerId ?? 1
        
        self.playerState = stateService?.playerStates[playerId] ?? PlayerState(id: playerId)
        
        setupObservers()
    }
    
    private func setupObservers() {
        stateService?.$selectedNode
            .assign(to: &$selectedNodeId)
        
        stateService?.$state
            .map { [unowned self] in $0!.players[self.playerId]! }
            .assign(to: &$playerState)
    }
    
    var selectedNode: MapNodeState? {
        guard let selectedNodeId = selectedNodeId else {
            return nil
        }
        return stateService?.state?.nodes[selectedNodeId]
    }
    
    func nodeIfSelected(_ nodeId: Int) -> MapNodeState? {
        if nodeId == selectedNodeId {
            return stateService?.state?.nodes[nodeId]
        } else {
            return nil
        }
    }
}

// MARK: - Computed

extension ControlsViewModel {
    
    var playerId: Int {
        return playerState.id
    }
    
    func builtCount(type: NodeType) -> Int {
        return playerState.readyBuildings[type] ?? 0
    }
}

// MARK: - Behaviours

extension ControlsViewModel {
    
    func startConstruction(type: NodeType) -> () -> Void {
        return {
            self.stateService?.startConstruction(player: self.playerId, type: type)
        }
    }
    
    func buildNode(type: NodeType) -> () -> Void {
        return {
            guard let nodeId = self.stateService?.selectedNode else { return }
            let ownerId = self.playerId
            self.stateService?.buildNode(type: type, nodeId: nodeId, owner: ownerId)
        }
    }
    
    func clearNode() {
        guard let nodeId = self.stateService?.selectedNode else { return }
        self.stateService?.clearNode(playerId: playerId, nodeId: nodeId)
    }
    
}

//MARK: PServiceType

extension ControlsViewModel: PServiceType {
    
    static func make(_ r: Resolver) -> ControlsViewModel {
        return ControlsViewModel(stateService: r.resolve())
    }
}


