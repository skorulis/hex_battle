//
//  HexMapViewModelTests.swift
//  HexBattleTests
//
//  Created by Alexander Skorulis on 13/3/21.
//

@testable import HexBattle
import Foundation
import XCTest

class HexMapViewModelTests: XCTestCase {
    
    func testReposition() {
        let nodes = [
            HexMapNode(id: 1, x: 0, y: 5),
            HexMapNode(id: 2, x: 100, y: 100),
        ]
        let map = HexMapModel(name: "test", nodes: nodes, edges: [])
        let model = HexMapViewModel(map: map)
        
        let node1 = model.map.nodes[0]
        let node2 = model.map.nodes[1]
        
        let buffer = RenderConstants.borderBuffer + RenderConstants.nodeRadius
        
        XCTAssertEqual(CGFloat(node1.x), buffer)
        XCTAssertEqual(CGFloat(node1.y), buffer)
        
        XCTAssertEqual(CGFloat(node2.x), 100 + buffer)
        XCTAssertEqual(CGFloat(node2.y), 100 + buffer - 5)
        
    }
    
}

