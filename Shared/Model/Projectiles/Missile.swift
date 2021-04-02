//
//  Missile.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 28/3/21.
//

import CGPointVector
import Foundation
import SwiftUI


// MARK: - Memory footprint

struct Missile: Identifiable {
    
    let id: UUID
    
    let source: CGPoint
    let target: CGPoint
    
    let event: EventTimeFrame
    
    let curve: Bezier3
    
    init(id: UUID, source: CGPoint, target: CGPoint, event: EventTimeFrame) {
        
        let xOffset = CGFloat.random(in: -10...10)
        let yOffset = CGFloat.random(in: -10...10)
        
        self.source = source
        self.target = target + CGPoint(x: xOffset, y: yOffset)
        self.event = event
        self.id = id
        
        let dir = self.target - source
        let mid = (self.target + source) / 2
        let mov = dir * CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        let arcHeight = CGFloat.random(in: 0.1...0.4)
        let c1 = mid - (mov * arcHeight)
        
        self.curve = Bezier3(from: source, to: self.target, control1: c1, control2: c1)
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
