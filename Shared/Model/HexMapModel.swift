//
//  HexMapModel.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation

struct HexMapModel: Codable {
    
    var name: String
    var nodes: [HexMapNode]
    var edges: [HexMapEdge]
    
}

struct HexMapNode: Codable {
    
    let id: Int
    let x: Double
    let y: Double
    
}

struct HexMapEdge: Codable {
    
    let id1: Int
    let id2: Int
    
}
