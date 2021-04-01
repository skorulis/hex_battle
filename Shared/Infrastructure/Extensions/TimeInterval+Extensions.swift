//
//  TimeInterval+Extensions.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 30/3/21.
//

import Foundation

extension TimeInterval {
    
    static var unix: TimeInterval {
        return Date().timeIntervalSince1970
    }
}


