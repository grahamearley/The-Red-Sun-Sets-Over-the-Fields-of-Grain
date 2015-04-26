//
//  GameSettings.swift
//  The Red Sun Rises Over the Fields of Grain
//
//  Created by David Pickart on 4/25/15.
//  Copyright (c) 2015 Silo Games. All rights reserved.
//

import Foundation
import SpriteKit

private let _GameSettingsSharedInstance = GameSettings()

class GameSettings {
    
    let lifespan : Int = 100
    
    // Starting conditions
    let startingMoney : Int = 25
    let startingPlots : [Plot] = [Plot(contents: .House, index: 0), Plot(contents: .Empty, index: 1),Plot(contents: .Empty, index: 2), Plot(contents: .Tractor, index: 3)]
    
    
    // Button titles
    let harvestButtonTitle : String = "Harvest"
    let removeButtonTitle : String = "Remove"
    let plantButtonTitle : String = "Plant"
    let houseButtonTitle : String = "Sleep"
    let tractorButtonTitle : String = "Expand"
    
    // Plant info
    let cornInfo : [String: AnyObject] = ["growAge": 3, "dieAge": 7, "baseYield": 5, "amount": 6, "cost": 3, "assetName": "Corn", "storeAssetName": "CornBag"]
    let carrotInfo : [String: AnyObject] = ["growAge": 2, "dieAge": 3, "baseYield": 3, "amount": 2, "cost": 1, "assetName": "Carrot", "storeAssetName": "CarrotBag"]
    let wheatInfo : [String: AnyObject] = ["growAge": 3, "dieAge": 8, "baseYield": 7, "amount": 10, "cost": 5, "assetName": "Wheat", "storeAssetName": "WheatBag"]
    let pumpkinInfo : [String: AnyObject] = ["growAge": 5, "dieAge": 9, "baseYield": 12, "amount": 1, "cost": 8, "assetName": "Pumpkin", "storeAssetName": "PumpkinBag"]
    
    
    // Singleton bizness
    class var sharedInstance: GameSettings {
        return _GameSettingsSharedInstance
    }
    
    
}