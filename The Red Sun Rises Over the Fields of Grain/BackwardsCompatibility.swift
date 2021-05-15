//
//  BackwardsCompatibility.swift
//  The Red Sun Rises Over the Fields of Grain
//
//  Created by Charlie Imhoff on 5/15/21.
//  Copyright © 2021 Silo Games. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

/*
 This is bad Swift style, but this project was originally
 written in Swift 3, and a lot has changed since then.
 I'd like to minimize changes to the original source,
 since it was authored during a series of all-nighters,
 and the fact that it is outdated and ugly is part
 of its "roguish charm".
 */

// MARK - Operators

postfix operator ++
postfix func ++<T: BinaryInteger>(value: inout T) {
    return value += 1
}

postfix operator --
postfix func --<T: BinaryInteger>(value: inout T) {
    return value -= 1
}

// MARK - SpriteKit API Changes

extension SKAction {
    static func rotateByAngle(_ delta: CGFloat, duration: TimeInterval) -> some SKAction {
        return SKAction.rotate(byAngle: delta, duration: duration)
    }
    
    static func moveTo(_ dest: CGPoint, duration: TimeInterval) -> some SKAction {
        return SKAction.move(to: dest, duration: duration)
    }
    
    static func moveToY(_ y: CGFloat, duration: TimeInterval) -> some SKAction {
        return SKAction.moveTo(y: y, duration: duration)
    }
    
    static func moveToX(_ x: CGFloat, duration: TimeInterval) -> some SKAction {
        return SKAction.moveTo(x: x, duration: duration)
    }
    
    static func moveBy(_ vec: CGVector, duration: TimeInterval) -> some SKAction {
        return SKAction.move(by: vec, duration: duration)
    }
    
    static func moveByX(_ x: CGFloat, y: CGFloat, duration: TimeInterval) -> some SKAction {
        return SKAction.moveBy(x: x, y: y, duration: duration)
    }
    
    static func fadeInWithDuration(_ duration: TimeInterval) -> some SKAction {
        return SKAction.fadeIn(withDuration: duration)
    }
    
    static func fadeOutWithDuration(_ duration: TimeInterval) -> some SKAction {
        return SKAction.fadeOut(withDuration: duration)
    }
    
    static func waitForDuration(_ duration: TimeInterval) -> some SKAction {
        return SKAction.wait(forDuration: duration)
    }
    
    static func colorizeWithColor(_ color: SKColor, colorBlendFactor: CGFloat, duration: TimeInterval) -> some SKAction {
        return SKAction.colorize(with: color, colorBlendFactor: colorBlendFactor, duration: duration)
    }
    
    static func colorizeWithColorBlendFactor(_ blendFactor: CGFloat, duration: TimeInterval) -> some SKAction {
        return SKAction.colorize(withColorBlendFactor: blendFactor, duration: duration)
    }
    
    static func repeatActionForever(_ action: SKAction) -> some SKAction {
        return SKAction.repeatForever(action)
    }
    
    static func scaleTo(_ scaleForm: CGFloat, duration: TimeInterval) -> some SKAction {
        return SKAction.scale(to: scaleForm, duration: duration)
    }
    
    static func fadeAlphaTo(_ value: CGFloat, duration: TimeInterval) -> some SKAction {
        return SKAction.fadeAlpha(to: value, duration: duration)
    }
    
    static func fadeAlphaBy(_ delta: CGFloat, duration: TimeInterval) -> some SKAction {
        return SKAction.fadeAlpha(by: delta, duration: duration)
    }
    
    static func runBlock(_ block: @escaping () -> Void) -> some SKAction {
        return SKAction.run(block)
    }
}

extension SKNode {
    var hidden : Bool {
        get { return self.isHidden }
        set { self.isHidden = newValue }
    }
    
    func runAction(_ action: SKAction) {
        self.run(action)
    }
    
    func runAction(_ action: SKAction, _ completion: @escaping () -> Void) {
        self.run(action, completion: completion)
    }
    
    func childNodeWithName(_ name: String) -> SKNode? {
        return self.childNode(withName: name)
    }
    
    func nodesAtPoint(_ point: CGPoint) -> [SKNode] {
        return self.nodes(at: point)
    }
    
    func enumerateChildNodesWithName(_ namePattern: String, usingBlock block:  @escaping (SKNode, UnsafeMutablePointer<ObjCBool>) -> Void) {
        self.enumerateChildNodes(withName: namePattern, using: block)
    }
}

extension SKShapeNode {
    convenience init(rectOfSize: CGSize) {
        self.init(rectOf: rectOfSize)
    }
}

extension SKLightNode {
    var enabled : Bool {
        get { return self.isEnabled }
        set { self.isEnabled = newValue }
    }
}

extension SKTransition {
    static func crossFadeWithDuration(_ duration: TimeInterval) -> some SKTransition {
        return SKTransition.crossFade(withDuration: duration)
    }
}

extension SKLabelVerticalAlignmentMode {
    static var Center: SKLabelVerticalAlignmentMode { return .center }
}

extension SKSceneScaleMode {
    static var AspectFill: SKSceneScaleMode { return .aspectFill }
}

extension UITouch {
    func locationInNode(_ node: SKNode) -> CGPoint {
        return self.location(in: node)
    }
}

// MARK - UIKit API Changes

extension UIColor {
    static func orangeColor() -> UIColor {
        return UIColor.orange
    }
    
    static func yellowColor() -> UIColor {
        return UIColor.yellow
    }
    
    static func whiteColor() -> UIColor {
        return UIColor.white
    }
    
    static func blackColor() -> UIColor {
        return UIColor.black
    }
    
    static func grayColor() -> UIColor {
        return UIColor.gray
    }
    
    static func darkGrayColor() -> UIColor {
        return UIColor.darkGray
    }
    
    static func brownColor() -> UIColor {
        return UIColor.brown
    }
    
    static func redColor() -> UIColor {
        return UIColor.red
    }
    
    static func clearColor() -> UIColor {
        return UIColor.clear
    }
}

extension UIInterfaceOrientationMask {
    static var Portrait : Self { return .portrait }
    static var All : Self { return .all }
}

extension UISwipeGestureRecognizer.Direction {
    static var Left : Self { return .left }
    static var Right : Self { return .right }
    static var Up : Self { return .up }
    static var Down : Self { return .down }
}

// MARK - Internal API Bridge

extension Touchable {
    func onTouchDownInside(_ touch: UITouch, sender: AnyObject?) {
        self.onTouchDownInside?(touch: touch, sender: sender)
    }
    
    func onTouchUpInside(_ touch: UITouch, sender: AnyObject?) {
        self.onTouchUpInside?(touch: touch, sender: sender)
    }
    
    func onTouchThroughInside(_ touch: UITouch, sender: AnyObject?) {
        self.onTouchThroughInside?(touch: touch, sender: sender)
    }
}

// MARK - Standard Library API Changes

extension String {
    var lowercaseString : String {
        return self.lowercased()
    }
}

// MARK - C Functions no longer in Swift

var randomState : GKRandomSource = GKARC4RandomSource()
func srand(_ seed: Int) {
    var copiedBytesSeed = seed
    let dataStream = Data(bytes: &copiedBytesSeed, count: MemoryLayout.size(ofValue: copiedBytesSeed))
    randomState = GKARC4RandomSource(seed: dataStream)
}
func rand() -> Int {
    return randomState.nextInt()
}
