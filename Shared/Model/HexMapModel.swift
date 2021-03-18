//
//  HexMapModel.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation

public struct HexMapModel: Codable {
    
    public var name: String
    public var nodes: [HexMapNode]
    public var edges: [HexMapEdge]
    public var players: [MapPlayer]
    
}

public struct HexMapNode: Codable {
    
    public let id: Int
    public let x: CGFloat
    public let y: CGFloat
    let initialState: HexMapNodeState?
    
}

public struct HexMapEdge: Codable {
    
    public let id1: Int
    public let id2: Int
    
}

public struct MapPlayer: Codable {
    
    let id: Int
    let initialBuildings: [String: Int]?
    
    var initial: [NodeType: Int] {
        guard let initialBuildings = initialBuildings else {
            return [:]
        }
        var dict: [NodeType: Int] = [:]
        for (key, value) in initialBuildings {
            let mappedKey = NodeType(rawValue: key)!
            dict[mappedKey] = value
        }
        
        return dict
        
    }
}
