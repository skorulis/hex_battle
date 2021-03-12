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
    
}

public struct HexMapNode: Codable {
    
    public let id: Int
    public let x: Double
    public let y: Double
    
}

public struct HexMapEdge: Codable {
    
    public let id1: Int
    public let id2: Int
    
}
