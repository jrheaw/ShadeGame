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

    var newGameLabel: SKLabelNode?
    var throwShadeLabel: SKLabelNode?
    var hideAdsLabel: SKLabelNode?
    
    let menuFontString = "Futura-CondensedMedium"
    let menuFontColorString = "#FFC0E4FF"
    let menuFontSize: CGFloat = 32
    
    override func didMoveToView(view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "shadeGameMain")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.size = self.frame.size
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)
        
        let menuPlacementNode = SKNode()
        self.addChild(menuPlacementNode)
        
        self.hideAdsLabel = SKLabelNode(fontNamed: menuFontString)
        self.hideAdsLabel!.fontSize = menuFontSize
        self.hideAdsLabel!.fontColor = SKColor(hexString: menuFontColorString)
        self.hideAdsLabel!.text = "Remove Ads"
        self.hideAdsLabel!.name = "hideAds"
        self.hideAdsLabel!.position = CGPointMake(menuPlacementNode.frame.width/2, 0)
        if !NSUserDefaults.standardUserDefaults().boolForKey("purchased") {
            menuPlacementNode.addChild(hideAdsLabel!)
        }
        
        self.throwShadeLabel = SKLabelNode(fontNamed: menuFontString)
        self.throwShadeLabel!.fontSize = menuFontSize
        self.throwShadeLabel!.fontColor = SKColor(hexString: menuFontColorString)
        self.throwShadeLabel!.name = "shade"
        self.throwShadeLabel!.text = "The Button"
        self.throwShadeLabel!.position = CGPointMake(menuPlacementNode.frame.width/2, hideAdsLabel!.frame.height * 2)
        menuPlacementNode.addChild(throwShadeLabel!)
        
        self.newGameLabel = SKLabelNode(fontNamed: menuFontString)
        self.newGameLabel!.fontSize = menuFontSize
        self.newGameLabel!.fontColor = SKColor(hexString: menuFontColorString)
        self.newGameLabel!.name = "new"
        self.newGameLabel!.text = "Play Game"
        self.newGameLabel!.position = CGPointMake(menuPlacementNode.frame.width/2, hideAdsLabel!.frame.height * 2 + throwShadeLabel!.frame.height * 2)
        menuPlacementNode.addChild(newGameLabel!)
        menuPlacementNode.position = CGPointMake(size.width * 0.5, 75)
        
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
            } else if nodeAtTouch.name == "hideAds" {
                let controller = self.view?.window?.rootViewController as! GameViewController
                controller.hideAds(self)
            }
        }
    }
    
    func presentLevelSelectScene() {
        let transition = SKTransition.moveInWithDirection(.Right, duration: 0.6)
        self.view?.presentScene(levelSelectScene, transition: transition)
    }
    
    func presentShadeScene() {
        let transition = SKTransition.moveInWithDirection(.Right, duration: 0.6)
        self.view?.presentScene(shadeScene, transition: transition)
    }
}
