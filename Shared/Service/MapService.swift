//
//  MapService.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import Swinject

final class MapService: PServiceType {
    
    static func make(_ r: Resolver) -> MapService {
        return MapService()
    }
    
    func allMaps() -> [HexMapModel] {
        let allURLS = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: "maps", localization: nil)
        print(allURLS)
        
        return []
    }
    
}
