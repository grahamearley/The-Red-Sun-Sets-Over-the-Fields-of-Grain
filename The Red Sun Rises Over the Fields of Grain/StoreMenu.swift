//
//  StoreMenu.swift
//  The Red Sun Rises Over the Fields of Grain
//
//  Created by Charlie Imhoff on 4/25/15.
//  Copyright (c) 2015 Silo Games. All rights reserved.
//

import Foundation
import SpriteKit

class StoreMenu: SKNode, Touchable {
	
	var pages : [StorePage]
	var onPageIndex : Int = 0
	
	init(pages:[StorePage], size: CGSize) {
		self.pages = pages
		super.init()
		
		self.name = "storeMenu"
		
		let backing = SKSpriteNode(imageNamed: "MenuBase")
		backing.size = size
		backing.zPosition = -2
		backing.name = "menuBacking"
		self.addChild(backing)
		
		for i in 0..<pages.count {
			if i == 0 {
				pages[i].alpha = 1
				pages[i].setEnabledForAllButtons(true)
			} else {
				pages[i].alpha = 0
				pages[i].setEnabledForAllButtons(false)
			}
			self.addChild(pages[i])
		}
		
		let plantButton = Button(imageNamed: "Spaceship") { (sender: AnyObject?) -> Void in
			//onAction:
			self.onPageIndex = 0
			self.updateDisplayedPage()
			return
		}
		let tabButtonSize = CGSize(width: size.width/5, height: size.height/5)
		plantButton.getUnderlyingSprite()?.size = tabButtonSize
		plantButton.position = CGPoint(x: -tabButtonSize.width * 0.75, y: -size.height/2 + 40)
		
		let buildingButton = Button(imageNamed: "Spaceship") { (sender: AnyObject?) -> Void in
			//onAction:
			self.onPageIndex = 1
			self.updateDisplayedPage()
			return
		}
		buildingButton.getUnderlyingSprite()?.size = tabButtonSize
		buildingButton.position = CGPoint(x: tabButtonSize.width * 0.75, y: -size.height/2 + 40)
		
		self.addChild(plantButton)
		self.addChild(buildingButton)
		
		let ex = Button(imageNamed: "TheEx") { (sender:AnyObject?) -> Void in
			//onAction:
			// reset locking
			if let farmScene = sender as? FarmScene {
				farmScene.setStoreLocks(false)
			}
		}
		ex.getUnderlyingSprite()?.setScale(2)
		ex.position = CGPoint(x: size.width/2, y: size.height/2)
		self.addChild(ex)
	}
	
	func updateDisplayedPage() {
		for i in 0..<pages.count {
			if i == onPageIndex {
				pages[i].setEnabledForAllButtons(true)
				pages[i].alpha = 1
			} else {
				pages[i].setEnabledForAllButtons(false)
				pages[i].alpha = 0
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
}

class StorePage: SKNode, Touchable {
	
	var buttons: [Button]
	
	///Please keep buttons list to <= 6, or else the page will run off margin
	init(buttons: [Button], size: CGSize) {
		self.buttons = buttons
		
		super.init()
		
		let padding : CGFloat = 75
		let margin : CGFloat = 50
		
		let buttonSize = buttons[0].getUnderlyingSprite()!.size
		var evenXPos : CGFloat = -buttonSize.width * 0.75
		var oddXPos : CGFloat = buttonSize.width * 0.75
		var onYPos : CGFloat = (size.height/2) - padding
		
		for i in 0..<buttons.count {
			let butt = buttons[i]
			
			if i%2 == 0 {
				//even : thus move on row to right
				butt.position = CGPoint(x: evenXPos, y: onYPos)
			} else {
				//odd : thus move down and back
				butt.position = CGPoint(x: oddXPos, y: onYPos)
				onYPos -= margin + butt.getUnderlyingSprite()!.size.height
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
		imageSprite?.setScale(4)
		
		//override and remove default label
		if let label = self.childNodeWithName("label") {
			label.removeFromParent()
		}
		
		let costLabel = SKLabelNode(fontNamed: "FreePixel-Regular")
		costLabel.fontColor = SKColor.blackColor()
		costLabel.text = "$\(cost)"
		let yPos : CGFloat = -(imageSprite?.size.height ?? 30.0)*0.85
		costLabel.position = CGPoint(x: 0, y: yPos)
		
		let timeLabel = SKLabelNode(fontNamed: "FreePixel-Regular")
		timeLabel.fontColor = SKColor.blackColor()
		timeLabel.text = "\(time)t"
		timeLabel.position = CGPoint(x: 0, y: costLabel.position.y - 25.0)
		
		self.addChild(costLabel)
		self.addChild(timeLabel)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
}
