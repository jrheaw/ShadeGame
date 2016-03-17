//
//  Button.swift
//  ShadeButtonGame
//
//  Created by Jacob Wittenauer on 3/10/16.
//  Copyright © 2016 Jacob Wittenauer. All rights reserved.
//

import SpriteKit
import UIKit
import Foundation

class ShadeGem: SKNode {
    
    var row: Int?
    var column: Int?
    
    func configureAtPosition(pos: CGPoint, size: Int, row: Int, column: Int, buttonState: ButtonState) {
        self.row = row
        self.column = column
        position = pos
        let sprite = SKSpriteNode(imageNamed: "element_\(buttonState.rawValue.lowercaseString)_square")
        sprite.size = CGSize(width: size, height: size)
        sprite.name = "shadeGem"
        addChild(sprite)
    }
    
    func changeState(buttonState: ButtonState) {
        let sprite = self.children.first as! SKSpriteNode
        sprite.texture = SKTexture(imageNamed: "element_\(buttonState.rawValue.lowercaseString)_square")
    }
}
