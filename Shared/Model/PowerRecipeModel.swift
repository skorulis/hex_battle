//
//  PowerRecipeModel.swift
//  HexBattleTests
//
//  Created by Alexander Skorulis on 20/3/21.
//

import Foundation

enum NodeEffect: String, Codable {
    case none
    case turret
    case healing
}

struct PowerRecipeModel {
    
    let inputs: [NodeType: Int]
    let output: NodeEffect
    
}
