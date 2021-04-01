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
    @Namespace var namespace
    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
    }
    
}

// MARK: - Rendering

extension GameView: View {
    
    var body: some View {
        ZStack {
            VStack {
                maybeMap
                PlayerStatusView(viewModel: viewModel.playerStatusViewModel)
            }
            maybeProjectiles
            
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Button(action: viewModel.dumpMap, label: {
                        Text("SAVE")
                    })
                    .frame(alignment: .topLeading)
                }
                Spacer()
            }
        }
        
    }
    
    @ViewBuilder
    var maybeProjectiles: some View {
        ProjectilesView(viewModel: viewModel.projectilesViewModel)
            .background(Color.green.opacity(0.5))
    }
    
    @ViewBuilder
    public var maybeMap: some View {
        if let mapVM = viewModel.mapViewModel() {
            MapView(
                viewModel: mapVM,
                selectionViewModel: viewModel.selectionViewModel,
                namespace: namespace
            )
        } else {
            EmptyView()
        }
    }
    
}

// MARK: - Previews

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        let initService = MapInitialisationService()
        let stateService = GameStateService(initService: initService, recipes: RecipeService())
        stateService.start(map: MapView_Previews.previewMap)
        stateService.selectedNode = 1
        let viewModel = GameViewModel(stateService: stateService)
        return GameView(viewModel: viewModel)
    }
}

