//
//  AppCoordinatorView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import SwiftUI

// MARK: - Memory footprint

struct AppCoordinatorView {
    
    @ObservedObject var viewModel: AppCoordinator
    let ioc: IOCConfig
    
    init(ioc: IOCConfig) {
        self.ioc = ioc
        self.viewModel = ioc.get(AppCoordinator.self)!
    }
}

// MARK: - Rendering

extension AppCoordinatorView: View {
    
    var body: some View {
        switch viewModel.route {
        case .levelSelect:
            LevelSelectionView(viewModel: ioc.get(LevelSelectionViewModel.self)!)
        case .game:
            GameView(viewModel: ioc.get(GameViewModel.self)!)
        }
    }
}
