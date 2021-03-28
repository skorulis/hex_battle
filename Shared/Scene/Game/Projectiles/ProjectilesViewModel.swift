//
//  ProjectilesViewModel.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 28/3/21.
//

import Foundation
import Swinject

final class ProjectilesViewModel: ObservableObject {
    
    @Published var missiles: [Missile] = []
    
}

//MARK: PServiceType

extension ProjectilesViewModel: PServiceType {
    
    static func make(_ r: Resolver) -> ProjectilesViewModel {
        return ProjectilesViewModel()
    }
}


