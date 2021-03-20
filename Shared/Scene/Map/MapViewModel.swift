//
//  MapViewModel.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import Swinject

final class MapViewModel: ObservableObject {
    
    var stateService: GameStateService?
    let map: HexMapModel
    @Published var mapState: HexMapState
    @Published var selectedNode: Int?
    
    init(map: HexMapModel, state: HexMapState) {
        self.map = map
        self.mapState = state
    }
    
    init(stateService: GameStateService) {
        self.map = stateService.map!
        self.mapState = stateService.state!
        self.stateService = stateService
        stateService.$state
            .filter { $0 != nil}
            .map { $0! }
            .assign(to: &$mapState)
        
        stateService.$selectedNode
            .assign(to: &$selectedNode)
    }
    
    func nodeState(id: Int) -> MapNodeState {
        return mapState.nodes[id]!
    }
    
    func isSelected(id: Int) -> Bool {
        return stateService?.selectedNode == id
    }
    
    var edgeViewModels: [MapEdgeViewModel] {
        return map.edges.map { (edge) -> MapEdgeViewModel in
            let node1 = map.node(id: edge.id1)
            let node2 = map.node(id: edge.id2)
            let type1 = mapState.nodes[edge.id1]?.type ?? .empty
            let type2 = mapState.nodes[edge.id2]?.type ?? .empty
            
            return MapEdgeViewModel(node1: node1, node2: node2, type1: type1, type2: type2)
        }
    }
    
}

// MARK: - Behaviours

extension MapViewModel {
    
    func selectNode(id: Int) -> () -> Void {
        return {
            self.stateService?.selectedNode = id
        }
    }
}


//MARK: PServiceType

extension MapViewModel: PServiceType {
    
    static func make(_ r: Resolver) -> MapViewModel {
        return MapViewModel(stateService: r.forceResolve())
    }
}


