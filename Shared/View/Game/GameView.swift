//
//  GameView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import SwiftUI

// MARK: - Memory footprint

struct GameView {
    
    let viewModel: GameViewModel
    
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
        }
    }
    
    var controls: some View  {
        Button(action: {}, label: {
            Text("Do something")
        })
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
        let viewModel = GameViewModel(stateService: stateService)
        GameView(viewModel: viewModel)
    }
}

