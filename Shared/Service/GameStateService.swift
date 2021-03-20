//
//  GameStateService.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import Swinject

final class GameStateService: ObservableObject {
    
    private let initService: MapInitialisationService
    private let recipes: RecipeService
    
    public var map: HexMapModel?
    public var grid: HexGrid = HexGrid()
    public var playerId: Int = 1 //Always player 1 for now
    
    @Published
    public var state: HexMapState? {
        didSet {
            updateEnergy()
        }
    }
    
    @Published
    public var selectedNode: Int?
    
    public var playerStates: [Int: PlayerState] {
        return state?.players ?? [:]
    }
    
    public init(
        initService: MapInitialisationService,
        recipes: RecipeService
    ) {
        self.initService = initService
        self.recipes = recipes
    }
    
    public func start(map: HexMapModel) {
        let checked = try! initService.initialise(map: map, grid: grid)
        self.map = checked.map
        self.state = checked.state
    }

    public func mapViewModel() -> MapViewModel {
        return MapViewModel(stateService: self)
    }
    
}

// MARK: Behaviours

extension GameStateService {
    
    func startConstruction(player:Int, type: NodeType) {
        var state = self.playerStates[player]!
        
        var item = PlayerState.ConstructionQueueItem(type: type, time: nil)
        if state.constructionQueue.count == 0 {
            item.time = constructionEvent(player: player)
        }
        
        state.constructionQueue.append(item)

        self.state?.players[player] = state
    }
    
    func buildNode(type: NodeType, nodeId: Int, owner: Int) {
        guard var nodeState = state?.nodes[nodeId] else {
            return
        }
        nodeState.owner = owner
        nodeState.type = type
        state?.nodes[nodeId] = nodeState
        
        var playerState = playerStates[owner]!
        playerState.remove(node: type)
        self.state?.players[owner] = playerState
    }
    
    private func constructionEvent(player: Int) -> PlayerState.ConstructionTimeFrame {
        let duration: TimeInterval = 10 * 0.2
        let subscriber = Timer.publish(every: duration, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
            self.finishConstruction(player: player)
        }
        
        return PlayerState.ConstructionTimeFrame(start: Date().timeIntervalSince1970, duration: duration, subscriber: subscriber)
    }
    
}

// MARK: - Calculations

extension GameStateService {
    
    func connectedNodes(id: Int) -> [MapNodeState] {
        guard let state = state else { return [] }
        let nodeIds = map?.edges.compactMap { $0.connected(id) } ?? []
        let states = nodeIds.map { state.nodes[$0]! }
        return states 
    }
    
    func updateEnergy() {
        guard var state = state else { return }
        let token = state.energyToken
        guard token != state.lastEnergyToken else { return }
        
        for node in map?.nodes ?? [] {
            guard var nodeState = state.nodes[node.id] else { continue }
            nodeState.energyInputs = calculateEnergy(node: nodeState)
            if nodeState.activeEffect == .none {
                let availableRecipes = recipes.availableRecipes(inputs: nodeState.energyInputs)
                nodeState.activeEffect = availableRecipes.first?.output ?? .none
            }
            
            state.nodes[node.id] = nodeState
        }
        
        state.lastEnergyToken = token
        self.state = state
    }
    
    func calculateEnergy(node: MapNodeState) -> [NodeType: Int] {
        let conn = connectedNodes(id: node.id)
        return conn.reduce([:]) { (result, node) -> [NodeType: Int] in
            var dict = result
            for e in node.energyOutputs {
                dict[e] = (dict[e] ?? 0) + 1
            }
            return dict
        }
    }
    
}

// MARK: - Time events

extension GameStateService {
    
    private func finishConstruction(player: Int) {
        var state = self.playerStates[player]!
        let built = state.constructionQueue.removeFirst()
        state.add(node: built.type)
        if state.constructionQueue.count > 0 {
            var first = state.constructionQueue[0]
            first.time = constructionEvent(player: player)
            state.constructionQueue[0] = first
        }
        self.state?.players[player] = state
    }
    
}

//MARK: PServiceType

extension GameStateService: PServiceType {
    
    static func make(_ r: Resolver) -> GameStateService {
        return GameStateService(
            initService: r.forceResolve(),
            recipes: r.forceResolve()
            )
    }
}


