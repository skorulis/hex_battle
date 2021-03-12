//
//  IocConfig.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import Swinject

final class IOCConfig {
    
    let container: Container
    
    init() {
        container = Container()
    }
    
    @discardableResult
    func configure() -> IOCConfig {
        setupServices()
        return self
    }
    
    private func setupServices() {
        container.register(MapService.self)
    }
    
    func get<Service>(_ serviceType: Service.Type = Service.self) -> Service? {
        return container.resolve(serviceType)
    }
    
}
