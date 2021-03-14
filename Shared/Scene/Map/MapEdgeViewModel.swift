//
//  MapEdgeViewModel.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 14/3/21.
//

import Foundation

final class MapEdgeViewModel {
    
    let node1: HexMapNode
    let node2: HexMapNode
    
    let type1: NodeType
    let type2: NodeType
    
    init(node1: HexMapNode,
         node2: HexMapNode,
         type1: NodeType,
         type2: NodeType
    ) {
        self.node1 = node1
        self.node2 = node2
        self.type1 = type1
        self.type2 = type2
    }
    
    var minX: CGFloat {
        return CGFloat(min(node1.x, node2.x))
    }
    
    var minY: CGFloat  {
        return CGFloat(min(node1.y, node2.y))
    }
    
    var isFlowingForwards: Bool {
        return type1.sendsFlow && type2.acceptsFlow
    }
    
    var isFlowingBackwards: Bool {
        return type2.sendsFlow && type1.acceptsFlow
    }
}

extension MapEdgeViewModel: Identifiable {
    
    var id: String {
        return "\(node1.id)-\(node2.id)"
    }
}


