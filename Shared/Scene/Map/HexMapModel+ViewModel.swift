//
//  HexMapModel+ViewModel.swift
//  HexBattleTests
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation

extension HexMapModel {
    
    var size: CGSize {
        let width = nodes.map { $0.x }.max() ?? 0
        let height = nodes.map { $0.y }.max() ?? 0
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    func node(id: Int) -> HexMapNode {
        return self.nodes.first(where: { $0.id == id })!
    }
}

extension HexMapNode: Identifiable {
    
    var point: CGPoint {
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
}

extension HexMapEdge: Identifiable {
    
    public var id: String {
        return "\(id1)-\(id2)"
    }
}
