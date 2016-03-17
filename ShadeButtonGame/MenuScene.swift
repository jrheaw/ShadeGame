//
//  MenuScene.swift
//  ShadeButtonGame
//
//  Created by Jacob Wittenauer on 3/11/16.
//  Copyright © 2016 Jacob Wittenauer. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {

    var shadeScene = ShadeButtonScene()
    var levelSelectScene = LevelSelectScene()
    
    var titleLabel: SKLabelNode?
    var newGameLabel: SKLabelNode?
    var throwShadeLabel: SKLabelNode?
    
    override func didMoveToView(view: SKView) {
        self.scene!.backgroundColor = UIColor(red: 234.0/255.0, green: 183.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        
        self.titleLabel = SKLabelNode(fontNamed: "Zapfino")
        self.newGameLabel = SKLabelNode(fontNamed: "Marker Felt Wide")
        self.throwShadeLabel = SKLabelNode(fontNamed: "Marker Felt Wide")
        
        self.titleLabel!.fontSize = 42
        self.newGameLabel!.fontSize = 22
        self.throwShadeLabel!.fontSize = 22
        
        self.titleLabel!.fontColor = UIColor.purpleColor()
        self.newGameLabel!.fontColor = UIColor.purpleColor()
        self.throwShadeLabel!.fontColor = UIColor.purpleColor()
        
        self.titleLabel!.text = "Shade Game"
        self.newGameLabel!.text = "Play the game"
        self.throwShadeLabel!.text = "Throw some shade"
        
        self.titleLabel!.name = "title"
        self.newGameLabel!.name = "new"
        self.throwShadeLabel!.name = "shade"
        
        self.titleLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidY(self.scene!.frame))
        self.newGameLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidY(self.scene!.frame) - 1.5 * titleLabel!.frame.height)
        self.throwShadeLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidY(self.scene!.frame) - 1.5 * titleLabel!.frame.height - 2.5 * newGameLabel!.frame.height )
        
        
        self.addChild(self.titleLabel!)
        self.addChild(self.newGameLabel!)
        self.addChild(self.throwShadeLabel!)
        
        
        shadeScene.size = self.view!.bounds.size
        shadeScene.scaleMode = .AspectFill
        shadeScene.menuScene = self

        levelSelectScene.scaleMode = .AspectFill
        levelSelectScene.size = self.view!.bounds.size
        levelSelectScene.menuScene = self
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let nodeAtTouch = self.nodeAtPoint(touch.locationInNode(self))
            if nodeAtTouch.name == "new" {
                presentLevelSelectScene()
            } else if nodeAtTouch.name == "shade" {
                presentShadeScene()
            }
        }
    }
    
    func presentPickLevel() {
        
    }
    
    func presentLevelSelectScene() {
        let transition = SKTransition.moveInWithDirection(.Right, duration: 0.6)
        self.view?.presentScene(levelSelectScene, transition: transition)
    }
    
    func presentShadeScene() {
        let transition = SKTransition.fadeWithColor(UIColor.purpleColor(), duration: 0.6)
        self.view?.presentScene(shadeScene, transition: transition)
    }
}
