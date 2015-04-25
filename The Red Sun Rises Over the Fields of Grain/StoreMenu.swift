//
//  StoreMenu.swift
//  The Red Sun Rises Over the Fields of Grain
//
//  Created by Charlie Imhoff on 4/25/15.
//  Copyright (c) 2015 Silo Games. All rights reserved.
//

import Foundation
import SpriteKit

//class StoreMenu: SKNode, Touchable {
//	
//	var pages = [StorePage]()
//	var onPageIndex : Int
//	
//	override init() {
//		let backing = SKSpriteNode(imageNamed: "menu")
//	}
//
//	required init?(coder aDecoder: NSCoder) {
//	    fatalError("init(coder:) has not been implemented")
//	}
//	
//}

class StorePage: SKNode, Touchable {
	
	var buttons: [Button]
	
	///Please keep buttons list to <= 6, or else the page will run off margin
	init(buttons: [Button], size: CGSize) {
		self.buttons = buttons
		
		super.init()
		
		let padding : CGFloat = 30
		let margin : CGFloat = 20
		
		let topLeftOrigin = CGPoint(x: -(size.width/2) + padding, y: -(size.height/2) + padding)
		var evenXPos : CGFloat = topLeftOrigin.x
		var oddXPos : CGFloat = topLeftOrigin.x + margin + (buttons[0].getUnderlyingSprite()?.size.width ?? 60)
		var onYPos : CGFloat = topLeftOrigin.y
		
		for i in 0..<buttons.count {
			let butt = buttons[i]
			
			if i%2 == 0 {
				//even : thus move on row to right
				butt.position = CGPoint(x: evenXPos, y: onYPos)
			} else {
				//odd : thus move down and back
				butt.position = CGPoint(x: oddXPos, y: onYPos)
				onYPos += margin + butt.getUnderlyingSprite()!.size.height
			}
			
			self.addChild(butt)
		}
	}
	
	func setEnabledForAllButtons(setting:Bool) {
		for butt in buttons {
			butt.enabled = setting
		}
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
}

class StoreItem: Button {
	
	let cost : Int
	let time : Int
	
	init(imageNamed: String, cost: Int, time: Int, action: AnyObject? -> ()) {
		self.cost = cost
		self.time = time
		
		super.init(imageNamed: imageNamed, action: action)
		
		let imageSprite = getUnderlyingSprite()
		imageSprite?.setScale(0.5)
		
		//override and remove default label
		if let label = self.childNodeWithName("label") {
			label.removeFromParent()
		}
		
		let costLabel = SKLabelNode(fontNamed: "FreePixel-Regular")
		costLabel.text = "$\(cost)"
		let yPos : CGFloat = -(imageSprite?.size.height ?? 30.0)
		costLabel.position = CGPoint(x: 0, y: yPos)
		
		let timeLabel = SKLabelNode(fontNamed: "FreePixel-Regular")
		timeLabel.text = "\(time)t"
		timeLabel.position = CGPoint(x: 0, y: costLabel.position.y - 30.0)
		
		self.addChild(costLabel)
		self.addChild(timeLabel)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
}
