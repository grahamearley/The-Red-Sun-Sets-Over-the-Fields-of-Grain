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
        
        self.addChild(self.getHouseInTheDistanceMoment(size))
//        self.addChild(self.getHouseUpCloseMoment(size))
        
    }
    
    // MARK: Moments
    // (not quite scenes!)
    func getHouseInTheDistanceMoment(parentSize: CGSize) -> SKNode {
        let houseInTheDistanceMoment = SKNode()
        
        let ground = SKSpriteNode(imageNamed: "groundtest")
        ground.size = CGSize(width: parentSize.width, height: 200)
        ground.position = CGPoint(x: parentSize.width/2, y: 200)
        
        let sun = SKShapeNode(circleOfRadius: 30)
        
        let houseSize = CGSize(width: 75, height: 50)
        let house = SKShapeNode(rect: CGRect(origin: CGPoint(x: size.width-houseSize.width-10, y: 75), size: houseSize))
        
        sun.fillColor = SKColor.yellowColor()
        sun.position = CGPoint(x: size.width/4, y: 3/4*size.height)
        
        houseInTheDistanceMoment.addChild(ground)
        houseInTheDistanceMoment.addChild(sun)
        
        return houseInTheDistanceMoment
    }
    
    func getHouseUpCloseMoment(parentSize: CGSize) -> SKNode {
        let houseUpClose = SKNode()
        
        let ground = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: size.width, height: 75)))
        ground.fillColor = SKColor.brownColor()

        let houseSize = CGSize(width: 150, height: 100)
        let house = SKShapeNode(rect: CGRect(origin: CGPoint(x: size.width/2, y: 75), size: houseSize))

        houseUpClose.addChild(ground)
        houseUpClose.addChild(house)

        return houseUpClose
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
