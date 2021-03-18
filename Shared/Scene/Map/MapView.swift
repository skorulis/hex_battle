//
//  MapView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct MapView {
    
    @ObservedObject var viewModel: MapViewModel
    
    var model: HexMapModel {
        return viewModel.map
    }
    
}


// MARK: - Rendering

extension MapView: View {
    
    var body: some View {
        ZStack {
            Color.offWhite
            complexEdges
            borders
            nodes
        }
        .mapFrame(viewModel.map)
    }
    
    private var nodes: some View {
        ZStack {
            ForEach(model.nodes) { node in
                let state = viewModel.nodeState(id: node.id)
                MapNodeView(
                    model: node,
                    state: state,
                    selected: viewModel.selectedNode == node.id,
                    action: viewModel.selectNode(id: node.id)
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
    
    private var complexEdges: some View {
        ZStack {
            ForEach(viewModel.edgeViewModels) { edge in
                MapEdgeView(viewModel: edge)
            }
        }
        .mapFrame(viewModel.map)
    }
    
    private var borders: some View {
        ZStack {
            ForEach(viewModel.mapState.allPlayers) { player in
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

struct MapView_Previews: PreviewProvider {
    
    static var previewMap: HexMapModel {
        let c1 = HexMapNodeState(type: .command, owner: 1)
        let c2 = HexMapNodeState(type: .command, owner: 2)
        
        let nodes = [
            HexMapNode(id: 1, x: 0, y: 0, initialState: c1),
            HexMapNode(id: 2, x: 1, y: 1, initialState: nil),
            HexMapNode(id: 3, x: 2, y: 1, initialState: c2),
            HexMapNode(id: 4, x: 3, y: 1, initialState: nil),
            HexMapNode(id: 5, x: 2, y: 0, initialState: nil),
            HexMapNode(id: 6, x: 2, y: 2, initialState: nil),
        ]
        let edges = [
            HexMapEdge(id1: 1, id2: 2),
            HexMapEdge(id1: 2, id2: 3),
            HexMapEdge(id1: 3, id2: 4),
            HexMapEdge(id1: 3, id2: 5),
            HexMapEdge(id1: 3, id2: 6),
        ]
        let players = [
            MapPlayer(id: 1, initialBuildings: [NodeType.alpha.rawValue: 2]),
            MapPlayer(id: 2, initialBuildings: [NodeType.alpha.rawValue: 2]),
        ]
        
        let grid = HexGrid()
        return MapInitialisationService.reposition(HexMapModel(name: "Map1", nodes: nodes, edges: edges, players: players), grid: grid)
    }
    
    static var previewViewModel: MapViewModel {
        let map = previewMap
        let state = MapInitialisationService.buildState(map)
        let viewModel = MapViewModel(map: previewMap, state: state, stateService: nil)
        viewModel.mapState.nodes[2] = HexMapNodeState(type: .passive, owner: 1)
        
        viewModel.mapState.nodes[4] = HexMapNodeState(type: .passive, owner: 2)
        
        return viewModel
    }
    
    static var previews: some View {
        return MapView(viewModel: previewViewModel)
    }
    
}
