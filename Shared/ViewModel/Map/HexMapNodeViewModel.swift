//
//  HexMapNodeViewModel.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation

final class HexMapNodeViewModel: ObservableObject {
    
    let map: HexMapModel
    @Published var mapState: HexMapState
    
    init(map: HexMapModel) {
        self.map = map
        mapState = HexMapState()
        for node in map.nodes {
            mapState.nodes[node.id] = HexMapNodeState(type: .empty)
        }
    }
    
    func nodeState(id: Int) -> HexMapNodeState {
        return mapState.nodes[id]!
    }
    
    
}
