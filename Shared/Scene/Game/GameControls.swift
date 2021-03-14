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
        ScrollView(.horizontal, showsIndicators: false, content: {
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
                
                commandProgress
                
                Button(action: viewModel.deselect, label: {
                    Text("Cancel")
                })
                
                
            }
        })
        
    }
    
    @ViewBuilder
    var commandProgress: some View {
        ForEach(viewModel.playerState.constructionQueue) { (item) in
            let type = item.type
            if let timing = item.time {
                let initial = (Date().timeIntervalSince1970 - timing.start) / timing.duration
                
                let target = BuildProgressView.Target(initial: CGFloat(initial), final: 1, duration: timing.duration)
                BuildProgressView(type: type, target: target)
            } else {
                BuildProgressView(type: type)
            }
            
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

