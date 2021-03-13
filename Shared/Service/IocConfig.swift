//
//  IocConfig.swift
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
        container.register(MapService.self)
        container.register(GameStateService.self).inObjectScope(.container)
    }
    
    private func setupViewModels() {
        container.register(HexGameViewModel.self).inObjectScope(.weak)
    }
    
    public func get<Service>(_ serviceType: Service.Type = Service.self) -> Service? {
        return container.resolve(serviceType)
    }
    
}
