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
    
    @Published
    var playerState: PlayerState
    
    init(stateService: GameStateService?) {
        let playerId = stateService?.playerId ?? 1
        self.stateService = stateService
        self.playerState = stateService?.playerStates[playerId] ?? PlayerState(id: playerId)
        
        stateService?.$state
            .map { $0!.players[playerId]! }
            .assign(to: &$playerState)
    }
    
}

// MARK: - Sub view models

extension GameViewModel {
     
    var selectionViewModel: ControlsViewModel {
        return ControlsViewModel(stateService: stateService)
    }
    
    var playerStatusViewModel: PlayerStatusViewModel {
        return PlayerStatusViewModel(stateService: stateService)
    }
    
}

// MARK: - Data access

extension GameViewModel {
    
    public func mapViewModel() -> MapViewModel? {
        return stateService?.mapViewModel()
    }
    
    func nodeState(id: Int) -> MapNodeState? {
        return stateService?.state?.nodes[id]
    }
    
    func builtCount(type: NodeType) -> Int {
        return playerState.readyBuildings[type] ?? 0
    }
    
    var playerId: Int {
        return stateService!.playerId
    }
}

// MARK: - Behaviours

extension GameViewModel {
    
    func deselect() {
        stateService?.selectedNode = nil
    }
    
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
    
    func dumpMap() {
        guard var mapX = self.stateService?.map else { return }
        mapX.nodes = mapX.nodes.map({ (node) -> HexMapNode in
            guard let state = self.stateService?.state?.nodes[node.id] else {
                return node
            }
            var output = node
            if let owner = state.owner {
                output.initialState = HexMapNode.InitialState(type: state.type, owner: owner)
            }
            
            return output
        })
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let json = try encoder.encode(mapX)
            let text = String(data: json, encoding: .utf8)!
            print(text)
        } catch {
            print("Error encoding the map ")
        }
        
    }
    
}


//MARK: PServiceType

extension GameViewModel: PServiceType {
    
    static func make(_ r: Resolver) -> GameViewModel {
        return GameViewModel(stateService: r.forceResolve())
    }
}


