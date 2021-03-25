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
    case rangeBoost
}

struct PowerRecipeModel {
    
    let inputs: [NodeType: Int]
    let output: NodeEffect
    
}

extension NodeEffect {
    
    var iconName: String {
        switch self {
        case .none: return "circle"
        case .turret: return "bolt.fill"
        case .healing: return "cross.fill"
        case .rangeBoost: return "wifi"
        }
    }
}
