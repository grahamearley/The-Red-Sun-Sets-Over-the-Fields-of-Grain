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

		// Configure the view.
		let skView = self.view as! SKView
		skView.ignoresSiblingOrder = true
		
		let scene : SKScene
        // testing: just show my scene instead of the real first scene
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

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
