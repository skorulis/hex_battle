//
//  HexMapState.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation

/// Represents the current state of the game
struct HexMapState: Codable {
    
    var nodes:[Int: HexMapNodeState] = [:]
    var players: [PlayerModel] = []
    
}

struct HexMapNodeState: Codable {
    
    var type: NodeType = .empty
    var owner: Int?
    
    
}
