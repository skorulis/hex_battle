//
//  IocConfig.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import Swinject

public final class IOCConfig {
    
    private  let container: Container
    
    public init() {
        container = Container()
    }
    
    @discardableResult
    public func configure() -> IOCConfig {
        setupServices()
        return self
    }
    
    private func setupServices() {
        container.register(MapService.self)
    }
    
    public func get<Service>(_ serviceType: Service.Type = Service.self) -> Service? {
        return container.resolve(serviceType)
    }
    
}
