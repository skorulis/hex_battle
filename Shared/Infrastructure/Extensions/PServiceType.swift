//
//  PServiceType.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import Swinject

protocol PServiceType {
    
    static func make(_ r: Resolver) -> Self
    
}

extension Container {
    
    @discardableResult
    func register<Service: PServiceType>(_ serviceType: Service.Type) -> ServiceEntry<Service> {
        return register(serviceType) { (r) -> Service in
            return serviceType.make(r)
        }
    }
}

extension Resolver {
    
    func resolve<Service>() -> Service? {
        return resolve(Service.self)
    }
    
    func forceResolve<Service>() -> Service {
        return resolve(Service.self)!
    }
}
