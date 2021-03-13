//
//  GameStateService.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import Swinject

final class GameStateService: ObservableObject {
 
    public let mapService: MapService
    
    public var map: HexMapModel?
    public var state: HexMapState?
    
    init(mapService: MapService) {
        self.mapService = mapService
    }
    
    public func start(map: HexMapModel) {
        self.map = map
    }
    
}

//MARK: PServiceType

extension GameStateService: PServiceType {
    
    static func make(_ r: Resolver) -> GameStateService {
        return GameStateService(mapService: r.forceResolve())
    }
}


