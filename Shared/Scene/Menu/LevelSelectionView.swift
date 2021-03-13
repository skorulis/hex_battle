//
//  LevelSelectionView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation

import SwiftUI

// MARK: - Memory footprint

struct LevelSelectionView {
    
    let viewModel: LevelSelectionViewModel
    
    init(viewModel: LevelSelectionViewModel) {
        self.viewModel = viewModel
    }
    
}

// MARK: - Rendering

extension LevelSelectionView: View {
    
    var body: some View {
        ForEach(viewModel.nameList, id: \.self) { (name) in
            Text(name)
                .padding()
                .onTapGesture(perform: viewModel.select(level: name))
        }
    }
}

// MARK: - Previews

struct LevelSelectionView_Previews: PreviewProvider {
    
    static var previews: some View {
        let service = MapService()
        let viewModel = LevelSelectionViewModel(mapService: service, appStateService: nil)
        LevelSelectionView(viewModel: viewModel)
    }
}

