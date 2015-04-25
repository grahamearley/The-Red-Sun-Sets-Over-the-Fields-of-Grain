//
//  MurderScene.swift
//  The Red Sun Rises Over the Fields of Grain
//
//  Created by Charlie Imhoff on 4/24/15.
//  Copyright (c) 2015 Silo Games. All rights reserved.
//

import SpriteKit

class MurderScene: SKScene {
    
    var moments = [SKNode]()

    //Init Scene here
    override init(size: CGSize) {
        super.init(size: size)
        
        let houseInTheDistanceMoment = self.getHouseInTheDistanceMoment(size)
        self.addChild(houseInTheDistanceMoment)
        moments.append(houseInTheDistanceMoment)
        
        let houseUpCloseMoment = self.getHouseUpCloseMoment(size)
        moments.append(houseUpCloseMoment)
        
        let windowMoment = self.getWindowMoment(size)
        moments.append(windowMoment)
        
        let pitchforkGrabMoment = self.getPitchforkGrabMoment(size)
        moments.append(pitchforkGrabMoment)
        
        let doorClosedMoment = self.getDoorClosedMoment(size)
        moments.append(doorClosedMoment)
        
        let doorOpenMoment = self.getDoorOpenMoment(size)
        moments.append(doorOpenMoment)

        
    }
    
    
    // MARK: Moments (not quite scenes!)
    func getHouseInTheDistanceMoment(parentSize: CGSize) -> SKNode {
        let houseInTheDistanceMoment = SKNode()
        
        let background = SKSpriteNode(imageNamed: "BackgroundNight")
        background.position = CGPoint(x: parentSize.width/2, y:parentSize.height/2)
        background.size.height = parentSize.height
        houseInTheDistanceMoment.addChild(background)
        
        let ground = SKSpriteNode(imageNamed: "GroundNight")
        ground.size = CGSize(width: parentSize.width * 2, height: 300)
        ground.position = CGPoint(x: parentSize.width/2, y: 0)
        
        let house = SKSpriteNode(imageNamed: "House")
        house.name = "distant house"
        house.setScale(3)
        house.position = CGPoint(x: parentSize.width - 20, y: ground.size.height/2)
        
        house.runAction(self.getBlinkAction())
        
        houseInTheDistanceMoment.addChild(ground)
        houseInTheDistanceMoment.addChild(house)
        
        return houseInTheDistanceMoment
    }
    
    func getBlinkAction(color: SKColor = SKColor.grayColor()) -> SKAction {
        let colorize = SKAction.colorizeWithColor(color, colorBlendFactor: 0.5, duration: 0.6)
        let colorizeReturn = SKAction.colorizeWithColorBlendFactor(0.0, duration: 0.6)
        let blink = SKAction.repeatActionForever(SKAction.sequence([colorize, colorizeReturn]))
        
        return blink
    }
    
    func getHouseUpCloseMoment(parentSize: CGSize) -> SKNode {
        let houseUpCloseMoment = SKNode()
        
        let background = SKSpriteNode(imageNamed: "BackgroundNight")
        background.position = CGPoint(x: parentSize.width/2, y:parentSize.height/2)
        background.size.height = parentSize.height
        background.size.width = parentSize.width * 2
        houseUpCloseMoment.addChild(background)
        
        let ground = SKSpriteNode(imageNamed: "GroundNight")
        ground.size = CGSize(width: parentSize.width, height: 250)
        ground.position = CGPoint(x: parentSize.width/2, y: 125)
        
        let house = SKSpriteNode(imageNamed: "House")
        house.name = "closer house"
        house.setScale(4)
        house.position = CGPoint(x: parentSize.width/2, y: ground.size.height)
        
        house.runAction(self.getBlinkAction())
        
        houseUpCloseMoment.addChild(ground)
        houseUpCloseMoment.addChild(house)
        
        return houseUpCloseMoment
    }
    
