//
//  GameViewController.swift
//  The Red Sun Rises Over the Fields of Grain
//
//  Created by Graham Earley on 4/24/15.
//  Copyright (c) 2015 Silo Games. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
	
		let skView = self.view as! SKView
		
		if GameProfile.sharedInstance.committedMurder {
			let scene = FarmScene(size: skView.bounds.size)
            scene.scaleMode = .AspectFill
			skView.presentScene(scene)
		} else {
			let scene = MurderScene(size: skView.bounds.size)
			scene.scaleMode = .AspectFill
			skView.presentScene(scene)
		}
    }
    
    override var shouldAutorotate: Bool { false }
    override var prefersStatusBarHidden: Bool { true }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.Portrait
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
