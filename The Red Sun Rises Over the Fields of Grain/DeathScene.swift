//
//  DeathScene.swift
//  The Red Sun Rises Over the Fields of Grain
//
//  Created by David Pickart on 4/25/15.
//  Copyright (c) 2015 Silo Games. All rights reserved.
//

import Foundation

import UIKit
import SpriteKit

class DeathScene: SKScene {
	init(size: CGSize, score: Int) {
        super.init(size: size)
        
        // Gravestone
        let background = SKSpriteNode(imageNamed: "RIP")
        background.size = size
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        self.addChild(background)
        
        // Top text
        let textLabel = SKLabelNode(fontNamed: "FreePixel-Regular")
        textLabel.text = "You have died."
        textLabel.fontColor = UIColor.whiteColor()
        textLabel.fontSize = 40
        textLabel.position = CGPoint(x: size.width  / 2, y: size.height * 0.8)
        self.addChild(textLabel)
		
		// Top text
		let hsLabel = SKLabelNode(fontNamed: "FreePixel-Regular")
		hsLabel.text = "You had \(score) coins."
		hsLabel.fontColor = UIColor.grayColor()
		hsLabel.fontSize = 40
		hsLabel.position = CGPoint(x: size.width  / 2, y: size.height * 0.7)
		self.addChild(hsLabel)
		
        // ghost icon
        let ghostIcon = SKSpriteNode(imageNamed: "Ghost")
        ghostIcon.position = CGPoint(x: self.size.width - ghostIcon.size.width/2 - 230, y: self.size.height - 30)
        self.addChild(ghostIcon)
        
        // ghost label
        let ghostLabel = SKLabelNode(fontNamed: "FreePixel-Regular")
        ghostLabel.text = "+1"
        ghostLabel.fontColor = UIColor.whiteColor()
        ghostLabel.fontSize = 25
        ghostLabel.position = CGPoint(x: size.width - 215, y: size.height - 40)
        self.addChild(ghostLabel)
        
        // Bottom text
        let bottomLabel = SKLabelNode(fontNamed: "FreePixel-Regular")
        bottomLabel.text = "Tap to restart."
        bottomLabel.fontColor = UIColor.blackColor()
        bottomLabel.fontSize = 30
        bottomLabel.position = CGPoint(x: size.width  / 2, y: size.height * 0.07)
        self.addChild(bottomLabel)
		bottomLabel.alpha = 0
		bottomLabel.runAction(SKAction.fadeInWithDuration(3))
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let transition = SKTransition.crossFadeWithDuration(3)
        self.view?.presentScene(MurderScene(size: size), transition: transition)
    }

}