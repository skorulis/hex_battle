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
                HexMapNodeView(model: node)
                    .position(x: CGFloat(node.x), y: CGFloat(node.y))
            }
        }
        .mapFrame(model)
        
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
        .stroke(Color.gray)
        .mapFrame(model)
    }
    
}

// MARK: - View extensions

extension View {
    
    func mapFrame(_ model: HexMapModel) -> some View {
        let width = model.size.width + RenderConstants.nodeRadius + RenderConstants.borderBuffer
        let height = model.size.height + RenderConstants.nodeRadius + RenderConstants.borderBuffer
        
        return frame(width: width, height: height)
    }
}


// MARK: - Previews

struct HexMapView_Previews: PreviewProvider {
    
    static var previews: some View {
        let nodes = [
            HexMapNode(id: 1, x: 40, y: 40),
            HexMapNode(id: 2, x: 100, y: 190)
        ]
        let edges = [
            HexMapEdge(id1: 1, id2: 2)
        ]
        let model = HexMapModel(name: "Map1", nodes: nodes, edges: edges)
        
        
        return HexMapView(model: model)
    }
    
}
