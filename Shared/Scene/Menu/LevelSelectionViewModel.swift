//
//  LevelSelectionViewModel.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import Swinject

final class LevelSelectionViewModel {
    
    private let mapService: MapService?
    private let appState: AppStateService?
    
    init(mapService: MapService?,
         appStateService: AppStateService?
         
    ) {
        self.mapService = mapService
        self.appState = appStateService
    }
    
    var nameList: [String] {
        return self.mapService?.maps.map { $0.name } ?? []
    }
    
}

// MARK: - Behaviours

extension LevelSelectionViewModel {
    
    func select(level: String) -> () -> Void {
        return {
            self.appState?.start(level: level)
        }
    }
    
}

//MARK: - PServiceType

extension LevelSelectionViewModel: PServiceType {
    
    static func make(_ r: Resolver) -> LevelSelectionViewModel {
        return LevelSelectionViewModel(
            mapService: r.resolve(),
            appStateService: r.resolve()
        )
    }
}


