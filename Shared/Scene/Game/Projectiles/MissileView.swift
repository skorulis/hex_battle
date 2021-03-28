//
//  MissileView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 28/3/21.
//

import Combine
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct MissileView {
    
    private let missile: Missile
    
    init(missile: Missile) {
        self.missile = missile
    }
}

// MARK: - Rendering

extension MissileView: View {
    
    var body: some View {
        Image(systemName: "paperplane")
            .position(x: missile.source.x, y: missile.source.y)
    }
}

// MARK: - Previews

struct MissileView_Previews: PreviewProvider {
    
    static var previews: some View {
        let start = Date().timeIntervalSinceNow
        let dummySubscriber = Just("").sink { (text) in
            print("Text")
        }
        let event = EventTimeFrame(start: start, duration: start+1, subscriber: dummySubscriber)
        
        let missile = Missile(
            source: CGPoint(x: 20, y: 20),
            target: CGPoint(x: 200, y: 100),
            event: event
        )
        ZStack {
            MissileView(missile: missile)
        }
        .frame(width: 200, height: 300)
        
    }
}

