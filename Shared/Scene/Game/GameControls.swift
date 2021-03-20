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
        if let selected = viewModel.selectedNodeId, let node = viewModel.nodeState(id: selected) {
            ScrollView(.horizontal, showsIndicators: false, content: {
                switch node.type {
                case .command:
                    commandButtons
                case .empty:
                    emptyButtons
                default:
                    Text("TODO")
                }
            })
        } else {
            EmptyView()
        }
    }
    
    func typeButton(type: NodeType, action: @escaping () -> ()) -> some View {
        ZStack(alignment: .bottomTrailing ){
            Button(action: action, label: {
                Text(type.name)
            })
            .buttonStyle(RoundButtonStyle(selected: false))
            Group {
                Spacer()
                Text("\(viewModel.builtCount(type: type))")
                    .frame(alignment:.bottomLeading)
            }
        }
    }
}

// MARK: - Command

extension GameControlsView {
    
    var commandButtons: some View {
        HStack(spacing: 10) {
            ForEach(NodeType.buildable) { type in
                typeButton(type: type, action: viewModel.startConstruction(type: type))
            }
            
            commandProgress
            
            Button(action: viewModel.deselect, label: {
                Text("Cancel")
            })
        }
    }
    
    @ViewBuilder
    var commandProgress: some View {
        ForEach(viewModel.playerState.constructionQueue) { (item) in
            let type = item.type
            if let timing = item.time {
                let initial = (Date().timeIntervalSince1970 - timing.start) / timing.duration
                let remaining = timing.duration * (1 - initial)
                
                let target = BuildProgressView.Target(initial: CGFloat(initial), final: 1, duration: remaining)
                BuildProgressView(type: type, target: target)
            } else {
                BuildProgressView(type: type)
            }
        }
    }
        
}

// MARK: - Empty

extension GameControlsView {
    
    var emptyButtons: some View {
        HStack(spacing: 10) {
            ForEach(NodeType.buildable) { type in
                typeButton(type: type, action: viewModel.buildNode(type: type))
                    .disabled(viewModel.builtCount(type: type) == 0)
            }
        }
    }
    
}


// MARK: - Previews

struct GameControlsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let initService = MapInitialisationService()
        let stateService = GameStateService(initService: initService, recipes: RecipeService())
        stateService.start(map: MapView_Previews.previewMap)
        stateService.selectedNode = 2
        let viewModel = GameViewModel(stateService: stateService)
        return GameControlsView(viewModel: viewModel)
    }
}

