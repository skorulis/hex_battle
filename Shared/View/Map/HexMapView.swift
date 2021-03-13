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
    
    let viewModel: HexMapNodeViewModel
    
    var model: HexMapModel {
        return viewModel.map
    }
    
}


// MARK: - Rendering

extension HexMapView: View {
    
    var body: some View {
        ZStack {
            Color.offWhite
            edges
            nodes
        }
        .mapFrame(viewModel.map)
    }
    
    private var nodes: some View {
        ZStack {
            ForEach(model.nodes) { node in
                HexMapNodeView(
                    model: node,
                    state: viewModel.nodeState(id: node.id)
                )
                .position(x: CGFloat(node.x), y: CGFloat(node.y))
            }
        }
        .mapFrame(viewModel.map)
        
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
        .stroke(lineWidth: 6)
        .mapFrame(viewModel.map)
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
    
    static var previewMap: HexMapModel {
        let nodes = [
            HexMapNode(id: 1, x: 40, y: 40),
            HexMapNode(id: 2, x: 100, y: 190),
            HexMapNode(id: 3, x: 200, y: 100),
        ]
        let edges = [
            HexMapEdge(id1: 1, id2: 2)
        ]
        return HexMapModel(name: "Map1", nodes: nodes, edges: edges)
    }
    
    static var previews: some View {
        let viewModel = HexMapNodeViewModel(map: previewMap)
        return HexMapView(viewModel: viewModel)
    }
    
}
