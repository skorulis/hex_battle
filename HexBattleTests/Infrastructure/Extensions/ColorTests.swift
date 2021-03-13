//
//  ColorTests.swift
//  HexBattleTests
//
//  Created by Alexander Skorulis on 13/3/21.
//

@testable import HexBattle
import Foundation
import SwiftUI
import XCTest

class ColorTests: XCTestCase {
    
    func testRGB() {
        let b = Color.black.rgb
        XCTAssertEqual(b.red, 0)
        XCTAssertEqual(b.green, 0)
        XCTAssertEqual(b.blue, 0)
        
        
        let blue = Color.peterRiver.rgb
        
        
    }
    
}
