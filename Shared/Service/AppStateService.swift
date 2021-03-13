//
//  AppStateService.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import Swinject

/// Manages  the state  for  the entire app
final class AppStateService {
    
    private let gameState: GameStateService
    private let mapService: MapService
    private let appCoordinator: AppCoordinator
    
    init(gameState: GameStateService,
         mapService: MapService,
         appCoordinator: AppCoordinator
    ) {
        self.gameState = gameState
        self.mapService = mapService
        self.appCoordinator = appCoordinator
    }
    
    func start(level: String) {
        let map = mapService.map(named: level)
        gameState.start(map: map!)
        appCoordinator.route = .game
    }
    
}

//MARK: - PServiceType

extension AppStateService: PServiceType {
    
    static func make(_ r: Resolver) -> AppStateService {
        return AppStateService(
            gameState: r.forceResolve(),
            mapService: r.forceResolve(),
            appCoordinator: r.forceResolve()
        )
    }
}


