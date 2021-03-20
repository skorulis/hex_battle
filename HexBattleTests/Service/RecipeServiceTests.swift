//
//  RecipeServiceTests.swift
//  HexBattleTests
//
//  Created by Alexander Skorulis on 20/3/21.
//

import Foundation

@testable import HexBattle
import Foundation
import XCTest

class RecipeServiceTests: XCTestCase {
    
    let ioc = IOCConfig().configure()
    lazy var sut = ioc.get(RecipeService.self)!
    
    
    func testAvailableRecipes() {
        XCTAssertEqual(
            sut.availableRecipes(inputs: [NodeType.alpha: 1]).count,
            0
        )
        
        XCTAssertEqual(
            sut.availableRecipes(inputs: [NodeType.alpha: 2]).count,
            1
        )
        
    }
    
}

