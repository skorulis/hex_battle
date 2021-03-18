//
//  MapInitialisationService.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 18/3/21.
//

import Foundation
import Swinject


struct MapInitialisationService {
    
    func initialise(map: HexMapModel, grid: HexGrid) throws -> Output {
        try MapInitialisationService.validate(map)
        let repositioned = MapInitialisationService.reposition(map, grid: grid)
        let state = MapInitialisationService.buildState(repositioned)
        return Output(map: repositioned, state: state)
    }
    
    struct Output {
        let map: HexMapModel
        let state: HexMapState
    }
    
}

// MARK: Helpers

extension MapInitialisationService {
    
    /// Make sure no nodes are too close to the edge
    static func reposition(_ map: HexMapModel, grid: HexGrid) -> HexMapModel {
        
        let mappedNodes = map.nodes.map { (node) -> HexMapNode in
            let position = grid.position(x: Int(node.x), y: Int(node.y))
            return HexMapNode(
                id: node.id,
                x: position.x,
                y: position.y,
                initialState: node.initialState
            )
        }
        return HexMapModel(name: map.name, nodes: mappedNodes, edges: map.edges, players: map.players)
    }
    
    static func validate(_ map: HexMapModel) throws {
        let ids = map.nodes.map { $0.id }
        let points = map.nodes.map { "\($0.x)-\($0.y)" }
        let idSet = Set(ids)
        let pointSet = Set(points)
        if ids.count != idSet.count {
            throw MapError.duplicateIds
        }
        if pointSet.count != points.count {
            throw MapError.duplicatePositions
        }
        
        let edgeIds = map.edges.map { ["\($0.id1)", "\($0.id2)"].joined(separator: "-") }
        let edgeIdSet = Set(edgeIds)
        
        if edgeIds.count != edgeIdSet.count {
            throw MapError.duplicateEdges
        }
        
    }
    
    static func buildState(_ map: HexMapModel) -> HexMapState {
        var mapState = HexMapState()
        var players: Set<Int> = []
        for node in map.nodes {
            if let initialState = node.initialState {
                mapState.nodes[node.id] = initialState
                if let owner = initialState.owner {
                    players.insert(owner)
                }
            } else {
                mapState.nodes[node.id] = HexMapNodeState(type: .empty)
            }
            
        }
        
        mapState.allPlayers = map.players.map({ (player) -> PlayerState in
            var playerState = PlayerState(id: player.id)
            playerState.readyBuildings = player.initial
            return playerState
        })
        
        return mapState
    }
    
}

//MARK: PServiceType

extension MapInitialisationService: PServiceType {
    
    static func make(_ r: Resolver) -> MapInitialisationService {
        return MapInitialisationService()
    }
}


