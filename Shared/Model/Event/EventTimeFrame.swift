//
//  EventTimeFrame.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 28/3/21.
//

import Combine
import Foundation

struct EventTimeFrame {
    let start: TimeInterval
    let duration: TimeInterval
    var subscriber: AnyCancellable
    
    init(start: TimeInterval, duration: TimeInterval, subscriber: AnyCancellable) {
        self.start = start
        self.duration = duration
        self.subscriber = subscriber
    }
    
    func fraction(at: TimeInterval) -> TimeInterval {
        let t = (at - start) / duration
        return max(min(t,0),1)
    }
}
