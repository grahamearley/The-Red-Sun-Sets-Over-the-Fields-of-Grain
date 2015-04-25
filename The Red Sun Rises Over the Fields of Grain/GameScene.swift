//
//  GameScene.swift
//  The Red Sun Rises Over the Fields of Grain
//
//  Created by Graham Earley on 4/24/15.
//  Copyright (c) 2015 Silo Games. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
	
	override init(size: CGSize) {
		super.init(size: size)
		//hello world
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
		//touches
    }
   
    override func update(currentTime: CFTimeInterval) {
		//called every 60 seconds
    }
}
