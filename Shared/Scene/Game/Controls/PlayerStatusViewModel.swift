//
//  PlayerStatusViewModel.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 23/3/21.
//

import Foundation

final class PlayerStatusViewModel: ObservableObject {
    
    private let stateService: GameStateService?
    
    @Published
    var playerState: PlayerState
    
    init(stateService: GameStateService?) {
        self.stateService = stateService
        
        let playerId = stateService?.playerId ?? 1
        
        //TODO: Is this line needed
        self.playerState = stateService?.playerStates[playerId] ?? PlayerState(id: playerId)
        
        stateService?.$state
            .map { $0!.players[playerId]! }
            .assign(to: &$playerState)
    }
    
}
