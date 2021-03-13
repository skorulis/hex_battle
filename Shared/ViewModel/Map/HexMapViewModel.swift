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
    
    init(map: HexMapModel) {
        let adjustedMap = HexMapViewModel.reposition(map)
        self.map = adjustedMap
        mapState = HexMapViewModel.buildState(adjustedMap)
    }
    
    func nodeState(id: Int) -> HexMapNodeState {
        return mapState.nodes[id]!
    }
    
}

// MARK: Helpers

extension HexMapViewModel {
    
    /// Make sure no nodes are too close to the edge
    private static func reposition(_ map: HexMapModel) -> HexMapModel {
        let buffer = RenderConstants.borderBuffer + RenderConstants.nodeRadius
        let minX = map.nodes.map { $0.x }.min() ?? 0
        let minY = map.nodes.map { $0.y }.min() ?? 0
        let xMovement = max(0, buffer - CGFloat(minX))
        let yMovement = max(0, buffer - CGFloat(minY))
        let mappedNodes = map.nodes.map { (node) -> HexMapNode in
            return HexMapNode(id: node.id, x: node.x + Double(xMovement), y: node.y + Double(yMovement))
        }
        return HexMapModel(name: map.name, nodes: mappedNodes, edges: map.edges)
    }
    
    private static func buildState(_ map: HexMapModel) -> HexMapState {
        var mapState = HexMapState()
        for node in map.nodes {
            mapState.nodes[node.id] = HexMapNodeState(type: .empty)
        }
        return mapState
    }
    
}
