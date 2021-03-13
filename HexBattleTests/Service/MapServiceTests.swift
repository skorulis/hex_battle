//
//  MapServiceTests.swift
//  Tests macOS
//
//  Created by Alexander Skorulis on 13/3/21.
//

@testable import HexBattle
import Foundation
import XCTest

class MapServiceTests: XCTestCase {
    
    let ioc = IOCConfig().configure()
    lazy var mapService = ioc.get(MapService.self)!
    
    
    func testLoadingMaps() {
        XCTAssertGreaterThan(mapService.allMaps().count, 0)
        
    }
    
}
