//
//  GameProfile.swift
//  The Red Sun Rises Over the Fields of Grain
//
//  Created by David Pickart on 4/24/15.
//  Copyright (c) 2015 Silo Games. All rights reserved.
//

import Foundation
import SpriteKit

private let _GameProfileSharedInstance = GameProfile()

class GameProfile {
    
    // Singleton bizness
    class var sharedInstance: GameProfile {
        return _GameProfileSharedInstance
    }
    
    var committedMurder : Bool
    var turn : Int
    var money : Int
    var ghostPoints : Int
    var soundOn : Bool
    var plots : [Plot]
    
    var gameSettings : GameSettings
    
    init() {
        gameSettings = GameSettings.sharedInstance
        committedMurder = false
        turn = 0
        money = gameSettings.startingMoney
        ghostPoints = 0
        soundOn = true
		plots = gameSettings.startingPlots()
		loadDataFromFile()
    }
	
	func clearAllData() {
		committedMurder = false
		turn = 0
		money = gameSettings.startingMoney
		ghostPoints = 0
		soundOn = true
		plots = gameSettings.startingPlots()
	}
	
    func saveToFile() {
        
        let playerData = NSMutableDictionary()
        
        playerData.setValue(committedMurder, forKey: "committed murder")
        playerData.setValue(turn, forKey: "turn")
        playerData.setValue(money, forKey: "money")
        playerData.setValue(ghostPoints, forKey: "ghost points")
        playerData.setValue(soundOn, forKey: "sound on")
        
        var plotDictArray = [[String:AnyObject]]()
        
        for plot in plots {
            let plotDict = plot.toDictionary()
            plotDictArray.append(plotDict)
        }
        
        playerData.setValue(plotDictArray, forKey: "plots")
        
        if let url = GameProfile.getPlayerFileURL() {
            playerData.write(to: url as URL, atomically: true)
        }
    }
    
    func loadDataFromFile() {
        
        if let url = GameProfile.getPlayerFileURL() {
            if let loadedPlayerData = NSMutableDictionary(contentsOf: url as URL) {
                
                if let newCommittedMurder = loadedPlayerData.value(forKey: "committed murder") as? Bool {
                    committedMurder = newCommittedMurder
                }
                
                if let newTurn = loadedPlayerData.value(forKey: "turn") as? Int {
                    turn = newTurn
                }
                
                if let newMoney = loadedPlayerData.value(forKey: "money") as? Int {
                    money = newMoney
                }
                
                if let newGhostPoints = loadedPlayerData.value(forKey: "ghost points") as? Int {
                    ghostPoints = newGhostPoints
                }
                
                if let newSoundOn = loadedPlayerData.value(forKey: "sound on") as? Bool {
                    soundOn = newSoundOn
                }
                
                
                if let plotDictArray = loadedPlayerData.value(forKey: "plots") as? [[String:AnyObject]]
                {
                    var newPlots = [Plot]()
                    for plotDict in plotDictArray {
                        let newPlot = Plot.fromDictionary(plotDict)
                        newPlots.append(newPlot)
                    }
                    
                    plots = newPlots
                }
            }
        }
    }
    
    ///Returns the URL for the .txt file which holds the players data. Stolen from Charlie Imhoff.
    private class func getPlayerFileURL() -> NSURL? {
        let fileName = "RedSunProfileData.plist"
        let directories = FileManager.default.urls(for: FileManager.SearchPathDirectory.libraryDirectory, in: FileManager.SearchPathDomainMask.allDomainsMask)
        let selectedDirectory = directories[0] as NSURL
        let filePath = selectedDirectory.appendingPathComponent(fileName)
        return filePath as NSURL?
    }
    
}
