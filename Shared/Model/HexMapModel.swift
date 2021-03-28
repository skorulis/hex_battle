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
    var initialState: InitialState?
    
    struct InitialState: Codable {
        var type: NodeType = .empty
        var owner: Int?
    }
    
}


public struct HexMapEdge: Codable {
    
    public let id1: Int
    public let id2: Int
    
    func touches(_ id: Int) -> Bool {
        return id1 == id || id2 == id
    }
    
    func connected(_ id: Int) -> Int? {
        switch true {
        case id == id1: return id2
        case id == id2: return id1
        default: return nil
        }
    }
    
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
