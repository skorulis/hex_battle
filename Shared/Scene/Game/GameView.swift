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
            GameControlsView(viewModel: viewModel)
                .frame(height: 80)
        }
    }
    
    @ViewBuilder
    public var maybeMap: some View {
        if let mapVM = viewModel.mapViewModel() {
            MapView(viewModel: mapVM)
        } else {
            EmptyView()
        }
    }
}

// MARK: - Previews

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        let stateService = GameStateService()
        stateService.start(map: MapView_Previews.previewMap)
        stateService.selectedNode = 1
        let viewModel = GameViewModel(stateService: stateService)
        return GameView(viewModel: viewModel)
    }
}

