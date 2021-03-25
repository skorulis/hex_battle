//
//  RecipeService.swift
//  HexBattleTests
//
//  Created by Alexander Skorulis on 20/3/21.
//

import Foundation
import Swinject

// MARK: Memory footprint

struct RecipeService {
    
    static let recipes: [PowerRecipeModel] = [
        PowerRecipeModel(inputs: [.alpha: 2], output: .turret),
        PowerRecipeModel(inputs: [.beta: 2], output: .healing),
        PowerRecipeModel(inputs: [.gamma: 2], output: .rangeBoost),
    ]
    
    func availableRecipes(inputs: [NodeType: Int]) -> [PowerRecipeModel] {
        return RecipeService.recipes.filter { (recipe) -> Bool in
            return recipe.inputs.allSatisfy { (key, value) -> Bool in
                (inputs[key] ?? 0) >= value
            }
        }
    }
    
}


//MARK: PServiceType

extension RecipeService: PServiceType {
    
    static func make(_ r: Resolver) -> RecipeService {
        return RecipeService()
    }
}


