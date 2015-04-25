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
	
	var currentPlotIndex : Int = 0
	var profile : GameProfile
	
	//Init Scene here
	override init(size: CGSize) {
		profile = GameProfile.sharedInstance
		profile.clearAllData()
		
		super.init(size: size)
		
		let spaceSize = CGSize(width: size.width-100, height: size.height)
		
		//test
		let plot1 = Plot(contents: .House, index: 0)
		let plot2 = Plot(contents: .Empty, index: 1)
		let plot3 = Plot(contents: .Corn, index: 2)
		
		profile.plots.append(plot1)
		profile.plots.append(plot2)
		profile.plots.append(plot3)
		profile.saveToFile()
		
		var currentXPos : CGFloat = size.width/2
		for plot in profile.plots {
			let space = PanNode(size: spaceSize)
			
			space.position = CGPoint(x: currentXPos, y: size.height/2)
			currentXPos += spaceSize.width
			space.addChild(plot)
			plot.initializeNodeContents(spaceSize)
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
		background.position = CGPoint(x: size.width/2, y: size.height/2)
		background.zPosition = -10
		background.size = CGSize(width: background.size.width, height: size.height)
		self.addChild(background)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//Create Gesture Recognizers Here
	override func didMoveToView(view: SKView) {
		let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "didSwipeLeft")
		swipeLeftGestureRecognizer.direction = .Left
		self.view?.addGestureRecognizer(swipeLeftGestureRecognizer)
		
		let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "didSwipeRight")
		swipeRightGestureRecognizer.direction = .Right
		self.view?.addGestureRecognizer(swipeRightGestureRecognizer)
	}
	
	//Remove Gesture Recognizers
	override func willMoveFromView(view: SKView) {
		self.view?.gestureRecognizers?.removeAll(keepCapacity: false)
	}
	
	///On Swipes left, find all PanNodes and shift them left
	func didSwipeLeft() {
		if currentPlotIndex < profile.plots.count-1 {
			currentPlotIndex++
			for child in self.children {
				if let panningNode = child as? PanNode {
					panningNode.shiftLeft()
				}
			}
		}
	}
	
	///On Swipes right, find all PanNodes and shift them right
	func didSwipeRight() {
		if currentPlotIndex > 0 {
			currentPlotIndex--
			for child in self.children {
				if let panningNode = child as? PanNode {
					panningNode.shiftRight()
				}
			}
		}
	}
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for thing: AnyObject in touches {
            if let touch = thing as? UITouch {
                let touchLocation = touch.locationInNode(self)
				for touched in self.nodesAtPoint(touchLocation) {
					if let responder = touched as? Touchable {
						responder.onTouchDownInside?(touch, sender: self)
					}
				}
            }
        }
    }
	
	func ageByTurn(amount: Int = 1) {
		for plot in profile.plots {
			plot.age += amount
			profile.saveToFile()
			plot.updateNodeContent()
		}
	}
	
    override func update(currentTime: CFTimeInterval) {
		//called every 60 seconds
    }
}
