//
//  HexMapState.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation

/// Represents the current state of the game
struct HexMapState {
    
    var lastEnergyToken: String = ""
    var nodes:[Int: MapNodeState] = [:]
    var players: [Int: PlayerState] = [:]
    
    var allPlayers: [PlayerState] {
        get  {
            return Array(players.values)
        }
        set {
            for p in newValue {
                players[p.id] = p
            }
        }
    }
    
    var energyToken: String {
        let ids = nodes.map { $0.key }.sorted(by: <)
        return ids.map { nodes[$0]!.energyToken }.joined(separator: "")
    }
    
}

struct MapNodeState: Codable {
    
    let id: Int
    var type: NodeType = .empty
    var owner: Int?
    var activeEffect: NodeEffect = .none
    
    var energyInputs: [NodeType: Int] = [:]
    
    var energyOutputs: [NodeType] {
        switch type {
        case .passive, .empty: return []
        case .alpha, .beta, .gamma: return [type]
        case .command: return [.alpha, .beta, .gamma]
        }
    }
    
    var energyToken: String {
        return "\(type.rawValue)\(owner ?? 0)"
    }
    
}
