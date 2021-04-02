//
//  ProjectilesViewModel.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 28/3/21.
//

import Foundation
import Swinject
import Combine

final class ProjectilesViewModel: ObservableObject {
    
    @Published var missiles: [Missile] = [
        ProjectilesViewModel.makeMissile()
    ]
    
    init(stateService: GameStateService?) {
        stateService?.$missiles
            .assign(to: &$missiles)
    }
    
}

// MARK: - Inner logic

extension ProjectilesViewModel {
    
    static func makeMissile() -> Missile {
        let start = Date().timeIntervalSinceNow
        let dummySubscriber = Just("").sink { (text) in
            print("Text")
        }
        let event = EventTimeFrame(start: start, duration: 20, subscriber: dummySubscriber)
        
        let startPos = CGPoint(x: 50, y: 50)
        let missile = Missile(id: UUID(), source: startPos, target: CGPoint(x: 200, y: 100), event: event)
        return missile
    }
    
}

//MARK: PServiceType

extension ProjectilesViewModel: PServiceType {
    
    static func make(_ r: Resolver) -> ProjectilesViewModel {
        return ProjectilesViewModel(stateService: r.resolve())
    }
}


