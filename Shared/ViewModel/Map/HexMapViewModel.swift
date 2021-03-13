//
//  HexMapViewModel.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation

final class HexMapViewModel: ObservableObject {
    
    let stateService: GameStateService?
    let map: HexMapModel
    @Published var mapState: HexMapState
    @Published var selectedNode: Int?
    
    init(map: HexMapModel, state: HexMapState, stateService: GameStateService?) {
        self.map = map
        self.mapState = state
        self.stateService  =  stateService
        stateService?.$state
            .filter { $0 != nil}
            .map { $0! }
            .assign(to: &$mapState)
        
        stateService?.$selectedNode
            .assign(to: &$selectedNode)
    }
    
    func nodeState(id: Int) -> HexMapNodeState {
        return mapState.nodes[id]!
    }
    
    func isSelected(id: Int) -> Bool {
        return stateService?.selectedNode == id
    }
    
    
}

// MARK: - Behaviours

extension HexMapViewModel {
    
    func selectNode(id: Int) -> () -> Void {
        return {
            self.stateService?.selectedNode = id
        }
    }
}


