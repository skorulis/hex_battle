//
//  MapService.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import Swinject

struct MapService {
    
    let maps: [HexMapModel]
    
    init() {
        self.maps = MapService.loadMaps()
    }
    
    
    private static func loadMaps() -> [HexMapModel] {
        guard let allURLS = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: "maps", localization: nil) else {
            return []
        }
        
        do {
            let maps = try allURLS.map { try loadMap(url: $0) }
            return maps
        } catch {
            print("Error reading maps \(error)")
            return []
        }
        
    }
    
    public func map(named: String) -> HexMapModel? {
        return maps.first(where: {$0.name == named })
    }
    
    private static func loadMap(url: URL) throws -> HexMapModel {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(HexMapModel.self, from: data)
    }
    
    
    
}

//MARK: PServiceType

extension MapService: PServiceType {
    
    static func make(_ r: Resolver) -> MapService {
        return MapService()
    }
}


