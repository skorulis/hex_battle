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
        let s1 = HexMapNode.InitialState( type: .command, owner: 1)
        let nodes = [
            HexMapNode(id: 1, x: 0, y: 5, initialState: s1),
            HexMapNode(id: 2, x: 100, y: 100, initialState: nil),
        ]
        let players = [MapPlayer(id: 1, initialBuildings: [:])]
        
        let map = HexMapModel(name: "test", nodes: nodes, edges: [], players: players)
        let state = MapInitialisationService.buildState(map)
        
        XCTAssertEqual(state.nodes[1]?.owner, 1)
        XCTAssertEqual(state.nodes[1]?.type, .command)
        XCTAssertEqual(state.nodes[1]?.health, NodeType.command.maxHealth)
        
        XCTAssertEqual(state.players.count, 1)
    }
    
    func testViewModel() {
        let s1 = HexMapNode.InitialState(type: .command, owner: 1)
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
    
    func test_connectedNodes() {
        sut.start(map: GameStateServiceTests.map1)
        
        let nodes1 = sut.connectedNodes(id: 1)
        XCTAssertEqual(nodes1.count, 1)
        XCTAssertEqual(nodes1[0].id, 2)
        
        let nodes2 = sut.connectedNodes(id: 2)
        XCTAssertEqual(nodes2.count, 2)
        
        let nodes3 = sut.connectedNodes(id: 3)
        XCTAssertEqual(nodes3.count, 1)
        XCTAssertEqual(nodes3[0].id, 2)
    }
    
    func test_energy_distribution_basic() {
        sut.start(map: GameStateServiceTests.map1)
        
        //Only has one edge
        XCTAssertEqual(
            sut.calculateEnergy(node: sut.state!.nodes[1]!),
            [NodeType.alpha:1]
            )
        
        XCTAssertEqual(
            sut.calculateEnergy(node: sut.state!.nodes[2]!),
            [NodeType.alpha:1, NodeType.beta: 2, NodeType.gamma: 1]
            )
        
    }
    
    func test_energy_distribution_update() {
        sut.start(map: GameStateServiceTests.map1)
        
        let node1 = sut.state?.nodes[1]
        XCTAssertEqual(
            node1?.energyInputs,
            [NodeType.alpha:1]
        )
        
        let node2 = sut.state?.nodes[2]
        XCTAssertEqual(
            node2?.energyInputs,
            [NodeType.alpha:1, NodeType.beta: 2, NodeType.gamma: 1]
        )
        
        XCTAssertEqual(node2?.activeEffect, NodeEffect.healing)
    }
    
    func test_energy_map1() throws {
        sut.start(map: try Self.loadMap(name: "test1"))
        
        let node8 = sut.state?.nodes[8]
        
        XCTAssertEqual(node8?.energyInputs.count, 0) 
    }
    
}

// MARK: Map information

extension GameStateServiceTests {
    
    static var map1: HexMapModel {
        let s1 = HexMapNode.InitialState(type: .command, owner: 1)
        let s2 = HexMapNode.InitialState(type: .alpha, owner: 1)
        let s3 = HexMapNode.InitialState(type: .beta, owner: 1)
        let nodes = [
            HexMapNode(id: 1, x: 0, y: 0, initialState: s1),
            HexMapNode(id: 2, x: 1, y: 1, initialState: s2),
            HexMapNode(id: 3, x: 2, y: 2, initialState: s3),
        ]
        let edges = [
            HexMapEdge(id1: 1, id2: 2),
            HexMapEdge(id1: 2, id2: 3)
        ]
        
        let players = [
            MapPlayer(id: 1, initialBuildings: [:])
        ]
        
        let map = HexMapModel(name: "test", nodes: nodes, edges: edges, players: players)
        return map
    }
    
    static func loadMap(name: String) throws -> HexMapModel {
        let url = Bundle.main.url(forResource: "testmaps/\(name)", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let map = try JSONDecoder().decode(HexMapModel.self, from: data)
        return map
    }
}
