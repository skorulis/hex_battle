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
    @State private var movement: TimeInterval = 0
    
    init(missile: Missile) {
        self.missile = missile
    }
}

// MARK: - Rendering

extension MissileView: View {
    
    var body: some View {
        Image(systemName: "arrow.right")
            .frame(width:20, height: 20)
            .missilePosition(missile: missile, position: movement)
            .onAppear(perform: animateToFinish)
    }
    
}

// MARK: - Behaviors

extension MissileView {
    
    private func animateToFinish() {
        withAnimation(.easeIn(duration: missile.event.duration)) {
            self.movement = 1
        }
    }
    
}

// MARK: - View modifies

struct MissileAnimationModifier: AnimatableModifier {
    
    let missile: Missile
    var time: TimeInterval
    
    var animatableData: TimeInterval {
        get { return time }
        set { time = newValue }
    }
    
    func body(content: Content) -> some View {
        return content
            .rotationEffect(missile.rotation(t: animatableData))
            .position(missile.fractionPosition(t: animatableData))
    }
    
}

extension View {
    
    func missilePosition(missile: Missile, position: TimeInterval) -> some View {
        self.modifier(MissileAnimationModifier(missile:missile, time: position))
    }
}

// MARK: - Previews

struct MissileView_Previews: PreviewProvider {
    
    static var previews: some View {
        let start = Date().timeIntervalSinceNow
        let dummySubscriber = Just("").sink { (text) in
            print("Text")
        }
        let event = EventTimeFrame(start: start, duration: start+5, subscriber: dummySubscriber)
        
        let missile = Missile(
            id: UUID(),
            source: CGPoint(x: 20, y: 20),
            target: CGPoint(x: 200, y: 100),
            event: event
        )
        ZStack {
            MissileView(missile: missile)
        }
        .frame(width: 240, height: 300)
        
    }
}

