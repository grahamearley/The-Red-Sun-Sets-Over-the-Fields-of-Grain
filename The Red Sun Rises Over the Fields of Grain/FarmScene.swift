//
//  FarmScene.swift
//  The Red Sun Rises Over the Fields of Grain
//
//  Created by Graham Earley on 4/24/15.
//  Copyright (c) 2015 Silo Games. All rights reserved.
//

import UIKit
import SpriteKit

class FarmScene: SKScene {
	
	var screenSize : CGSize
	var spaceSize : CGSize
	
	var currentPlotIndex : Int = 0
	var profile : GameProfile
    var gameSettings : GameSettings
	
	var scrollLock : Bool
	
	//Init Scene here
	override init(size: CGSize) {
		self.screenSize = size
		self.spaceSize = CGSize(width: size.width-100, height: size.height)
		
		self.scrollLock = true
		
		profile = GameProfile.sharedInstance
        gameSettings = GameSettings.sharedInstance
		
		super.init(size: size)
		
		var currentXPos : CGFloat = size.width/2
        
		for plot in profile.plots {
			let space = PanNode(size: spaceSize)
			
			space.position = CGPoint(x: currentXPos, y: size.height/2)
			currentXPos += spaceSize.width
			space.addChild(plot)
            plot.initializeNodeContents(size: spaceSize)
			self.addChild(space)
		}
		
        // Static ground for edges
		let leftGround = SKSpriteNode(imageNamed: "Ground")
		leftGround.size.width = spaceSize.width
		leftGround.size.height = size.height/5
		leftGround.position = CGPoint(x: (size.width/2)-spaceSize.width/2, y: leftGround.size.height/2)
		leftGround.zPosition = -9
		self.addChild(leftGround)
		let rightGround = SKSpriteNode(imageNamed: "Ground")
		rightGround.size.width = spaceSize.width
		rightGround.size.height = size.height/5
		rightGround.position = CGPoint(x: (size.width/2)+spaceSize.width/2, y: rightGround.size.height/2)
		rightGround.zPosition = -9
		self.addChild(rightGround)
		
        // Sky
		let background = SKSpriteNode(imageNamed: "Background")
		background.size = CGSize(width: background.size.width*2, height: size.height)
		background.position = CGPoint(x: background.size.width/2, y: size.height/2)
		background.zPosition = -10
        background.name = "Background"
		self.addChild(background)
        
        // Status bar background
        let statusBar = SKSpriteNode(imageNamed: "TopBar")
        statusBar.setScale(2)
        statusBar.size.width += 75
        statusBar.position = CGPoint(x: self.size.width - statusBar.size.width/2 - 10, y: self.size.height - 30)
        self.addChild(statusBar)
        
        // coin icon
        let coinIcon = SKSpriteNode(imageNamed: "CoinCounter")
        coinIcon.position = CGPoint(x: self.size.width - coinIcon.size.width/2 - 60, y: self.size.height - 30)
        self.addChild(coinIcon)
        
        // clock icon
        let clockIcon = SKSpriteNode(imageNamed: "ClockIcon")
        clockIcon.position = CGPoint(x: self.size.width - clockIcon.size.width/2 - 170, y: self.size.height - 30)
        self.addChild(clockIcon)
        
        // time label
        let timeLabel = SKLabelNode(fontNamed: "FreePixel-Regular")
        timeLabel.text = "day \(profile.turn)"
        timeLabel.name = "Time Label"
        timeLabel.fontColor = UIColor.blackColor()
        timeLabel.fontSize = 25
        timeLabel.position = CGPoint(x: size.width - 125, y: size.height - 40)
        self.addChild(timeLabel)
        
        // ghost icon
        let ghostIcon = SKSpriteNode(imageNamed: "Ghost")
        ghostIcon.position = CGPoint(x: self.size.width - ghostIcon.size.width/2 - 230, y: self.size.height - 30)
        self.addChild(ghostIcon)
        
        // ghost label
        let ghostLabel = SKLabelNode(fontNamed: "FreePixel-Regular")
        ghostLabel.text = "\(profile.ghostPoints)"
        ghostLabel.name = "Ghost Label"
        ghostLabel.fontColor = UIColor.blackColor()
        ghostLabel.fontSize = 25
        ghostLabel.position = CGPoint(x: size.width - 215, y: size.height - 40)
        self.addChild(ghostLabel)
        
        // Money label
        let moneyLabel = SKLabelNode(fontNamed: "FreePixel-Regular")
        moneyLabel.text = "\(profile.money)"
        moneyLabel.name = "Money Label"
        moneyLabel.fontColor = UIColor.blackColor()
        moneyLabel.fontSize = 25
        moneyLabel.position = CGPoint(x: size.width - 40, y: size.height - 40)
        self.addChild(moneyLabel)
		
		// Notebook button
		let notebookButton = Button(imageNamed: "InfoBook") { (sender: AnyObject?) -> () in
			//onAction:
			if let alreadyBook = self.childNodeWithName("notebookContents") {
				alreadyBook.removeFromParent()
				return
			}
			let notebookContents = Button(imageNamed: "Recipe") { (sender: AnyObject?) -> () in
				//onAction:
				self.childNodeWithName("notebookContents")?.removeFromParent()
			}
			notebookContents.name = "notebookContents"
			notebookContents.setScale(3.5)
			notebookContents.position = CGPoint(x: size.width/2, y: size.height/2 + 25)
			self.addChild(notebookContents)
		}
		notebookButton.setScale(3)
		notebookButton.position = CGPoint(x: 40, y: size.height - 40)
		self.addChild(notebookButton)
		
		let bigLightNode = SKLightNode()
		bigLightNode.falloff = 0.2
		bigLightNode.lightColor = SKColor.redColor()
		bigLightNode.ambientColor = SKColor.whiteColor()
		bigLightNode.categoryBitMask = 1
		self.enumerateChildNodesWithName("//*", usingBlock: { (node:SKNode, cancel:UnsafeMutablePointer<ObjCBool>) -> Void in
			if let sprite = node as? SKSpriteNode {
				sprite.lightingBitMask = 1
			}
		})
		bigLightNode.position = CGPoint(x: size.width/2, y: size.height * 0.8)
		self.addChild(bigLightNode)
		
		let wait = SKNode()
		self.addChild(wait)
		wait.runAction(SKAction.waitForDuration(0.25)) {	//frame buffer
			self.scrollLock = false
		}
	}
    
