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
    
    let viewModel: HexMapViewModel
    
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
            borders
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
    
    private var borders: some View {
        ZStack {
            ForEach(viewModel.mapState.players) { player in
                TerritoryBorder(viewModel: viewModel, player: player)
            }
        }
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
            HexMapNode(id: 4, x: 300, y: 100),
            HexMapNode(id: 5, x: 300, y: 200),
            HexMapNode(id: 6, x: 300, y: 0),
        ]
        let edges = [
            HexMapEdge(id1: 1, id2: 2),
            HexMapEdge(id1: 2, id2: 3),
            HexMapEdge(id1: 3, id2: 4),
            HexMapEdge(id1: 3, id2: 5),
            HexMapEdge(id1: 3, id2: 6),
        ]
        return HexMapModel(name: "Map1", nodes: nodes, edges: edges)
    }
    
    static var previewViewModel: HexMapViewModel {
        let viewModel = HexMapViewModel(map: previewMap)
        viewModel.mapState.nodes[1]?.owner = 1
        viewModel.mapState.nodes[2]?.owner = 1
        
        viewModel.mapState.nodes[3]?.owner = 2
        viewModel.mapState.nodes[4]?.owner = 2
        
        viewModel.mapState.players = [
            PlayerModel(id: 1),
            PlayerModel(id: 2),
        ]
        return viewModel
    }
    
    static var previews: some View {
        return HexMapView(viewModel: previewViewModel)
    }
    
}
