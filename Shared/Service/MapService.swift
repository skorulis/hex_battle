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
    
    private func loadMap(url: URL) throws -> HexMapModel {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(HexMapModel.self, from: data)
    }
    
}
