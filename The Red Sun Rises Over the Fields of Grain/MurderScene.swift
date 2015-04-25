//
//  MurderScene.swift
//  The Red Sun Rises Over the Fields of Grain
//
//  Created by Charlie Imhoff on 4/24/15.
//  Copyright (c) 2015 Silo Games. All rights reserved.
//

import SpriteKit

class MurderScene: SKScene {

    //Init Scene here
    override init(size: CGSize) {
        super.init(size: size)
        
        let houseInTheDistanceMoment = self.getHouseInTheDistanceMoment(size)
        
        self.addChild(houseInTheDistanceMoment)
        houseInTheDistanceMoment.runAction(SKAction.fadeOutWithDuration(4))

//        self.addChild(self.getHouseUpCloseMoment(size))
        
    }
    
    
    // MARK: Moments (not quite scenes!)
    func getHouseInTheDistanceMoment(parentSize: CGSize) -> SKNode {
        let houseInTheDistanceMoment = SKNode()
        
        let background = SKSpriteNode(imageNamed: "Background")
        background.position = CGPoint(x: parentSize.width/2, y:parentSize.height/2)
        background.size.height = parentSize.height
        houseInTheDistanceMoment.addChild(background)
        
        let ground = SKSpriteNode(imageNamed: "Ground")
        ground.size = CGSize(width: parentSize.width * 2, height: 300)
        ground.position = CGPoint(x: parentSize.width/2, y: 0)
        
        let house = SKSpriteNode(imageNamed: "House")
        house.setScale(3)
        house.position = CGPoint(x: parentSize.width - 20, y: ground.size.height/2)
        
        houseInTheDistanceMoment.addChild(ground)
        houseInTheDistanceMoment.addChild(house)
        
        return houseInTheDistanceMoment
    }
    
    func getHouseUpCloseMoment(parentSize: CGSize) -> SKNode {
        let houseUpCloseMoment = SKNode()
        
        let background = SKSpriteNode(imageNamed: "Background")
        background.position = CGPoint(x: parentSize.width/2, y:parentSize.height/2)
        background.size.height = parentSize.height
        background.size.width = parentSize.width * 2
        houseUpCloseMoment.addChild(background)
        
        let ground = SKSpriteNode(imageNamed: "Ground")
        ground.size = CGSize(width: parentSize.width, height: 250)
        ground.position = CGPoint(x: parentSize.width/2, y: 125)
        
        let house = SKSpriteNode(imageNamed: "House")
        house.setScale(4)
        house.position = CGPoint(x: parentSize.width/2, y: ground.size.height)
        
        houseUpCloseMoment.addChild(ground)
        houseUpCloseMoment.addChild(house)
        
        return houseUpCloseMoment
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Create Gesture Recognizers Here
    override func didMoveToView(view: SKView) {
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "didSwipeLeft")
        swipeLeftGestureRecognizer.direction = .Left
        self.view?.addGestureRecognizer(swipeLeftGestureRecognizer)
        
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "didSwipeRight")
        swipeRightGestureRecognizer.direction = .Right
        self.view?.addGestureRecognizer(swipeRightGestureRecognizer)
    }
    
    //Remove Gesture Recognizers
    override func willMoveFromView(view: SKView) {
        self.view?.gestureRecognizers?.removeAll(keepCapacity: false)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //touches
    }
    
    override func update(currentTime: CFTimeInterval) {
        //called every 60 seconds
    }

	
}
