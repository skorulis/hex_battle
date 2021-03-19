//
//  HexMapState.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation

/// Represents the current state of the game
struct HexMapState {
    
    var nodes:[Int: HexMapNodeState] = [:]
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
    
}

struct HexMapNodeState: Codable {
    
    let id: Int
    var type: NodeType = .empty
    var owner: Int?
    
    var inputs: [NodeType: Int] = [:]
    
}