    func updateDayCount() {
        let label = self.childNodeWithName("Time Label") as? SKLabelNode
        let count = GameProfile.sharedInstance.turn
		label!.text = "day \(count)"
        label?.zPosition = 99
    }
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var gestures = [UIGestureRecognizer]()
	//Create Gesture Recognizers Here
	override func didMove(to view: SKView) {
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipeLeft))
		swipeLeftGestureRecognizer.direction = .Left
		self.view?.addGestureRecognizer(swipeLeftGestureRecognizer)
		
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipeRight))
		swipeRightGestureRecognizer.direction = .Right
		self.view?.addGestureRecognizer(swipeRightGestureRecognizer)

		gestures.append(swipeLeftGestureRecognizer)
		gestures.append(swipeRightGestureRecognizer)
	}
	
	//Remove Gesture Recognizers
	override func willMove(from view: SKView) {
		for gesture in gestures {
			view.removeGestureRecognizer(gesture)
		}
	}
	
	///On Swipes left, find all PanNodes and shift them left
    @objc func didSwipeLeft() {
		if currentPlotIndex < profile.plots.count-1 && !scrollLock {
			currentPlotIndex++
			profile.plots[currentPlotIndex].lightUpdate()
			for child in self.children {
				if let panningNode = child as? PanNode {
					panningNode.shiftLeft()
				}
			}
            
            shiftBackground()
		}
	}
	
	///On Swipes right, find all PanNodes and shift them right
    @objc func didSwipeRight() {
		if currentPlotIndex > 0 && !scrollLock {
			currentPlotIndex--
			profile.plots[currentPlotIndex].lightUpdate()
			for child in self.children {
				if let panningNode = child as? PanNode {
					panningNode.shiftRight()
				}
			}
            
            shiftBackground()
		}
	}
    
    private func shiftBackground() {
    
        // Move background with parallax black magic
        if let background = self.childNodeWithName("Background") as? SKSpriteNode {
            
            let difference = ((background.size.width) - screenSize.width)
            let width = difference / CGFloat(profile.plots.count)
            let offset = (-1 * width * CGFloat(currentPlotIndex)) + background.size.width / 2
            let destinationPoint = CGPoint(x: offset, y: background.position.y)
            let moveTo = SKAction.moveTo(destinationPoint, duration: 0.175)
            background.runAction(moveTo);
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for thing: AnyObject in touches {
            if let touch = thing as? UITouch {
                let touchLocation = touch.locationInNode(self)
				for touched in self.nodesAtPoint(touchLocation) {
					if let responder = touched as? Touchable {
						responder.onTouchDownInside(touch, sender: self)
					}
				}
            }
        }
    }
    
    func moneyWarning() {
        let moneyLabel = self.childNodeWithName("Money Label") as? SKLabelNode
        
        moneyLabel?.zPosition = 900
        let colorizeYellow = SKAction.runBlock { () -> Void in
            moneyLabel?.fontColor = SKColor.yellowColor()
            return
        }
        
        let colorizeBlack = SKAction.runBlock{ () -> Void in
            moneyLabel?.fontColor = SKColor.blackColor()
            return
        }
        
        let scaleUp = SKAction.scaleTo(1.6, duration: 0.2)
        let scaleDown = SKAction.scaleTo(1, duration: 0.2)
        
        let colorFlash = SKAction.sequence([colorizeYellow, scaleUp, SKAction.waitForDuration(0.2), colorizeBlack, SKAction.waitForDuration(0.2), scaleDown])
        
        moneyLabel!.runAction(colorFlash) {
            moneyLabel!.runAction(colorFlash)
        }
    }
    
    func ghostWarning() {
        let ghostLabel = self.childNodeWithName("Ghost Label") as? SKLabelNode
        
        ghostLabel?.zPosition = 900
        let colorizeYellow = SKAction.runBlock { () -> Void in
            ghostLabel?.fontColor = SKColor.yellowColor()
            return
        }
        
        let colorizeBlack = SKAction.runBlock{ () -> Void in
            ghostLabel?.fontColor = SKColor.blackColor()
            return
        }
        
        let scaleUp = SKAction.scaleTo(1.6, duration: 0.2)
        let scaleDown = SKAction.scaleTo(1, duration: 0.2)
        
        let colorFlash = SKAction.sequence([colorizeYellow, scaleUp, SKAction.waitForDuration(0.2), colorizeBlack, SKAction.waitForDuration(0.2), scaleDown])
        
        ghostLabel!.runAction(colorFlash) {
            ghostLabel!.runAction(colorFlash)
        }
    }
	 
	func ageByTurn(_ amount: Int = 1) {
        profile.turn += amount
		if profile.turn % 5 == 0 {
			profile.money--
		}
		if profile.money < 0 {
			profile.money = 0
		}
		self.updateMoney()
        profile.saveToFile()
        
		let blackover = SKShapeNode(rectOfSize: CGSize(width: screenSize.width, height: screenSize.height + 100))
		blackover.fillColor = SKColor.blackColor()
		blackover.strokeColor = SKColor.clearColor()
		blackover.zPosition = 100
		blackover.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
		blackover.alpha = 0
		self.addChild(blackover)
		blackover.runAction(SKAction.fadeAlphaTo(1, duration: 0.3)) {
			//on blackover covers whole screen:
			for plot in self.profile.plots {
				plot.ageContent(amount)
				plot.updateNodeContent()
			}
			let fadeOut = SKAction.fadeAlphaTo(0, duration: 0.3)
			blackover.runAction(SKAction.sequence([fadeOut,SKAction.removeFromParent()]))
		}
		
		if profile.money <= 0 {
			//check if any plots exist to save you...
			var vegisFound = 0
			for plot in profile.plots {
				if plot.contents == .Corn || plot.contents == .Wheat || plot.contents == .Carrot || plot.contents == .Pumpkin {
					vegisFound++
				}
			}
			if vegisFound <= 1 {
				//you die. sucks to suck
				profile.clearAllData()	//reset all data
				let transition = SKTransition.crossFadeWithDuration(3)
				self.view?.presentScene(DeathScene(size: size, score: 0), transition: transition)
			}
		}
		if profile.turn > gameSettings.lifespan {
			//you die. sucks to suck
			let ghosts = profile.ghostPoints	//preserve ghosts
			let score = profile.money //save money for presenting
			profile.clearAllData()	//reset all data
			profile.ghostPoints = ghosts + 1	//reinstall ghosts and add one for you
            let transition = SKTransition.crossFadeWithDuration(3)
			self.view?.presentScene(DeathScene(size: size, score: score), transition: transition)
			
		}
	}
    
    func updateMoney() {
        if let label = self.childNodeWithName("Money Label") as? SKLabelNode {
            label.text = String(GameProfile.sharedInstance.money)
        }
    }
    
    func updateGhosts() {
        if let label = self.childNodeWithName("Ghost Label") as? SKLabelNode {
            label.text = String(GameProfile.sharedInstance.ghostPoints)
        }
    }
	
	///locks interaction to solely the open store window
	///and also is in charge of unlocking this on store window close
	func setStoreLocks(_ locksOn: Bool) {
		self.scrollLock = locksOn
		
		let currentPlot = GameProfile.sharedInstance.plots[self.currentPlotIndex]
		if let button = currentPlot.childNodeWithName("button") as? Button {
			button.enabled = !locksOn
			button.alpha = locksOn ? 0 : 1
		}
		if let menu = self.childNodeWithName("//storeMenu") {
			if !locksOn {
				menu.removeFromParent()
			}
		}
	}
	
	func extendFarm() {
		let newPlot = Plot(contents: .Tractor, index: profile.plots.count)
		let newSpace = PanNode(size: spaceSize)
		
		let originPos = profile.plots[0].parent!.position
		
		let newXPos = originPos.x + spaceSize.width*CGFloat(newPlot.index)
		newSpace.position = CGPoint(x: newXPos, y: screenSize.height/2)
		newSpace.addChild(newPlot)
        newPlot.initializeNodeContents(size: spaceSize)
		self.addChild(newSpace)
		
		profile.plots.append(newPlot)
		profile.saveToFile()
	}
	
    override func update(_ currentTime: CFTimeInterval) {
		//called every 60 seconds
    }
}
