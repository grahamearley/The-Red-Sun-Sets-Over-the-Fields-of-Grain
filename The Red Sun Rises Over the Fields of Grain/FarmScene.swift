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
		
		let space1 = PanNode(size: CGSize(width: plotWidth, height: size.height))
		let space2 = PanNode(size: CGSize(width: plotWidth, height: size.height))
		let space3 = PanNode(size: CGSize(width: plotWidth, height: size.height))
		let space4 = PanNode(size: CGSize(width: plotWidth, height: size.height))
		
		let plot1 = Plot(contents: .Empty)
		let plot2 = Plot(contents: .Corn)
		let plot3 = Plot(contents: .Windmill)
		
		space1.addChild(plot1)
		space2.addChild(plot2)
		space3.addChild(plot3)
		
		plot1.updateNodeContent(space1.size)
		plot2.updateNodeContent(space2.size)
		plot3.updateNodeContent(space3.size)
		
		space1.position = CGPoint(x: size.width/2, y: size.height/2)
		space2.position = CGPoint(x: space1.position.x + plotWidth, y: size.height/2)
		space3.position = CGPoint(x: space2.position.x + plotWidth, y: size.height/2)
		space4.position = CGPoint(x: space3.position.x + plotWidth, y: size.height/2)
		
		self.addChild(space1)
		self.addChild(space2)
		self.addChild(space3)
		self.addChild(space4)
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
