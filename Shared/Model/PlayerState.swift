
//
//  PlayerState.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 14/3/21.
//

import Foundation
import Combine
import SwiftUI

/// Represents the state for a player
struct PlayerState: Identifiable {
    
    public let id: Int
    public var readyBuildings: [NodeType: Int] = [:]
    public var constructionQueue: [ConstructionQueueItem] = []
    
    init(id: Int) {
        self.id = id
    }
    
    mutating func add(node: NodeType) {
        let count = readyBuildings[node] ?? 0
        readyBuildings[node] = count + 1
    }
    
    mutating func remove(node: NodeType) {
        let count = readyBuildings[node] ?? 0
        readyBuildings[node] = count - 1
    }
    
    var color: Color {
        switch id {
        case 1: return .blue
        case 2: return .red
        case 3: return .yellow
        default: return .orange
        }
    }
    
}

// MARK: - Inner types

extension PlayerState {
    
    struct ConstructionQueueItem: Identifiable {
        let id: UUID = UUID()
        let type: NodeType
        var time: EventTimeFrame?
    }
    
}


