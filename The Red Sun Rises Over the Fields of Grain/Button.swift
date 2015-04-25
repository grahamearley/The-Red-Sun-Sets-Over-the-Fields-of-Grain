//
//  Button.swift
//  The Red Sun Rises Over the Fields of Grain
//
//  Created by Charlie Imhoff on 4/24/15.
//  Copyright (c) 2015 Silo Games. All rights reserved.
//

import Foundation
import SpriteKit

///Defines a button with a spirte image and associates a response action to it
class Button: SKNode, Touchable {
	
	var enabled : Bool = true
	var action : Void -> Void
	
	init(imageNamed: String, action: () -> ()) {
		self.action = action
		super.init()
		let sprite = SKSpriteNode(imageNamed: imageNamed)
		self.addChild(sprite)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func onTouchDownInside(touch: UITouch, sender: AnyObject) {
		if self.enabled {
			action()
		}
	}
	
}