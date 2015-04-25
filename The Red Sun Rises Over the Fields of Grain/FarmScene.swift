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
		
		let plotWidth = size.width-100
		
		//test
		let plot1 = Plot(contents: .Corn)
		let plot2 = Plot(contents: .Windmill)
		let plot3 = Plot(contents: .DeadBody)
		
		profile.plots.append(plot1)
		profile.plots.append(plot2)
		profile.plots.append(plot3)
		profile.saveToFile()
		
		var currentXPos : CGFloat = size.width/2
		for plot in profile.plots {
			let space = PanNode(size: CGSize(width: plotWidth, height: size.height))
			let spaceSize = space.size
			
			//add ground into spaces
			let ground = SKSpriteNode(imageNamed: "Ground")
			ground.size.width = spaceSize.width
			ground.size.height = spaceSize.height/5
			ground.position = CGPoint(x: 0, y: (-size.height/2)+ground.size.height/2)
			space.addChild(ground)
			
			space.position = CGPoint(x: currentXPos, y: size.height/2)
			currentXPos += spaceSize.width
			space.addChild(plot)
			plot.updateNodeContent(spaceSize)
			self.addChild(space)
		}
		
		let leftGround = SKSpriteNode(imageNamed: "Ground")
		leftGround.size.width = plotWidth
		leftGround.size.height = size.height/5
		leftGround.position = CGPoint(x: (size.width/2)-plotWidth/2, y: leftGround.size.height/2)
		leftGround.zPosition = -9
		self.addChild(leftGround)
		let rightGround = SKSpriteNode(imageNamed: "Ground")
		rightGround.size.width = plotWidth
		rightGround.size.height = size.height/5
		rightGround.position = CGPoint(x: (size.width/2)+plotWidth/2, y: rightGround.size.height/2)
		rightGround.zPosition = -9
		self.addChild(rightGround)
		
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
		//touches
    }
   
    override func update(currentTime: CFTimeInterval) {
		//called every 60 seconds
    }
}
