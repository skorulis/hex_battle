//
//  GameStateServiceTests.swift
//  HexBattleTests
//
//  Created by Alexander Skorulis on 13/3/21.
//

@testable import HexBattle
import Foundation
import XCTest

class GameStateServiceTests: XCTestCase {
    
    let ioc = IOCConfig().configure()
    lazy var sut = ioc.get(GameStateService.self)!
    
    func testReposition() {
        let nodes = [
            HexMapNode(id: 1, x: 0, y: 1, initialState: nil),
            HexMapNode(id: 2, x: 2, y: 2, initialState: nil),
        ]
        let map = HexMapModel(name: "test", nodes: nodes, edges: [], players: [])
        let grid = HexGrid(hexSize: 40)
        let adjusted = MapInitialisationService.reposition(map, grid: grid)
        
        let node1 = adjusted.nodes[0]
        let node2 = adjusted.nodes[1]
        
        XCTAssertEqual(CGFloat(node1.x), 40)
        XCTAssertEqual(CGFloat(node1.y), 103, accuracy: 1)
        
        XCTAssertEqual(CGFloat(node2.x), 160)
        XCTAssertEqual(CGFloat(node2.y), 173, accuracy: 1)
        
    }
    
    func testInitialState() {
        let s1 = HexMapNodeState(type: .command, owner: 1)
        let nodes = [
            HexMapNode(id: 1, x: 0, y: 5, initialState: s1),
            HexMapNode(id: 2, x: 100, y: 100, initialState: nil),
        ]
        let players = [MapPlayer(id: 1, initialBuildings: [:])]
        
        let map = HexMapModel(name: "test", nodes: nodes, edges: [], players: players)
        let state = MapInitialisationService.buildState(map)
        
        XCTAssertEqual(state.nodes[1]?.owner, 1)
        XCTAssertEqual(state.nodes[1]?.type, .command)
        
        XCTAssertEqual(state.players.count, 1)
    }
    
    func testViewModel() {
        let s1 = HexMapNodeState(type: .command, owner: 1)
        let nodes = [
            HexMapNode(id: 1, x: 0, y: 5, initialState: s1),
            HexMapNode(id: 2, x: 100, y: 100, initialState: nil),
        ]
        let map = HexMapModel(name: "test", nodes: nodes, edges: [], players: [])
        
        sut.start(map: map)
        let viewModel = sut.mapViewModel()
        
        XCTAssertEqual(viewModel.mapState.nodes[1]?.owner, 1)
        sut.state?.nodes[1]?.owner = 2
        
        XCTAssertEqual(viewModel.mapState.nodes[1]?.owner, 2)
        
    }
    
    
}
