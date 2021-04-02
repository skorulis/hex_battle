//
//  NodeEventService.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 2/4/21.
//

import Combine
import Foundation
import Swinject


final class NodeEventService {
    
    init() {}
    
    func event(for node: MapNodeState, stateService: GameStateService) -> EventTimeFrame? {
        switch node.activeEffect {
        case .turret:
            let missileTime: TimeInterval = 0.5
            let event = Timer.publish(every: missileTime, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                self.fireMissile(node: node, stateService: stateService )
            }
            
            return EventTimeFrame(start: .unix, duration: missileTime, subscriber: event)
        default:
            return nil
        }
    }
    
    private func fireMissile(node: MapNodeState, stateService: GameStateService) {
        guard let target = findTarget(from: node, stateService: stateService) else { return }
        guard let mapNode = stateService.map?.node(id: node.id) else { return }
        guard let mapTarget = stateService.map?.node(id: target.id) else  { return }
        
        let missileId = UUID()
        
        let dummySubscriber = Just(Void())
            .delay(for: 3, scheduler: DispatchQueue.main)
            .sink { _ in
            stateService.missiles.removeAll(where: {$0.id == missileId})
        }
        let event = EventTimeFrame(start: .unix, duration: 3, subscriber: dummySubscriber)
        
        let missile = Missile(id: missileId, source: mapNode.point, target: mapTarget.point, event: event)
        stateService.missiles.append(missile)
        
    }
    
    private func findTarget(from node: MapNodeState, stateService: GameStateService) -> MapNodeState? {
        return stateService.state?.nodes.values.first(where: { $0.owner != nil && $0.owner != node.owner })
    }
    
}


//MARK: PServiceType

extension NodeEventService: PServiceType {
    
    static func make(_ r: Resolver) -> NodeEventService {
        return NodeEventService()
    }
}


