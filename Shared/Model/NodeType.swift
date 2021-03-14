//
//  NodeType.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import SwiftUI

enum NodeType: String, Codable {
    
    case empty //Nothing on this node
    case command //Main player base
    case passive //Allows ownership, does nothing else
    case alpha //Alpha symbol
    case beta //Beta symbol
    case gamma // Gama symbol
    
}

extension NodeType {
    
    var symbol: String {
        switch self {
        case .empty: return ""
        case .command: return "⌘"
        case .passive: return "."
        case .alpha: return "α"
        case .beta: return "β"
        case .gamma: return "𝛾"
        }
    }
    
    var baseColor: Color {
        switch self {
        case .empty: return .concrete
        case .command: return .concrete
        case .passive: return .concrete
        case .alpha: return .alizarin
        case .beta: return .emerald
        case .gamma: return .peterRiver
        }
    }
    
}
