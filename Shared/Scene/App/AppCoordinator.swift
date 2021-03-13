//
//  AppCoordinator.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import Swinject

enum AppRoute {
    case levelSelect
    case game
}

final class AppCoordinator: ObservableObject {
    
    @Published var route: AppRoute = .levelSelect
    
}

//MARK: PServiceType

extension AppCoordinator: PServiceType {
    
    static func make(_ r: Resolver) -> AppCoordinator {
        return AppCoordinator()
    }
}


