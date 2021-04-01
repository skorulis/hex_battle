//
//  Missile.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 28/3/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct Missile: Identifiable {
    
    let id = UUID()
    
    let source: CGPoint
    let target: CGPoint
    
    let event: EventTimeFrame
    
    let curve: Bezier3
    
    init(source: CGPoint, target: CGPoint, event: EventTimeFrame) {
        self.source = source
        self.target = target
        self.event = event
        
        let c1 = CGPoint.zero
        
        self.curve = Bezier3(from: source, to: target, control1: c1, control2: c1)
    }
    
}

// MARK: - Inner logic

extension Missile {
    
    func timePosition(at: TimeInterval) -> CGPoint {
        let t = event.fraction(at: at)
        return fractionPosition(t: t)
    }
    
    func fractionPosition(t: TimeInterval) -> CGPoint {
        let t = CGFloat(t)
        return curve.point(t: t)
    }
    
    func rotation(t: TimeInterval) -> Angle {
        let dp = curve.derivate(t: CGFloat(t))
        return Angle(radians: atan2(Double(dp.dy), Double(dp.dx)))
    }
    
}
