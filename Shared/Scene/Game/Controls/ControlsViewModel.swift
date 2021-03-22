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
    
    init(stateService: GameStateService?) {
        self.stateService = stateService
        
        stateService?.$selectedNode
            .assign(to: &$selectedNodeId)
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
    
    func builtCount(type: NodeType) -> Int {
        return 10
        //return playerState.readyBuildings[type] ?? 0
    }
}

// MARK: - Behaviours

extension ControlsViewModel {
    
    func startConstruction(type: NodeType) -> () -> Void {
        return {
            //self.stateService?.startConstruction(player: self.playerId, type: type)
        }
    }
    
    func buildNode(type: NodeType) -> () -> Void {
        return {
            guard let nodeId = self.stateService?.selectedNode else { return }
            //let ownerId = self.playerId
            //self.stateService?.buildNode(type: type, nodeId: nodeId, owner: ownerId)
        }
    }
    
}

//MARK: PServiceType

extension ControlsViewModel: PServiceType {
    
    static func make(_ r: Resolver) -> ControlsViewModel {
        return ControlsViewModel(stateService: r.resolve())
    }
}


