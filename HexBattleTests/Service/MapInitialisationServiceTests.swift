//
//  MapInitialisationServiceTests.swift
//  HexBattleTests
//
//  Created by Alexander Skorulis on 18/3/21.
//

import Foundation

@testable import HexBattle
import Foundation
import XCTest

class MapInitialisationServiceTests: XCTestCase {
    
    let ioc = IOCConfig().configure()
    lazy var sut = ioc.get(MapInitialisationService.self)!
    lazy var maps = ioc.get(MapService.self)!
    
    
    func testInit() throws {
        let map = maps.map(named: "TestMap1")!
        let output = try sut.initialise(map: map, grid: HexGrid())
        
        let state = output.state
        
        XCTAssertEqual(state.allPlayers.count, 2)
        XCTAssertEqual(state.players[1]?.readyBuildings[.alpha], 2)
    }
    
}


