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
    
    init(node1: HexMapNode,
         node2: HexMapNode
    ) {
        self.node1 = node1
        self.node2 = node2
    }
    
    var minX: CGFloat {
        return CGFloat(min(node1.x, node2.x))
    }
    
    var minY: CGFloat  {
        return CGFloat(min(node1.y, node2.y))
    }
}

extension MapEdgeViewModel: Identifiable {
    
    var id: String {
        return "\(node1.id)-\(node2.id)"
    }
}


