//
//  Plot.swift
//  The Red Sun Rises Over the Fields of Grain
//
//  Created by Charlie Imhoff on 4/25/15.
//  Copyright (c) 2015 Silo Games. All rights reserved.
//

import Foundation
import SpriteKit

///Enum for all possible contents of a plot
enum PlotContent : String {
	case Empty = "Empty"
	
	case Corn = "Corn"
	case Wheat = "Wheat"
	
	case Windmill = "Windmill"
	
	case DeadBody = "DeadBody"
	
	case House = "House"	//max left
	case Tractor = "Tractor"	//max right
}

///Holds plots content, and an age for it
class Plot: SKNode, Touchable {
	
	var contents : PlotContent = .Empty
	var age : Int = 0
	var size : CGSize!
	var index : Int
//    var profile : GameProfile
	
	var fieldNodes = [SKNode]()
	
	init(contents: PlotContent, index: Int) {
//        profile = GameProfile.sharedInstance
		self.contents = contents
		self.index = index
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Plot Interaction
	
	func initializeNodeContents(size: CGSize) {
		self.size = size
		
		//add ground
		let ground = SKSpriteNode(imageNamed: "Ground")
		ground.size.width = size.width
		ground.size.height = size.height/5
		ground.position = CGPoint(x: 0, y: (-size.height/2)+ground.size.height/2)
		self.addChild(ground)
		
		//button
		let button = Button(imageNamed: "Redbutton") { (sender:AnyObject?) -> () in return}
		var buttonMargin : CGFloat = 10
		if let buttonSprite = button.getUnderlyingSprite() {
			buttonMargin = buttonSprite.size.height/2 + 50
			buttonSprite.size = CGSize(width: (size.width * 0.8), height: (size.height * 0.1))
		}
		button.position = CGPoint(x: 0, y: (-size.height/2)+buttonMargin)
		button.name = "button"
		self.addChild(button)
		
		updateNodeContent()

	}
	
	///Replaces the current contents of the plot with a updated content.
	///Must be called after changing self.contents to reflect that
	func updateNodeContent() {
		
		//remove old plants
		for fieldItem in fieldNodes {
			fieldItem.removeFromParent()
		}
		
		//plants
		var colorNode = SKShapeNode(rectOfSize: CGSize(width: size.width/4, height: size.height/4))
		colorNode.position = CGPoint(x: 0, y: -size.height/4)
		colorNode.strokeColor = SKColor.clearColor()
		let color : SKColor
		
		switch self.contents {
		case .DeadBody:
			color = SKColor.brownColor()
		case .Empty:
			color = SKColor.clearColor()
		case .Corn:
			color = SKColor.yellowColor()
		case .House:
			color = SKColor.redColor()
		case .Tractor:
			let hull = SKSpriteNode(imageNamed: "TractorBody")
			hull.name = "hull"
			hull.size = CGSize(width: self.size.width, height: self.size.height/2)
			hull.position = CGPoint(x: self.size.width/4, y: 0)
			self.addChild(hull)
			
			let wheel = SKSpriteNode(imageNamed: "TractorWheel")
			wheel.position = CGPoint(x: 0, y: -self.size.height/5)
			wheel.setScale(5)
			wheel.name = "wheel"
			self.addChild(wheel)
			
			self.fieldNodes.append(hull)
			self.fieldNodes.append(wheel)
			
			color = SKColor.clearColor()
		case .Wheat:
			color = SKColor.greenColor()
		case .Windmill:
			color = SKColor.grayColor()
		}
		
		colorNode.name = "field"
		colorNode.fillColor = color
		
		self.addChild(colorNode)
		
		//update button
		if let button = self.childNodeWithName("button") as? Button {
			let buttonInfo = self.getButtonActionForCurrentPlot()
			button.setTitle(buttonInfo.0)
			button.action = buttonInfo.1
		}
	}
	
	///Returns the title and action that the current plot's button should display
	private func getButtonActionForCurrentPlot() -> (String, AnyObject?->()) {
		var buttonTitle : String = ""
		var buttonAction : AnyObject?->Void = {(sender: AnyObject?)->() in return}
		
		if self.contents == .Corn {
			if age >= 3 && age <= 7 {
				//harvestable corn:
				buttonTitle = "Harvest"
				buttonAction = { (sender:AnyObject?) in
					//harvest the corn:
					GameProfile.sharedInstance.money += Int(7 * self.getMultiplier())
					self.contents = .Empty
					self.age = 0
                    self.updateNodeContent()
                    
                    // Gettin money
                    if let farmScene = sender as? FarmScene {
                        farmScene.updateMoney()
                    }
				}
			} else {
				//dead or not grown corn:
				buttonTitle = "Remove"
				buttonAction = { (sender:AnyObject?) in
					//remove the corn:
					self.contents = .Empty
					self.age = 0
                    self.updateNodeContent()
                    
                    // Gettin money
                    if let farmScene = sender as? FarmScene {
                        farmScene.updateMoney()
                    }
				}
			}
		}
		if self.contents == .Empty {
			buttonTitle = "Plant Corn"
			buttonAction = { (sender:AnyObject?) in
				//add some corn:
				self.contents = .Corn
				self.age = 0
                self.updateNodeContent()
                
                // Gettin money
                if let farmScene = sender as? FarmScene {
                    farmScene.updateMoney()
                }
			}
		}
		if self.contents == .House {
			buttonTitle = "Wait"
			buttonAction = { (sender:AnyObject?) in
				//progress the FarmScene (the sender) by one turn:
				if let farmScene = sender as? FarmScene {
					farmScene.ageByTurn(amount: 1)
                    self.updateNodeContent()
				}
			}
		}
		if self.contents == .Tractor {
			buttonTitle = "Expand"
			buttonAction = { (sender:AnyObject?) in
				//expand the farm by one plot, essencially adding another tractor plot
				//and setting this plot to be empty
				if let wheel = self.childNodeWithName("wheel"), hull = self.childNodeWithName("hull") {
					let rotate = SKAction.rotateByAngle(-6.28, duration: 4)
					let move = SKAction.moveByX(self.size.width, y: 0, duration: 4)
					let group = SKAction.group([rotate,move])
					wheel.runAction(group)
					hull.runAction(move) {
						//on completion:
						if let farmScene = sender as? FarmScene {
							GameProfile.sharedInstance.money -= 20
							farmScene.extendFarm()
							self.contents = .Empty
							self.updateNodeContent()
						}
					}
				}
			}
		}
		
		return (buttonTitle, buttonAction)
	}
	
	func getMultiplier() -> Float {
		return 1
	}

	
	func ageContent(byAmount:Int = 1) {
		age += byAmount
	}
		
	//MARK: - Save/Load
	
	func toDictionary() -> [String:AnyObject] {
		var dict = [String:AnyObject]()
		
		dict["contents"] = self.contents.rawValue
		dict["age"] = self.age
		dict["index"] = self.index
		
		return dict
	}
	
	class func fromDictionary(dictionary: [String:AnyObject]) -> Plot {
		var contents : PlotContent = .Empty
		var age = 0
		var index = 0
		
		if let contentValFromDict : String = dictionary["contents"] as? String {
			if let content = PlotContent(rawValue: contentValFromDict) {
				contents = content
			}
		}
		if let ageValFromDict : Int = dictionary["age"] as? Int {
			age = ageValFromDict
		}
		if let indexValFromDict : Int = dictionary["index"] as? Int {
			index = indexValFromDict
		}
		
		let plot = Plot(contents: contents, index: index)
		plot.age = age
		return plot
	}
	
	
}
