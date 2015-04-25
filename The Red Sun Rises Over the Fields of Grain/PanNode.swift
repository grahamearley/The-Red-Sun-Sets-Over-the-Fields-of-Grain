//
//  PanNode.swift
//  The Red Sun Rises Over the Fields of Grain
//
//  Created by Charlie Imhoff on 4/24/15.
//  Copyright (c) 2015 Silo Games. All rights reserved.
//

import Foundation
import SpriteKit

///Container for nodes which need to pan across the scene
class PanNode: SKNode {
	
	let size : CGSize
	
	init(size: CGSize) {
		self.size = size
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	///Shifts the PanNode and all its contents by its entire width over to the left
	func shiftLeft() {
		let destinationPoint = CGPoint(x: self.position.x-size.width, y: self.position.y)
		let moveTo = SKAction.moveTo(destinationPoint, duration: 0.5)
		self.runAction(moveTo)
	}
	
	///Shifts the PanNode and all its contents by its entire width over to the right
	func shiftRight() {
		let destinationPoint = CGPoint(x: self.position.x+size.width, y: self.position.y)
		let moveTo = SKAction.moveTo(destinationPoint, duration: 0.5)
		self.runAction(moveTo)
	}
	
}