//
//  Touchable.swift
//  The Red Sun Rises Over the Fields of Grain
//
//  Created by Charlie Imhoff on 4/24/15.
//  Copyright (c) 2015 Silo Games. All rights reserved.
//

import Foundation
import UIKit

@objc protocol Touchable {
	
    @objc optional func onTouchDownInside(touch: UITouch, sender: AnyObject?)
	
    @objc optional func onTouchUpInside(touch: UITouch, sender: AnyObject?)
	
    @objc optional func onTouchThroughInside(touch: UITouch, sender: AnyObject?)
	
}
