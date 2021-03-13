//
//  PlayerModel.swift
//  HexBattleTests
//
//  Created by Alexander Skorulis on 13/3/21.
//

import Foundation
import SwiftUI

struct PlayerModel: Codable, Identifiable {
    
    let id: Int
    
    var color: Color {
        switch id {
        case 1: return .blue
        case 2: return .red
        case 3: return .yellow
        default: return .orange
        }
    }
}
