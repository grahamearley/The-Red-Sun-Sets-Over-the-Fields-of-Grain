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
class Plot: SKNode {
	
	var contents : PlotContent = .Empty
	var age : Int = 0
	
	override init() {
		super.init()
	}
	
	init(contents: PlotContent) {
		super.init()
		self.contents = contents
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Plot Interaction
	
	///Replaces the current contents of the plot with a updated content.
	///Must be called after changing self.contents to reflect that
	func updateNodeContent(size: CGSize) {
		
		//remove old field content
		self.enumerateChildNodesWithName("field", usingBlock: {
			(node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
			node.removeFromParent()
		})
		
		//fill in new contents
		var colorNode = SKShapeNode(rectOfSize: CGSize(width: size.width/4, height: size.height/4))
		colorNode.position = CGPoint(x: 0, y: -size.height/4)
		let color : SKColor
		
		switch self.contents {
		case .DeadBody:
			color = SKColor.brownColor()
		case .Empty:
			color = SKColor.blackColor()
		case .Corn:
			color = SKColor.yellowColor()
		case .House:
			color = SKColor.redColor()
		case .Tractor:
			color = SKColor.purpleColor()
		case .Wheat:
			color = SKColor.greenColor()
		case .Windmill:
			color = SKColor.grayColor()
		}
		
		colorNode.name = "field"
		colorNode.fillColor = color
		
		self.addChild(colorNode)
	}
	
	func getMultiplier(plotArray: [Plot], atIndex: Int) -> Float {
		return 1
	}
	
	func getActionAssociatedWithContent() -> Void->Void {
		return {return}
	}
	
	func ageContent(byAmount:Int = 1) {
		age += byAmount
	}
	
	//MARK: - Save/Load
	
	func toDictionary() -> [String:AnyObject] {
		var dict = [String:AnyObject]()
		
		dict["contents"] = self.contents.rawValue
		dict["age"] = self.age
		
		return dict
	}
	
	class func fromDictionary(dictionary: [String:AnyObject]) -> Plot {
		let plot = Plot()
		if let contentValFromDict : String = dictionary["contents"] as? String {
			if let content = PlotContent(rawValue: contentValFromDict) {
				plot.contents = content
			}
		}
		if let ageValFromDict : Int = dictionary["age"] as? Int {
			plot.age = ageValFromDict
		}
		return plot
	}
	
	
}
