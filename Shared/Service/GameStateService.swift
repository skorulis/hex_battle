//
//  GameStateService.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import Swinject

final class GameStateService: ObservableObject {
 
    public let mapService: MapService
    
    public var map: HexMapModel?
    
    @Published
    public var state: HexMapState?
    
    init(mapService: MapService) {
        self.mapService = mapService
    }
    
    public func start(map: HexMapModel) {
        self.map = GameStateService.reposition(map)
        self.state = GameStateService.buildState(self.map!)
    }

    
    public func mapViewModel() -> HexMapViewModel {
        return HexMapViewModel(map: map!, state: state!, stateService: self)
    }
    
}

// MARK: Helpers

extension GameStateService {
    
    /// Make sure no nodes are too close to the edge
    static func reposition(_ map: HexMapModel) -> HexMapModel {
        let buffer = RenderConstants.borderBuffer + RenderConstants.nodeRadius
        let minX = map.nodes.map { $0.x }.min() ?? 0
        let minY = map.nodes.map { $0.y }.min() ?? 0
        let xMovement = max(0, buffer - CGFloat(minX))
        let yMovement = max(0, buffer - CGFloat(minY))
        let mappedNodes = map.nodes.map { (node) -> HexMapNode in
            return HexMapNode(
                id: node.id,
                x: node.x + Double(xMovement),
                y: node.y + Double(yMovement),
                initialState: node.initialState
            )
        }
        return HexMapModel(name: map.name, nodes: mappedNodes, edges: map.edges)
    }
    
    static func buildState(_ map: HexMapModel) -> HexMapState {
        var mapState = HexMapState()
        for node in map.nodes {
            if let initialState = node.initialState {
                mapState.nodes[node.id] = initialState
            } else {
                mapState.nodes[node.id] = HexMapNodeState(type: .empty)
            }
            
        }
        return mapState
    }
    
}

//MARK: PServiceType

extension GameStateService: PServiceType {
    
    static func make(_ r: Resolver) -> GameStateService {
        return GameStateService(mapService: r.forceResolve())
    }
}


