//
//  GameView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import SwiftUI

// MARK: - Memory footprint

struct GameView {
    
    @ObservedObject var viewModel: GameViewModel
    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
    }
    
}

// MARK: - Rendering

extension GameView: View {
    
    var body: some View {
        VStack {
            maybeMap
            controls
                .frame(height: 60)
        }
    }
    
    @ViewBuilder
    var controls: some View  {
        if let selected = viewModel.selectedNode, let node = viewModel.nodeState(id: selected) {
            VStack {
                Divider()
            }
            nodeControls(node: node)
            
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func nodeControls(node: HexMapNodeState) -> some View {
        switch node.type {
        case .command:
            commandButtons
        default:
            Text("TODO")
        }
    }
    
    var commandButtons: some View {
        HStack {
            Button(action: viewModel.deselect, label: {
                Text("Cancel")
            })
        }
    }
    
    @ViewBuilder
    public var maybeMap: some View {
        if let mapVM = viewModel.mapViewModel() {
            HexMapView(viewModel: mapVM)
        } else {
            EmptyView()
        }
    }
}

// MARK: - Previews

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        let stateService = GameStateService()
        stateService.start(map: HexMapView_Previews.previewMap)
        stateService.selectedNode = 1
        let viewModel = GameViewModel(stateService: stateService)
        return GameView(viewModel: viewModel)
    }
}

