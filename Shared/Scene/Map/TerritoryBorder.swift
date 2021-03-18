//
//  TerritoryBorder.swift
//  HexBattleTests
//
//  Created by Alexander Skorulis on 13/3/21.
//

import CGPointVector
import Foundation

import SwiftUI
    
// MARK: - Memory footprint

struct TerritoryBorder {
    
    @ObservedObject var viewModel: MapViewModel
    let player: PlayerState
    
    var grid: HexGrid {
        return viewModel.stateService?.grid ?? HexGrid()
    }
    
}

// MARK: - Rendering

extension TerritoryBorder: View {
    
    var body: some View {
        Path { path in
            for node in viewModel.map.nodes {
                if viewModel.nodeState(id: node.id).owner == player.id {
                    let middlePoint = node.point - CGPoint(x: grid.width/2, y: grid.height/2)
                    path.addLines(grid.pathPoints.map { $0 + middlePoint })
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
        let player = PlayerState(id: 1)
        TerritoryBorder(viewModel: viewModel, player: player)
    }
}

