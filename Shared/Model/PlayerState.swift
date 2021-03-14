
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
    
    public var constructionQueue: [ConstructionQueueItem] = []
    
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


