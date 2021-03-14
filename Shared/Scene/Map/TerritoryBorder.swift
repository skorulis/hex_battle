//
//  TerritoryBorder.swift
//  HexBattleTests
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation

import SwiftUI
    
// MARK: - Memory footprint

struct TerritoryBorder {
    
    @ObservedObject var viewModel: MapViewModel
    let player: PlayerModel
    
}

// MARK: - Rendering

extension TerritoryBorder: View {
    
    var body: some View {
        Path { path in
            for node in viewModel.map.nodes {
                if viewModel.nodeState(id: node.id).owner == player.id {
                    let point = CGRect(
                        x: CGFloat(node.x) - RenderConstants.basicTerritoryRadius,
                        y: CGFloat(node.y) - RenderConstants.basicTerritoryRadius,
                        width: RenderConstants.basicTerritoryRadius * 2,
                        height: RenderConstants.basicTerritoryRadius * 2
                    )
                    path.addEllipse(in: point)
                }
            }
            
        }
        .stroke(player.color)
        EmptyView()
    }
    
}

// MARK: - Previews

struct TerritoryBorder_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = MapView_Previews.previewViewModel
        let player = PlayerModel(id: 1)
        TerritoryBorder(viewModel: viewModel, player: player)
    }
}

