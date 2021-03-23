//
//  PlayerStatusView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 23/3/21.
//

import Foundation

import SwiftUI

// MARK: - Memory footprint

struct PlayerStatusView {
    
    @ObservedObject var viewModel: PlayerStatusViewModel
    
    init(viewModel: PlayerStatusViewModel) {
        self.viewModel = viewModel
    }
    
}

// MARK: - Rendering

extension PlayerStatusView: View {
    
    var body: some View {
        HStack {
            if viewModel.playerState.constructionQueue.count == 0 {
                Text("No construction in progress")
            } else {
                buildingProgress
            }
        }
        .frame(minHeight: 50)
    }
    
    @ViewBuilder
    var buildingProgress: some View {
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

// MARK: - Previews

struct PlayerStatusView_Previews: PreviewProvider {
    
    static var previews: some View {
        var playerState = PlayerState(id: 1)
        playerState.constructionQueue.append(.init(type: .passive, time: nil))
        playerState.constructionQueue.append(.init(type: .gamma, time: nil))
        let viewModel = PlayerStatusViewModel(stateService: nil)
        viewModel.playerState = playerState
        return PlayerStatusView(viewModel: viewModel)
    }
}