    func getWindowMoment(parentSize: CGSize) -> SKNode {
        let windowMoment = SKNode()
        windowMoment.name = "window moment"
        
        let backdrop = SKSpriteNode(imageNamed: "WindowView")
        backdrop.position = CGPoint(x: parentSize.width/2, y:parentSize.height/2)
        backdrop.size = CGSize(width: parentSize.width, height: parentSize.height)
        
        windowMoment.addChild(backdrop)
        
        let bed = SKSpriteNode(imageNamed: "Bed")
        bed.name = "bed"
        bed.setScale(4)
        bed.position = CGPoint(x: parentSize.width/2 - 10, y:parentSize.height/2)
        
        let bedPosition1 = bed.position
        let bedPosition2 = CGPoint(x: parentSize.width/2 - 20, y:parentSize.height/2)
        
        let moveToPosition2 = SKAction.moveTo(bedPosition2, duration: 0.1)
        let waitABit = SKAction.waitForDuration(1)
        let moveToPosition1 = SKAction.moveTo(bedPosition1, duration: 0.1)
        let bedVibrate = SKAction.repeatActionForever(SKAction.sequence([moveToPosition2, waitABit, moveToPosition1, waitABit]))

        bed.runAction(bedVibrate)
        
        windowMoment.addChild(bed)
        
        return windowMoment
    }
    
    func getPitchforkGrabMoment(parentSize: CGSize) -> SKNode {
        let pitchforkGrabMoment = SKNode()
        
        let background = SKSpriteNode(imageNamed: "GroundNight")
        background.position = CGPoint(x: parentSize.width/2, y:parentSize.height/2)
        background.size.height = parentSize.height * 3
        background.size.width = parentSize.width * 3
        background.runAction(self.getBlinkAction(color: SKColor.redColor()))
        pitchforkGrabMoment.addChild(background)
        
        let pitchfork = SKSpriteNode(imageNamed: "Pitchfork")
        pitchfork.name = "pitchfork"
        pitchfork.position = CGPoint(x: parentSize.width/2, y:parentSize.height/2)
        pitchfork.setScale(7)
        pitchforkGrabMoment.addChild(pitchfork)
        
        let 💪 = SKSpriteNode(imageNamed: "Reachingarm") // EMOJI VARIABLE YO! (for the burly arm that grabs the pitchfork)
        💪.position = CGPoint(x: -25, y: -25)
        💪.name = "burly arm"
        💪.setScale(4)
        pitchforkGrabMoment.addChild(💪)
        
        return pitchforkGrabMoment
        
    }
    
    func grabPitchfork() {
        let 💪 = self.childNodeWithName("//burly arm")
        let pitchfork = self.childNodeWithName("//pitchfork")
        
        let destinationPoint = pitchfork!.position
        let initialPoint = 💪!.position
        
        let moveTo = SKAction.moveTo(destinationPoint, duration: 1.0)
        💪!.runAction(moveTo) {
            //on completion:
            let moveBack = SKAction.moveTo(initialPoint, duration: 0.75)
            💪!.runAction(moveBack)
            pitchfork!.runAction(moveBack)
        }
        
    }
    
    func getDoorClosedMoment(parentSize: CGSize) -> SKNode {
        let doorClosedMoment = SKNode()
        doorClosedMoment.name = "door closed"
        
        let backdrop = SKSpriteNode(imageNamed: "DoorClosed")
        backdrop.position = CGPoint(x: parentSize.width/2, y:parentSize.height/2)
        backdrop.size = CGSize(width: parentSize.width, height: parentSize.height)
        
        doorClosedMoment.addChild(backdrop)
        
        return doorClosedMoment
    }

    
    func getDoorOpenMoment(parentSize: CGSize) -> SKNode {
        let doorOpenMoment = SKNode()
        doorOpenMoment.name = "door open"
        
        let backdrop = SKSpriteNode(imageNamed: "DoorOpen")
        backdrop.position = CGPoint(x: parentSize.width/2, y:parentSize.height/2)
        backdrop.size = CGSize(width: parentSize.width, height: parentSize.height)
        
        doorOpenMoment.addChild(backdrop)
        
        return doorOpenMoment
    }
    
