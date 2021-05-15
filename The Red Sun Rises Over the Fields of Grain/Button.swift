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
    var action : (AnyObject?) -> Void
	
    init(imageNamed: String, action: @escaping (AnyObject?) -> ()) {
		self.action = action
		super.init()
		let sprite = SKSpriteNode(imageNamed: imageNamed)
        sprite.name = "sprite"
		self.addChild(sprite)
		
		let label = SKLabelNode(fontNamed: "FreePixel-Regular")
		label.verticalAlignmentMode = .Center
		label.name = "label"
		self.addChild(label)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func onTouchDownInside(touch: UITouch, sender: AnyObject?) {
		if self.enabled {
			action(sender)
		}
	}
    
    func getUnderlyingSprite() -> SKSpriteNode? {
        return self.childNodeWithName("sprite") as? SKSpriteNode
    }
	
	func setTitle(_ text: String) {
		if let label = self.childNodeWithName("label") as? SKLabelNode {
			label.text = text
		}
	}
	
	func getTitle() -> String? {
		if let label = self.childNodeWithName("label") as? SKLabelNode {
			return label.text
		}
		return nil
	}
	
}
