//
//  GameControlsView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 14/3/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct GameControlsView {
    
    @ObservedObject var viewModel: GameViewModel
    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
    }
    
}

// MARK: - Rendering

extension GameControlsView: View {
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Divider()
            nodeControls
        }
    }
    
    @ViewBuilder
    private var nodeControls: some View {
        if let selected = viewModel.selectedNode, let node = viewModel.nodeState(id: selected) {
            switch node.type {
            case .command:
                commandButtons
            default:
                Text("TODO")
            }
            
        } else {
            EmptyView()
        }
        
        
    }
    
    var commandButtons: some View {
        HStack(spacing: 10) {
            Button(action: viewModel.startConstruction(type: .passive), label: {
                Text("Passive")
            })
            .buttonStyle(RoundButtonStyle(selected: false))
            
            Button(action: viewModel.startConstruction(type: .alpha), label: {
                Text("Alpha")
            })
            .buttonStyle(RoundButtonStyle(selected: false))
            
            Button(action: viewModel.startConstruction(type: .beta), label: {
                Text("Beta")
            })
            .buttonStyle(RoundButtonStyle(selected: false))
            
            Button(action: viewModel.startConstruction(type: .gamma), label: {
                Text("Gamma")
            })
            .buttonStyle(RoundButtonStyle(selected: false))
            
            ForEach(Array(viewModel.playerState.constructionQueue.indices), id: \.self) { (index) in
                Text("Building")
            }
            
            Button(action: viewModel.deselect, label: {
                Text("Cancel")
            })
            
            
        }
    }
}

// MARK: - Previews

struct GameControlsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let stateService = GameStateService()
        stateService.start(map: HexMapView_Previews.previewMap)
        stateService.selectedNode = 1
        let viewModel = GameViewModel(stateService: stateService)
        return GameControlsView(viewModel: viewModel)
    }
}

