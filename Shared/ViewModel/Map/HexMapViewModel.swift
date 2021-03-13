//
//  HexMapViewModel.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation

final class HexMapViewModel: ObservableObject {
    
    let map: HexMapModel
    @Published var mapState: HexMapState
    
    init(map: HexMapModel, state: HexMapState, stateService: GameStateService?) {
        self.map = map
        self.mapState =  state
        stateService?.$state
            .filter { $0 != nil}
            .map { $0! }
            .assign(to: &$mapState)
    }
    
    func nodeState(id: Int) -> HexMapNodeState {
        return mapState.nodes[id]!
    }
    
}


