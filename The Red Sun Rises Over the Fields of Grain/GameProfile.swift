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
    class var sharedInstance: GameProfile {
        return _GameProfileSharedInstance
    }
    
    var ghostPoints : Int
    var soundOn : Bool
    var plots : [Plot]
    
    init() {
        ghostPoints = 0
        soundOn = false
        plots = [Plot]()
        loadDataFromFile()
    }
    
    func saveToFile() {
        
        var playerData = NSMutableDictionary()

        playerData.setValue(ghostPoints, forKey: "ghost points")
        playerData.setValue(soundOn, forKey: "sound on")
        
        plotDictArray = [NSDictionary]()
        
        for plot in plots {
            plotDict = plot.toDictionary()
            plotDictArray.append(plot)
        }
        
        playerData.setValue(plots, forKey: "plots")
        
        if let url = GameProfile.getPlayerFileURL() {
            playerData.writeToURL(url, atomically: true)
        }
    }
    
    func loadDataFromFile() {
        
        if let url = GameProfile.getPlayerFileURL() {
            if let loadedPlayerData = NSDictionary(contentsOfURL: url) {
                
                if let newGhostPoints = loadedPlayerData.valueForKey("ghost points") as? Int {
                    ghostPoints = newGhostPoints
                }
                
                if let newSoundOn = loadedPlayerData.valueForKey("sound on") as? Bool {
                    soundOn = newSoundOn
                }
                
                
                if let plotDictArray = loadedPlayerData.valueForKey("ghost points") as? [NSDictionary]
                {
                    let newPlots = [Plot]()
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
        let fileName = "slidersProfileData.plist"
        let directories = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.LibraryDirectory, inDomains: NSSearchPathDomainMask.AllDomainsMask)
        if let selectedDirectory = directories[0] as? NSURL {
            let filePath = selectedDirectory.URLByAppendingPathComponent(fileName)
            return filePath
        } else {
            return nil
        }
    }
    
}