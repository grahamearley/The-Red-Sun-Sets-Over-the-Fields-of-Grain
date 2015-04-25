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
		
		let plotWidth = size.width-20
        
        let gameProfile = GameProfile.sharedInstance
        
        gameProfile.saveToFile()
		
		let space1 = PanNode(size: CGSize(width: plotWidth, height: size.height))
		let space2 = PanNode(size: CGSize(width: plotWidth, height: size.height))
		let block = SKShapeNode(circleOfRadius: 30)
		block.fillColor = SKColor.redColor()
		space1.addChild(block)
		
		let block2 = SKShapeNode(circleOfRadius: 30)
		block2.fillColor = SKColor.yellowColor()
		space2.addChild(block2)
		
		space1.position = CGPoint(x: size.width/2, y: size.height/2)
		space2.position = CGPoint(x: space1.position.x + plotWidth, y: size.height/2)
		
		self.addChild(space1)
		self.addChild(space2)
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
