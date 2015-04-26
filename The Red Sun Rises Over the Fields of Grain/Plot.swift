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
    
    case GoldWindmill = "GoldWindmill"
	
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
		ground.lightingBitMask = 1
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
		
		//bonus text
		let label = SKLabelNode(fontNamed: "FreePixel-Regular")
		label.text = ""
		label.fontColor = SKColor.orangeColor()
		label.position = CGPoint(x: 0, y: 0)
		label.zPosition = 15
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
			bump.lightingBitMask = 1
			bump.name = "bodyBump"
			self.addChild(bump)
			self.fieldNodes.append(bump)
		case .Empty:
			break
		case .Corn:
			self.addContentForVegetable()
        case .Carrot:
            self.addContentForVegetable()
		case .Wheat:
			self.addContentForVegetable()
		case .Pumpkin:
			self.addContentForVegetable()
		case .House:
			let house = SKSpriteNode(imageNamed: "House")
			house.name = "house"
			house.setScale(5)
			house.lightingBitMask = 1
			house.position = CGPoint(x: -size.width * 0.4, y: -size.height/8)
			self.addChild(house)
			self.fieldNodes.append(house)
		case .Tractor:
			let hull = SKSpriteNode(imageNamed: "TractorBody")
			hull.name = "hull"
			hull.lightingBitMask = 1
			hull.size = CGSize(width: self.size.width, height: self.size.height/2)
			hull.position = CGPoint(x: self.size.width/4, y: 0)
			self.addChild(hull)
			
			let wheel = SKSpriteNode(imageNamed: "TractorWheel")
			wheel.lightingBitMask = 1
			wheel.position = CGPoint(x: 0, y: -self.size.height/5)
			wheel.setScale(5)
			wheel.name = "wheel"
			self.addChild(wheel)
			
			self.fieldNodes.append(hull)
			self.fieldNodes.append(wheel)
		case .Windmill:
			if self.age >= 8 {
				//it's built
				let millBase = SKSpriteNode(imageNamed: "windturbineturbine")	//image is named wrong...
				millBase.lightingBitMask = 1
				millBase.name = "millBase"
				millBase.setScale(7)
				millBase.size = CGSize(width: millBase.size.width, height: millBase.size.height + 110)
				millBase.position = CGPoint(x: 0, y: 60)
				self.addChild(millBase)
				self.fieldNodes.append(millBase)
				
				let millTurbine = SKSpriteNode(imageNamed: "windturbinebase") //image is named wrong...
				millTurbine.lightingBitMask = 1
				millTurbine.name = "millTurbine"
				millTurbine.setScale(7)
				millTurbine.position = CGPoint(x: 0, y: size.height * 0.6)
				self.addChild(millTurbine)
				self.fieldNodes.append(millTurbine)
				
				//anim
				let gentleRotate = SKAction.repeatActionForever(SKAction.rotateByAngle(6.28, duration: 6))
				millTurbine.runAction(gentleRotate)
			} else {
				let trafficCone = SKSpriteNode(imageNamed: "TrafficCone")
				trafficCone.lightingBitMask = 1
				trafficCone.name = "trafficCone"
				trafficCone.setScale(3)
				trafficCone.position = CGPoint(x: 0, y: -self.size.height/5-60)

				self.addChild(trafficCone)
				self.fieldNodes.append(trafficCone)
			}
            
        case .GoldWindmill:
            if self.age >= 15 {
                //it's built
                let millBase = SKSpriteNode(imageNamed: "goldwindturbineturbine")	//image is named wrong...
				millBase.lightingBitMask = 1
                millBase.name = "millBase"
                millBase.setScale(7)
                millBase.size = CGSize(width: millBase.size.width, height: millBase.size.height + 110)
                millBase.position = CGPoint(x: 0, y: 60)
                self.addChild(millBase)
                self.fieldNodes.append(millBase)
                
                let millTurbine = SKSpriteNode(imageNamed: "goldwindturbinebase") //image is named wrong...
				millTurbine.lightingBitMask = 1
                millTurbine.name = "millTurbine"
                millTurbine.setScale(7)
                millTurbine.position = CGPoint(x: 0, y: size.height * 0.6)
                self.addChild(millTurbine)
                self.fieldNodes.append(millTurbine)
                
                //anim
                let gentleRotate = SKAction.repeatActionForever(SKAction.rotateByAngle(6.28, duration: 4))
                millTurbine.runAction(gentleRotate)
            } else {
                let trafficCone = SKSpriteNode(imageNamed: "TrafficCone")
				trafficCone.lightingBitMask = 1
                trafficCone.name = "trafficCone"
                trafficCone.setScale(3)
                trafficCone.position = CGPoint(x: 0, y: -self.size.height/5-60)
                
                self.addChild(trafficCone)
                self.fieldNodes.append(trafficCone)
            }
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
		
		GameProfile.sharedInstance.saveToFile()
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
        
        // If veggie
		if self.contents == .Corn || self.contents == .Carrot || self.contents == .Wheat || self.contents == .Pumpkin  {
			let info = self.getButtonInfoForPlant()
			buttonTitle = info.0
			buttonAction = info.1
		}
		
		if self.contents == .Empty {
			buttonTitle = GameSettings.sharedInstance.plantButtonTitle
			buttonAction = { (sender:AnyObject?) in
				if let farmScene = sender as? FarmScene {
					farmScene.setStoreLocks(true)
				}
				
				let storeMenu = self.getStore()
				self.addChild(storeMenu)
			}
		}
		if self.contents == .House {
			buttonTitle = GameSettings.sharedInstance.houseButtonTitle
			buttonAction = { (sender:AnyObject?) in
				//progress the FarmScene (the sender) by one turn:
				if let farmScene = sender as? FarmScene {
					farmScene.ageByTurn(amount: 1)
                    self.updateNodeContent()
                    farmScene.updateDayCount()
				}
			}
		}
		if self.contents == .Tractor {
			buttonTitle = GameSettings.sharedInstance.tractorButtonTitle
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
	
    func getButtonInfoForPlant() -> (String, AnyObject?->()) {
        
        var plantInfo = getInfoForCurrentPlant()
        
        let growAge = plantInfo["growAge"] as! Int
        let dieAge = plantInfo["dieAge"] as! Int
        
		var buttonTitle : String = ""
		var buttonAction : AnyObject?->Void = {(sender: AnyObject?)->() in return}
		
		if age >= growAge && age <= dieAge {
			//harvestable:
			buttonTitle = GameSettings.sharedInstance.harvestButtonTitle
			buttonAction = { (sender:AnyObject?) in
				//harvest the corn:
                if let yield = plantInfo["baseYield"] as? Int {
                    GameProfile.sharedInstance.money += yield + self.getBonus()
                    self.contents = .Empty
                    self.age = 0
                    self.updateNodeContent()
                    
                    // Gettin money
                    if let farmScene = sender as? FarmScene {
                        farmScene.updateMoney()
                    }
                }

			}
		} else {
			//dead or not grown:
			buttonTitle = GameSettings.sharedInstance.removeButtonTitle
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
			if leftwardPlots[0].contents == .Carrot && leftwardPlots[0].age >= 2 && rightwardPlots[0].contents == .Carrot && rightwardPlots[0].age >= 2 {
				totalBonus += 4
			}
		}
		
		if contents == .Carrot {
			if leftwardPlots[0].contents == .Carrot && leftwardPlots[0].age >= 2 && rightwardPlots[0].contents == .Carrot && rightwardPlots[0].age >= 2 {
				totalBonus += 1
			}
		}
		
		if contents == .Wheat {
			if leftwardPlots[0].contents == .Corn && leftwardPlots[0].age >= 3 && rightwardPlots[0].contents == .Corn && rightwardPlots[0].age >= 3 {
				totalBonus += 4
			}
		}
		
		if contents == .Pumpkin {
			var conditionsSatisfied = false
			if rightwardPlots.count > 1 {
				//check far right
				if leftwardPlots[0].contents == .Empty && (rightwardPlots[0].contents == .Pumpkin && rightwardPlots[0].age >= 5) && rightwardPlots[1].contents == .Empty {
					conditionsSatisfied = true
				}
			}
			
			if leftwardPlots.count > 1 {
				//check far left
				if rightwardPlots[0].contents == .Empty && (leftwardPlots[0].contents == .Pumpkin && leftwardPlots[0].age >= 5) && leftwardPlots[1].contents == .Empty {
					conditionsSatisfied = true
				}
			}
			
			if conditionsSatisfied {
				totalBonus += 8
			}
		}
		
		//veggies
		if contents == .Corn || contents == .Carrot || contents == .Wheat || contents == .Pumpkin {
			//Windmill check
			var nearWindmill = false
			if (leftwardPlots[0].contents == .Windmill && leftwardPlots[0].age >= 8) || (rightwardPlots[0].contents == .Windmill && rightwardPlots[0].age >= 8) {
				nearWindmill = true
			}
			if leftwardPlots.count > 1 {
				if leftwardPlots[1].contents == .Windmill && leftwardPlots[1].age >= 8 {
					nearWindmill = true
				}
			}
			if rightwardPlots.count > 1 {
				if rightwardPlots[1].contents == .Windmill && rightwardPlots[1].age >= 8 {
					nearWindmill = true
				}
			}
			
			if nearWindmill {
				totalBonus += 2
			}
            
		}
		
		return totalBonus
	}

	func ageContent(amount:Int = 1) {
		let allPlots = GameProfile.sharedInstance.plots
		if index == 0 || index >= allPlots.count-1 {
			age+=amount	//will cause errors, and only applies to edge plots which don't need multipliers
			return
		}
		
		let onlyLeftPlots = allPlots[0..<self.index]
		var leftwardPlots = onlyLeftPlots.reverse() //0 is closest Plot to the left
		var rightwardPlots = allPlots[self.index+1..<allPlots.count] //0 is closest Plot to the right
		
		var foundGoldWindmill = false
		if leftwardPlots[0].contents == .GoldWindmill || rightwardPlots[0].contents == .GoldWindmill {
			foundGoldWindmill = true
		}
		if leftwardPlots.count > 1 {
			if leftwardPlots[1].contents == .GoldWindmill {
				foundGoldWindmill = true
			}
		}
		if rightwardPlots.count > 1 {
			if rightwardPlots[1].contents == .GoldWindmill {
				foundGoldWindmill = true
			}
		}
		if foundGoldWindmill {
			//boost age an extra bit
			age++
		}
		
		age += amount
	}
	
	func getStore() -> StoreMenu {
        let currentFunds = GameProfile.sharedInstance.money
        let currentGhosts = GameProfile.sharedInstance.ghostPoints
        
        var seedArray = [StoreItem]()
        
        seedArray.append(generateSeedButtonForPlant(.Corn))
        seedArray.append(generateSeedButtonForPlant(.Carrot))
        seedArray.append(generateSeedButtonForPlant(.Wheat))
        seedArray.append(generateSeedButtonForPlant(.Pumpkin))
		
        let windmill = StoreItem(imageNamed: "windturbinebase", ghosts: 3, time: 8, scale: 1.85)  { (sender: AnyObject?) in
            if currentGhosts < 3 {
                if let farmScene = sender as? FarmScene {
                    farmScene.ghostWarning()
                }
            } else {
                //onAction:
                //add some windmill lol:
                self.contents = .Windmill
                self.age = 0
                self.updateNodeContent()
                
                // Costs 3 ghosts
                GameProfile.sharedInstance.ghostPoints -= 3
                if let farmScene = sender as? FarmScene {
                    farmScene.updateGhosts()
                }
                
                // reset locking
                if let farmScene = sender as? FarmScene {
                    farmScene.setStoreLocks(false)
                }
 
            }
		}
		
		let goldWindmill = StoreItem(imageNamed: "goldwindturbinebase", ghosts: 6, time: 15, scale: 1.85)  { (sender: AnyObject?) in
			if currentGhosts < 6 {
				if let farmScene = sender as? FarmScene {
					farmScene.ghostWarning()
				}
			} else {
				//onAction:
				//add some windmill lol:
				self.contents = .GoldWindmill
				self.age = 0
				self.updateNodeContent()
				
				// Costs 6 ghosts
				GameProfile.sharedInstance.ghostPoints -= 6
				if let farmScene = sender as? FarmScene {
					farmScene.updateGhosts()
				}
				
				// reset locking
				if let farmScene = sender as? FarmScene {
					farmScene.setStoreLocks(false)
				}
				
			}
		}

		let menuSize = CGSize(width: size.width * 1, height: size.height * 0.8)
		let seedPage = StorePage(buttons: seedArray, size: menuSize)
		let buildingPage = StorePage(buttons: [windmill,goldWindmill], size: menuSize)
		
		let storeMenu = StoreMenu(pages: [seedPage,buildingPage], size: menuSize)
		return storeMenu
	}
    
    func generateSeedButtonForPlant(plant: PlotContent) -> (StoreItem) {
        
        var info = [String : AnyObject]()
        
        switch (plant) {
            case .Corn:
                info = GameSettings.sharedInstance.cornInfo
                break
            case .Carrot:
                info = GameSettings.sharedInstance.carrotInfo
                break
            case .Wheat:
                info = GameSettings.sharedInstance.wheatInfo
                break
            case .Pumpkin:
                info = GameSettings.sharedInstance.pumpkinInfo
                break
            default:
                // This should NEVER HAPPEn
                break
        }
    
        let currentFunds = GameProfile.sharedInstance.money
    
        let growAge = info["growAge"] as! Int
        let cost = info["cost"] as! Int
        let asset = info["storeAssetName"] as! String
    
        let item = StoreItem(imageNamed: asset, cost: cost, time: growAge) { (sender: AnyObject?) in
            if currentFunds < cost {
                if let farmScene = sender as? FarmScene {
                    farmScene.moneyWarning()
                }
            } else {
                //onAction:
                //add some corn:
                self.contents = plant
                self.age = 0
                self.updateNodeContent()

                // Costs $3
                GameProfile.sharedInstance.money -= cost
                if let farmScene = sender as? FarmScene {
                    farmScene.updateMoney()
                }

                // reset locking
                if let farmScene = sender as? FarmScene {
                    farmScene.setStoreLocks(false)
                }
            }
        }
    
        return item
    }
	
	func addContentForVegetable() {
        
        var plantInfo = getInfoForCurrentPlant()
    
        let growTime = plantInfo["growAge"] as! Int
        let deathTime = plantInfo["dieAge"] as! Int
        let amount = plantInfo["amount"] as! Int
        let assetName = plantInfo["assetName"] as! String
        
        // Seed the generator! It's a pun!
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
				var vegi = SKSpriteNode(imageNamed: assetName)
				vegi.lightingBitMask = 1
				
				let randomYOffset = CGFloat (rand() % 20)
				
				var maxHeight = (size.height / 4) - 10 + randomYOffset
				if self.contents == .Wheat {
					maxHeight *= 1.5
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
				vegi.name = assetName.lowercaseString
				
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
    
    ///Helper
    func getInfoForCurrentPlant() -> [String:AnyObject] {
        var info = [String : AnyObject]()
        
        switch (self.contents) {
        case .Corn:
            info = GameSettings.sharedInstance.cornInfo
            break
        case .Carrot:
            info = GameSettings.sharedInstance.carrotInfo
            break
        case .Wheat:
            info = GameSettings.sharedInstance.wheatInfo
            break
        case .Pumpkin:
            info = GameSettings.sharedInstance.pumpkinInfo
            break
        default:
            // This should NEVER HAPPEn
            break
        }

        return info
    }
	
	
}
