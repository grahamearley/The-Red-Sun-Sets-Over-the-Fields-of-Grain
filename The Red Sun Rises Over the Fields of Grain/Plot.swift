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
	case Carrot = "Carrot"
	case Wheat = "Wheat"
	case Pumpkin = "Pumpkin"
	
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
		let label = SKLabelNode(text: "")
		label.position = CGPoint(x: 0, y: size.height/3)
		label.fontSize = 40
		label.name = "bonusLabel"
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
		
		switch self.contents {
		case .DeadBody:
			let bump = SKSpriteNode(imageNamed: "BodyLump")
			bump.setScale(2)
			bump.position = CGPoint(x: 0, y: -size.height/3.4)
			bump.name = "bodyBump"
			self.addChild(bump)
			self.fieldNodes.append(bump)
		case .Empty:
			break
		case .Carrot:
			self.addContentForVegitable(growTime: 2, deathTime: 3, amount: 2, imageAssetNamed: "Carrot")
		case .Corn:
			self.addContentForVegitable(growTime: 3, deathTime: 7, amount: 6, imageAssetNamed: "Corn")
		case .Wheat:
			self.addContentForVegitable(growTime: 3, deathTime: 5, amount: 10, imageAssetNamed: "Wheat")
		case .Pumpkin:
			self.addContentForVegitable(growTime: 5, deathTime: 9, amount: 1, imageAssetNamed: "Pumpkin")
		case .House:
			let house = SKSpriteNode(imageNamed: "House")
			house.name = "house"
			house.setScale(5)
			house.position = CGPoint(x: -size.width * 0.4, y: -size.height/8)
			self.addChild(house)
			self.fieldNodes.append(house)
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
		}
		
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
		
		lightUpdate()
	}
	
	///Call everytime the person 
	func lightUpdate() {
		//update multiplier text
		if let bonusLabel = self.childNodeWithName("bonusLabel") as? SKLabelNode {
			let bonus = self.getBonus()
			if bonus == 0 {
				bonusLabel.text = ""
			} else {
				bonusLabel.text = "+\(bonus)"
			}
		}
	}
	
	///Returns the title and action that the current plot's button should display
	private func getButtonActionForCurrentPlot() -> (String, AnyObject?->()) {
		var buttonTitle : String = ""
		var buttonAction : AnyObject?->Void = {(sender: AnyObject?)->() in return}
		
		if self.contents == .Corn {
			let info = self.getButtonInfoForPlant(growAge: 3, dieAge: 7, baseYield: 5)
			buttonTitle = info.0
			buttonAction = info.1
		}
		
		if self.contents == .Carrot {
			let info = self.getButtonInfoForPlant(growAge: 2, dieAge: 3, baseYield: 3)
			buttonTitle = info.0
			buttonAction = info.1
		}
		
		if self.contents == .Wheat {
			let info = self.getButtonInfoForPlant(growAge: 3, dieAge: 8, baseYield: 7)
			buttonTitle = info.0
			buttonAction = info.1
		}
		
		if self.contents == .Pumpkin {
			let info = self.getButtonInfoForPlant(growAge: 5, dieAge: 9, baseYield: 12)
			buttonTitle = info.0
			buttonAction = info.1
		}
		
		if self.contents == .Empty {
			buttonTitle = "Plant"
			buttonAction = { (sender:AnyObject?) in
				if let farmScene = sender as? FarmScene {
					farmScene.setStoreLocks(true)
				}
				
				let storeMenu = self.getStore()
				self.addChild(storeMenu)
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
                    if GameProfile.sharedInstance.money >= 20 {
                        if let farmScene = sender as? FarmScene {
                            farmScene.scrollLock = true
                            //expand the farm by one plot, essentially adding another tractor plot
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
                    else {
                            if let farmScene = sender as? FarmScene {
                                // flash money sign if you don't have enough $$
                                farmScene.moneyWarning()
                        }
                    }
                        
                }
            }
		return (buttonTitle, buttonAction)
	}
	
	func getButtonInfoForPlant(#growAge:Int, dieAge:Int, baseYield: Int) -> (String, AnyObject?->()) {
		var buttonTitle : String = ""
		var buttonAction : AnyObject?->Void = {(sender: AnyObject?)->() in return}
		
		if age >= growAge && age <= dieAge {
			//harvestable corn:
			buttonTitle = "Harvest"
			buttonAction = { (sender:AnyObject?) in
				//harvest the corn:
				GameProfile.sharedInstance.money += baseYield + self.getBonus()
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
		
		return (buttonTitle, buttonAction)
	}
	
	func getBonus() -> Int {
		let allPlots = GameProfile.sharedInstance.plots
		if index == 0 || index >= allPlots.count-1 {
			return 0	//will cause errors, and only applies to edge plots which don't need multipliers
		}
		
		let onlyLeftPlots = allPlots[0..<self.index]
		var leftwardPlots = onlyLeftPlots.reverse() //0 is closest Plot to the left
		var rightwardPlots = allPlots[self.index+1..<allPlots.count] //0 is closest Plot to the right
		
		var totalBonus = 0
		
		if contents == .Corn {
			if leftwardPlots[0].contents == .Carrot && rightwardPlots[0].contents == .Carrot {
				totalBonus += 4
			}
		}
		
		if contents == .Carrot {
			if leftwardPlots[0].contents == .Carrot && rightwardPlots[0].contents == .Carrot {
				totalBonus += 1
			}
		}
		
		if contents == .Wheat {
			if leftwardPlots[0].contents == .Corn && rightwardPlots[0].contents == .Corn {
				totalBonus += 4
			}
		}
		
		if contents == .Pumpkin {
			var conditionsSatisfied = false
			if rightwardPlots.count > 1 {
				//check far right
				if leftwardPlots[0].contents == .Empty && rightwardPlots[0].contents == .Pumpkin && rightwardPlots[1].contents == .Empty {
					conditionsSatisfied = true
				}
			}
			
			if leftwardPlots.count > 1 {
				//check far left
				if rightwardPlots[0].contents == .Empty && leftwardPlots[0].contents == .Pumpkin && leftwardPlots[1].contents == .Empty {
					conditionsSatisfied = true
				}
			}
			
			if conditionsSatisfied {
				totalBonus += 8
			}
		}
		
		//vegies
		if contents == .Corn || contents == .Carrot || contents == .Wheat || contents == .Pumpkin {
			//Windmill check
			var nearWindmill = false
			if leftwardPlots[0].contents == .Windmill || leftwardPlots[0].contents == .Windmill {
				nearWindmill = true
			}
			if leftwardPlots.count > 1 {
				if leftwardPlots[1].contents == .Windmill {
					nearWindmill = true
				}
			}
			if rightwardPlots.count > 1 {
				if rightwardPlots[1].contents == .Windmill {
					nearWindmill = true
				}
			}
			
			if nearWindmill {
				totalBonus += 2
			}
		}
		
		return totalBonus
	}

	
	func ageContent(byAmount:Int = 1) {
		age += byAmount
	}
	
	func getStore() -> StoreMenu {
        let currentFunds = GameProfile.sharedInstance.money
		let cornBag = StoreItem(imageNamed: "CornBag", cost: 3, time: 3) { (sender: AnyObject?) in
            if currentFunds < 3 {
                if let farmScene = sender as? FarmScene {
                    farmScene.moneyWarning()
                }
            } else {
                //onAction:
                //add some corn:
                self.contents = .Corn
                self.age = 0
                self.updateNodeContent()
                
                // Costs $3
                GameProfile.sharedInstance.money -= 3
                if let farmScene = sender as? FarmScene {
                    farmScene.updateMoney()
                }
                
                // reset locking
                if let farmScene = sender as? FarmScene {
                    farmScene.setStoreLocks(false)
                }
            }
		}
		
		let wheatBag = StoreItem(imageNamed: "WheatBag", cost: 5, time: 3) { (sender: AnyObject?) in
			if currentFunds < 5 {
				if let farmScene = sender as? FarmScene {
					farmScene.moneyWarning()
				}
			} else {
				//onAction:
				//add some wheat:
				self.contents = .Wheat
				self.age = 0
				self.updateNodeContent()
				
				// costs 1
				GameProfile.sharedInstance.money -= 5
				if let farmScene = sender as? FarmScene {
					farmScene.updateMoney()
				}
				
				// reset locking
				if let farmScene = sender as? FarmScene {
					farmScene.setStoreLocks(false)
				}
			}
		}
		
		let pumpkinBag = StoreItem(imageNamed: "PumpkinBag", cost: 8, time: 5) { (sender: AnyObject?) in
			if currentFunds < 5 {
				if let farmScene = sender as? FarmScene {
					farmScene.moneyWarning()
				}
			} else {
				//onAction:
				//add some pumpkins:
				self.contents = .Pumpkin
				self.age = 0
				self.updateNodeContent()
				
				// costs 8
				GameProfile.sharedInstance.money -= 8
				if let farmScene = sender as? FarmScene {
					farmScene.updateMoney()
				}
				
				// reset locking
				if let farmScene = sender as? FarmScene {
					farmScene.setStoreLocks(false)
				}
			}
		}

		
		let carrotBag = StoreItem(imageNamed: "CarrotBag", cost: 1, time: 2) { (sender: AnyObject?) in
            if currentFunds < 1 {
                if let farmScene = sender as? FarmScene {
                    farmScene.moneyWarning()
                }
            } else {
                //onAction:
                //add some corn:
                self.contents = .Carrot
                self.age = 0
                self.updateNodeContent()
                
                // Costs $1
                GameProfile.sharedInstance.money -= 1
                if let farmScene = sender as? FarmScene {
                    farmScene.updateMoney()
                }
                
                // reset locking
                if let farmScene = sender as? FarmScene {
                    farmScene.setStoreLocks(false)
                }
            }
		}
		
		let myButton = StoreItem(imageNamed: "TomatoBag", cost: -1, time: -1)  { (sender: AnyObject?) in
			println("hey") // todo: add real code
		}

		let menuSize = CGSize(width: size.width * 1, height: size.height * 0.8)
		let seedPage = StorePage(buttons: [cornBag,carrotBag,wheatBag,pumpkinBag], size: menuSize)
		let buildingPage = StorePage(buttons: [myButton], size: menuSize)
		
		let storeMenu = StoreMenu(pages: [seedPage,buildingPage], size: menuSize)
		return storeMenu
	}
	
	func addContentForVegitable(#growTime: Int, deathTime: Int, amount: Int, imageAssetNamed: String) {
		srand(10)
		let density = Int(amount/2)
		
		for i in -density...density {
			
			if age == 0 {
				
				var seed = SKShapeNode(circleOfRadius: 2)
				seed.zPosition = 1
				seed.fillColor = SKColor.brownColor()
				seed.lineWidth = 0
				let randomXOffset = Int (rand() % 20)
				seed.position = CGPoint(x: CGFloat((i * 40) - 10 + randomXOffset), y: (-self.size.height * 0.32))
				
				self.addChild(seed)
				self.fieldNodes.append(seed)
				
			} else {
				var vegi = SKSpriteNode(imageNamed: imageAssetNamed)
				
				let randomYOffset = CGFloat (rand() % 20)
				
				var maxHeight = (size.height / 4) - 10 + randomYOffset
				if self.contents == .Wheat {
					maxHeight *= 2
				}
				let maxWidth = size.width / 2
				
				// Gray if unripe or approaching death
				if age < growTime {
					let colorize = SKAction.colorizeWithColor(SKColor.grayColor(), colorBlendFactor: 0.8, duration: 0)
					vegi.runAction(colorize)
				}
				
				// Red if approaching death
				if age == deathTime {
					let colorize = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0.5, duration: 0)
					vegi.runAction(colorize)
				}
				
				// Gray more if dead
				if age > deathTime {
					let colorize = SKAction.colorizeWithColor(SKColor.blackColor(), colorBlendFactor: 0.8, duration: 0)
					vegi.runAction(colorize)
				}
				
				let progress = CGFloat(min(1, Float(age) / Float(growTime)))
				vegi.size = CGSize(width: maxWidth * progress, height: maxHeight * progress)
				vegi.name = imageAssetNamed.lowercaseString
				
				let randomXOffset = Int (rand() % 20)
				vegi.position = CGPoint(x: CGFloat((i * 40) - 10 + randomXOffset), y: ((-self.size.height * 0.32) + vegi.size.height/2))
				
				self.addChild(vegi)
				self.fieldNodes.append(vegi)
			}
		}
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
