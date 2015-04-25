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

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func isStarred(leftPlot: Plot, rightPlot: Plot) -> Bool {
		return false
	}
	
	func getActionAssociatedWithContent() -> Void->Void {
		return {return}
	}
	
	func ageContent(byAmount:Int = 1) {
		age += byAmount
	}
	
	func toDictionary() -> [String:AnyObject] {
		//stub.
		return ["test":1]
	}
	
    class func fromDictionary(dictionary: [String:AnyObject]) -> Plot {
		//stub.
		return Plot()
	}
	
}
