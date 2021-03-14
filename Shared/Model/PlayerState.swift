
//
//  PlayerState.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 14/3/21.
//

import Foundation
import Combine

/// Represents the state for a player
struct PlayerState {
    
    public var readyBuildings: [NodeType: Int] = [:]
    public var constructionQueue: [ConstructionQueueItem] = []
    
    mutating func add(node: NodeType) {
        let count = readyBuildings[node] ?? 0
        readyBuildings[node] = count + 1
    }
    
    mutating func remove(node: NodeType) {
        let count = readyBuildings[node] ?? 0
        readyBuildings[node] = count - 1
    }
    
}

// MARK: - Inner types

extension PlayerState {
    
    struct ConstructionQueueItem: Identifiable {
        let id: UUID = UUID()
        let type: NodeType
        var time: ConstructionTimeFrame?
    }
    
    struct ConstructionTimeFrame {
        let start: TimeInterval
        let duration: TimeInterval
        var subscriber: AnyCancellable
        
        init(start: TimeInterval, duration: TimeInterval, subscriber: AnyCancellable) {
            self.start = start
            self.duration = duration
            self.subscriber = subscriber
        }
    }
    
}