    func getStabMoment(parentSize: CGSize) -> SKNode {
        let stabMoment = SKNode()
        stabMoment.name = "stab moment"
        
        let fear = SKSpriteNode(imageNamed: "Fear")
        fear.name = "fear"
        fear.position = CGPoint(x: parentSize.width/2, y:parentSize.height/2)
        fear.size = CGSize(width: parentSize.width, height: parentSize.height)
        
        let ouch = SKSpriteNode(imageNamed: "Stabbing")
        ouch.name = "ouch"
        ouch.position = CGPoint(x: parentSize.width/2, y:parentSize.height/2)
        ouch.size = CGSize(width: parentSize.width, height: parentSize.height)
        
        ouch.hidden = true // dont show the blood quite yet, know wat i mean?
        
        stabMoment.addChild(fear)
        stabMoment.addChild(ouch)
        
        let pitchfork = SKSpriteNode(imageNamed: "PitchforkForward")
        pitchfork.position = CGPoint(x: parentSize.width/2, y:parentSize.height/2)
        pitchfork.name = "stabbing pitchfork"
        
        return stabMoment
    }
    
    func stab() {
        let fear = self.childNodeWithName("//fear")
        let ouch = self.childNodeWithName("//ouch")
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //touches
        for touch in touches {
            let location = (touch as! UITouch).locationInNode(self)
            if (self.nodeAtPoint(location).name == "distant house") {
                moments[0].runAction(SKAction.fadeOutWithDuration(1))
                self.addChild(moments[1])
                moments[1].alpha = 0.0
                moments[1].runAction(SKAction.fadeInWithDuration(1))
                moments.removeAtIndex(0)
            }
            
            else if (self.nodeAtPoint(location).name == "closer house") {
                moments[0].runAction(SKAction.fadeOutWithDuration(1))
                self.addChild(moments[1])
                moments[1].alpha = 0.0
                moments[1].runAction(SKAction.fadeInWithDuration(1))
                moments.removeAtIndex(0)
            }
            
            else if (moments[0].name == "window moment" || self.nodeAtPoint(location).name == "bed") {
                moments[0].runAction(SKAction.fadeOutWithDuration(1))
                self.addChild(moments[1])
                moments[1].alpha = 0.0
                moments[1].runAction(SKAction.fadeInWithDuration(1))
                moments.removeAtIndex(0)
            }
            
            else if (self.nodeAtPoint(location).name == "pitchfork") {
                self.grabPitchfork()
                
                self.runAction(SKAction.waitForDuration(2)) {
                    self.moments[0].runAction(SKAction.fadeOutWithDuration(1))
                    self.addChild(self.moments[1])
                    self.moments[1].alpha = 0.0
                    self.moments[1].runAction(SKAction.fadeInWithDuration(1))
                    self.moments.removeAtIndex(0)
                }
            }
            
            else if (moments[0].name == "door closed") {
                moments[0].runAction(SKAction.fadeOutWithDuration(1))
                self.addChild(moments[1])
                moments[1].alpha = 0.0
                moments[1].runAction(SKAction.fadeInWithDuration(1))
                moments.removeAtIndex(0)
            }
            
            else if (moments[0].name == "door open") {
                moments[0].runAction(SKAction.fadeOutWithDuration(1))
                self.addChild(moments[1])
                moments[1].alpha = 0.0
                moments[1].runAction(SKAction.fadeInWithDuration(1))
                moments.removeAtIndex(0)
            }
            
            else if (moments[0].name == "stab moment") {
                var stabCount = 0
//                while stabCount < 5 {
//                    stab()
//                    stabCount += 1
//                }
            }
            
        }
    }

	
}
