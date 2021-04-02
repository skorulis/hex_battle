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
    private let eventService: NodeEventService
    let recipes: RecipeService
    
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
    
    @Published var missiles: [Missile]
    
    public var playerStates: [Int: PlayerState] {
        return state?.players ?? [:]
    }
    
    public init(
        initService: MapInitialisationService,
        recipes: RecipeService,
        eventService: NodeEventService
    ) {
        self.initService = initService
        self.recipes = recipes
        self.eventService = eventService
        self.missiles = []
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
        nodeState.health = type.maxHealth
        state?.nodes[nodeId] = nodeState
        
        var playerState = playerStates[owner]!
        playerState.remove(node: type)
        self.state?.players[owner] = playerState
    }
    
    private func constructionEvent(player: Int) -> EventTimeFrame {
        let duration: TimeInterval = 10 * 0.2
        let subscriber = Timer.publish(every: duration, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
            self.finishConstruction(player: player)
        }
        
        return EventTimeFrame(start: Date().timeIntervalSince1970, duration: duration, subscriber: subscriber)
    }
    
    func clearNode(playerId: Int, nodeId: Int) {
        guard var nodeState = state?.nodes[nodeId] else {
            return
        }
        nodeState.owner = nil
        nodeState.type = .empty
        nodeState.health = 0
        nodeState.nextEvent = nil
        state?.nodes[nodeId] = nodeState
    }
    
    func buildEffect(node: MapNodeState, effect: NodeEffect) {
        guard var stateNode = state?.nodes[node.id] else {
            return
        }
        stateNode.activeEffect = effect
        updateEvents(node: &stateNode)
        state?.nodes[node.id] = stateNode
    }
    
    private func updateEvents(node: inout MapNodeState) {
        node.nextEvent = eventService.event(for: node, stateService: self)
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
            if nodeState.activeEffect == .none && nodeState.type != .command {
                let availableRecipes = recipes.availableRecipes(inputs: nodeState.energyInputs)
                nodeState.activeEffect = availableRecipes.first?.output ?? .none
            }
            updateEvents(node: &nodeState)
            state.nodes[node.id] = nodeState
        }
        
        state.lastEnergyToken = token
        self.state = state
    }
    
    func calculateEnergy(node: MapNodeState) -> [NodeType: Int] {
        guard let owner = node.owner else {
            return [:]
        }
        let conn = connectedNodes(id: node.id)
        return conn.reduce([:]) { (result, node) -> [NodeType: Int] in
            if node.owner != owner {
                return result
            }
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
            recipes: r.forceResolve(),
            eventService: r.forceResolve()
            )
    }
}


