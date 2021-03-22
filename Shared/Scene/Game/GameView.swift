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
        VStack {
            maybeMap
            GameControlsView(viewModel: viewModel)
                .frame(height: 80)
        }
        /*.fullScreen(
            id: "controls\(viewModel.selectedNodeId ?? 0)",
            item: viewModel.selectedNode,
            content: selectedControls
        )*/
    }
    
    @ViewBuilder
    public var maybeMap: some View {
        if let mapVM = viewModel.mapViewModel() {
            MapView(
                viewModel: mapVM,
                selectionViewModel: viewModel.selectionViewModel,
                namespace: namespace)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    public func selectedControls(item: MapNodeState) -> some View {
        NodeButtonsView(node: item, viewModel: viewModel.selectionViewModel)
        .matchedGeometryEffect(id: "node-\(item.id)", in: namespace, properties: .position, isSource: false)
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

