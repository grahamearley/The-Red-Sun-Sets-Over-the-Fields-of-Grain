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
	
	//Init Scene here
	override init(size: CGSize) {
		super.init(size: size)
		
		let plotWidth = size.width-100
		
		//test
		let plot1 = Plot(contents: .Corn)
		let plot2 = Plot(contents: .Windmill)
		let plot3 = Plot(contents: .DeadBody)
		
		let profile = GameProfile.sharedInstance
		profile.clearAllData()
		println(profile.money)
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
		for child in self.children {
			if let panningNode = child as? PanNode {
				panningNode.shiftLeft()
			}
		}
	}
	
	///On Swipes right, find all PanNodes and shift them right
	func didSwipeRight() {
		for child in self.children {
			if let panningNode = child as? PanNode {
				panningNode.shiftRight()
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
