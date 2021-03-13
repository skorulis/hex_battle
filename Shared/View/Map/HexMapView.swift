//
//  HexMapView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct HexMapView {
    
    let model: HexMapModel
    
    
}


// MARK: - Rendering

extension HexMapView: View {
    
    var body: some View {
        ZStack {
            edges
            nodes
        }
        
    }
    
    private var nodes: some View {
        ZStack {
            ForEach(model.nodes) { node in
                Text("\(node.id)")
                    .position(x: CGFloat(node.x), y: CGFloat(node.y))
            }
        }
        .frame(width: model.size.width + 20, height: model.size.height + 20)
        
    }
    
    private var edges: some View {
        Path { path in
            for edge in model.edges {
                let node1 = model.node(id: edge.id1)
                let node2 = model.node(id: edge.id2)
                path.move(to: node1.point)
                path.addLine(to: node2.point)
            }
        }
        .stroke()
        .frame(width: model.size.width + 20, height: model.size.height + 20)
    }
    
}


// MARK: - Previews

struct HexMapView_Previews: PreviewProvider {
    
    static var previews: some View {
        let nodes = [
            HexMapNode(id: 1, x: 50, y: 50),
            HexMapNode(id: 2, x: 100, y: 50)
        ]
        let edges = [
            HexMapEdge(id1: 1, id2: 2)
        ]
        let model = HexMapModel(name: "Map1", nodes: nodes, edges: edges)
        
        
        return HexMapView(model: model)
    }
    
}
