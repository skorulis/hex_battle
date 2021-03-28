//
//  Missile.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 28/3/21.
//

import Foundation

struct Missile: Identifiable {
    
    let id = UUID()
    
    let source: CGPoint
    let target: CGPoint
    
    let event: EventTimeFrame
    
}
