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
	
	var fieldNodes = [SKNode]()
	
	init(contents: PlotContent, index: Int) {
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
			buttonSprite.size = CGSize(width: (size.width * 0.6), height: (size.height * 0.1))
		}
		button.position = CGPoint(x: 0, y: (-size.height/2)+buttonMargin)
		button.name = "button"
		self.addChild(button)
		
		//multiplier text
		let label = SKLabelNode(text: "x1")
		label.position = CGPoint(x: 0, y: size.height/3)
		label.fontSize = 40
		label.name = "multiplierLabel"
		self.addChild(label)
		
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
			let bump = SKSpriteNode(imageNamed: "BodyLump")
			bump.setScale(2)
			bump.position = CGPoint(x: 0, y: -size.height/3.4)
			bump.name = "bodyBump"
			self.addChild(bump)
			self.fieldNodes.append(bump)
			
			color = SKColor.clearColor()
		case .Empty:
			color = SKColor.clearColor()
		case .Corn:
            
            // Seed the generator
            srand(10)
            
            let growTime = 3
            let deathTime = 7
			
			for i in -3...3 {
				let corn = SKSpriteNode(imageNamed: "Corn")
                
                // Because it takes 3 turns to grow
                let progress = CGFloat(min(1, Float(age) / Float(growTime)))
                
                let randomYOffset = CGFloat (rand() % 20)
                
                let maxHeight = (size.height / 4) - 10 + randomYOffset
                let maxWidth = size.width / 2
                
                // Gray if unripe or approaching death
                if age < growTime {
                    let colorize = SKAction.colorizeWithColor(SKColor.grayColor(), colorBlendFactor: 0.8, duration: 0)
                    corn.runAction(colorize)
                }
                
                // Read if approaching death
                if age == deathTime {
                    let colorize = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0.5, duration: 0)
                    corn.runAction(colorize)
                }
                
                // Gray more if dead
                if age > deathTime {
                    let colorize = SKAction.colorizeWithColor(SKColor.blackColor(), colorBlendFactor: 0.8, duration: 0)
                    corn.runAction(colorize)
                }
                
                corn.size = CGSize(width: maxWidth * progress, height: maxHeight * progress)
				corn.name = "corn"
                
                let randomXOffset = Int (rand() % 20)
                
				corn.position = CGPoint(x: CGFloat((i * 40) - 10 + randomXOffset), y: ((-self.size.height * 0.32) + corn.size.height/2))
				
				self.addChild(corn)
				self.fieldNodes.append(corn)
			}
			
			color = SKColor.clearColor()
		case .House:
			let house = SKSpriteNode(imageNamed: "House")
			house.name = "house"
			house.setScale(8)
			house.position = CGPoint(x: -size.width * 0.4, y: -size.height/8)
			self.addChild(house)
			
			self.fieldNodes.append(house)
			
			color = SKColor.clearColor()
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
			let millBase = SKSpriteNode(imageNamed: "windturbineturbine")	//image is named wrong...
			millBase.name = "millBase"
			millBase.setScale(7)
			millBase.size = CGSize(width: millBase.size.width, height: millBase.size.height + 110)
			millBase.position = CGPoint(x: 0, y: 60)
			self.addChild(millBase)
			self.fieldNodes.append(millBase)
			
			let millTurbine = SKSpriteNode(imageNamed: "windturbinebase") //image is named wrong...
			millTurbine.name = "millTurbine"
			millTurbine.setScale(7)
			millTurbine.position = CGPoint(x: 0, y: size.height * 0.6)
			self.addChild(millTurbine)
			self.fieldNodes.append(millTurbine)
			
			//anim
			let gentleRotate = SKAction.repeatActionForever(SKAction.rotateByAngle(6.28, duration: 6))
			millTurbine.runAction(gentleRotate)
			
			color = SKColor.clearColor()
		}
		
		colorNode.name = "colorNode"
		colorNode.fillColor = color
		self.fieldNodes.append(colorNode)
		
		self.addChild(colorNode)
		
		//update button
		if let button = self.childNodeWithName("button") as? Button {
			let buttonInfo = self.getButtonActionForCurrentPlot()
			button.setTitle(buttonInfo.0)
			button.action = buttonInfo.1
			if button.getTitle() == nil || button.getTitle() == "" {
				button.hidden = true
			} else {
				button.hidden = false
			}
		}
	}
	
	///Call everytime the person 
	func lightUpdate() {
		//update multiplier text
		if let multiplierLabel = self.childNodeWithName("multiplierLabel") as? SKLabelNode {
			let multi = self.getMultiplier()
			if multi == 1 {
				multiplierLabel.text = ""
			} else {
				multiplierLabel.text = "x\(self.getMultiplier())"
			}
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
				}
			}
		}
		if self.contents == .Empty {
			buttonTitle = "Plant"
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
				if let farmScene = sender as? FarmScene {
					farmScene.scrollLock = true
					//expand the farm by one plot, essencially adding another tractor plot
					//and setting this plot to be empty
					if let wheel = self.childNodeWithName("wheel"), hull = self.childNodeWithName("hull") {
						let rotate = SKAction.rotateByAngle(-6.28, duration: 2.2)
						let move = SKAction.moveByX(self.size.width, y: 0, duration: 2.2)
						let group = SKAction.group([rotate,move])
						wheel.runAction(group)
						hull.runAction(move) {
							//on completion:
							GameProfile.sharedInstance.money -= 20
							farmScene.updateMoney()
							farmScene.extendFarm()
						
							if self.index == 4 {
								self.contents = .DeadBody
							} else {
								self.contents = .Empty
							}
							
							self.updateNodeContent()
							farmScene.scrollLock = false
						}
					}
				}
			}
		}
		
		return (buttonTitle, buttonAction)
	}
	
	func getMultiplier() -> Float {
		let allPlots = GameProfile.sharedInstance.plots
		if index == 0 || index >= allPlots.count-1 {
			return 1	//will cause errors, and only applies to edge plots which don't need multipliers
		}
		
		let onlyLeftPlots = allPlots[0..<self.index]
		var leftwardPlots = onlyLeftPlots.reverse() //0 is closest Plot to the left
		var rightwardPlots = allPlots[self.index+1..<allPlots.count] //0 is closest Plot to the right
		
		var totalMultiplier : Float = 1.0
		
		if contents == .Corn {
			if leftwardPlots[0].contents == PlotContent.Corn && rightwardPlots[0].contents == PlotContent.Corn {
				totalMultiplier += 2
			}
		}
		
		return totalMultiplier
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
