//
//  MapError.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 17/3/21.
//

import Foundation

enum MapError: Error {
    
    case duplicateIds
    case duplicatePositions
    case duplicateEdges
}
