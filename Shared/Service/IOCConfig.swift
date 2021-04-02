//
//  IOCConfig.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import Swinject

public final class IOCConfig {
    
    public static let shared = IOCConfig().configure()
    
    private  let container: Container
    
    public init() {
        container = Container()
    }
    
    @discardableResult
    public func configure() -> IOCConfig {
        setupServices()
        setupViewModels()
        return self
    }
    
    private func setupServices() {
        container.register(MapService.self).inObjectScope(.container)
        container.register(GameStateService.self).inObjectScope(.container)
        container.register(AppStateService.self).inObjectScope(.container)
        container.register(MapInitialisationService.self)
        container.register(RecipeService.self)
        
        container.register(NodeEventService.self).inObjectScope(.container)
    }
    
    private func setupViewModels() {
        container.register(LevelSelectionViewModel.self).inObjectScope(.weak)
        container.register(GameViewModel.self).inObjectScope(.weak)
        container.register(AppCoordinator.self).inObjectScope(.weak)
        container.register(ControlsViewModel.self).inObjectScope(.weak)
    }
    
    public func get<Service>(_ serviceType: Service.Type = Service.self) -> Service? {
        return container.resolve(serviceType)
    }
    
}
