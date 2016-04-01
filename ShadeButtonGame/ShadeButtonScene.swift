//
//  ShadeButton.swift
//  ShadeButtonGame
//
//  Created by Jacob Wittenauer on 3/11/16.
//  Copyright © 2016 Jacob Wittenauer. All rights reserved.
//

import SpriteKit

class ShadeButtonScene: SKScene {

    var menuLabel: SKSpriteNode?
    
    var shadeButtonCircle: SKShapeNode?
    
    var shadeButton: SKSpriteNode?
    
    weak var menuScene: MenuScene?
   
    
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "shadeButtonBackground")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.size = self.frame.size
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)
        
        createAndPlaceGoBackToMenu()
        
        shadeButton = SKSpriteNode(imageNamed: "shadebutton")
        shadeButton?.anchorPoint = CGPointMake(0.5, 0)
        shadeButton?.position = CGPointMake(frame.midX, 75)
        shadeButton?.name = "shadeThrown"
        if shadeButton?.frame.width > self.frame.width {
            shadeButton?.size = CGSize(width: self.frame.width - 8, height: shadeButton!.frame.height * ((self.frame.width - 8)/shadeButton!.frame.width))
        }
        addChild(shadeButton!)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.locationInNode(self)
            let nodeAtTouch = self.nodeAtPoint(touchPoint)
            if nodeAtTouch.name == "shadeThrown" {
                shadeButton?.texture = SKTexture(imageNamed: "shadebutton_pressed")
            } else if nodeAtTouch.name == "back" {
                presentMenuScene()
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.locationInNode(self)
            let nodeAtTouch = self.nodeAtPoint(touchPoint)
            if nodeAtTouch.name == "shadeThrown" {
                runAction(SKAction.playSoundFileNamed("shade.mp3", waitForCompletion:false))
                shadeButton?.texture = SKTexture(imageNamed: "shadebutton")
            } else if nodeAtTouch.name == "back" {
                presentMenuScene()
            }
        }
    }
    
    func createAndPlaceGoBackToMenu() {
        self.menuLabel = SKSpriteNode(imageNamed: "arrowLeft")
        self.menuLabel!.name = "back"
        self.menuLabel!.position = CGPoint(x: CGRectGetMinX(self.scene!.frame) + self.menuLabel!.frame.width/1.8, y: CGRectGetMaxY(self.scene!.frame) - self.menuLabel!.frame.height/2)
        addChild(self.menuLabel!)
    }
    
    func drawShadeButtonCircle(){
        shadeButtonCircle = SKShapeNode(circleOfRadius: 100 )
        shadeButtonCircle!.position = CGPointMake(frame.midX, frame.midY)
        shadeButtonCircle!.strokeColor = SKColor(red: 150/255.0, green: 21/255.0, blue: 67/255.0, alpha: 1.0)
        shadeButtonCircle!.fillColor = SKColor(red: 180.0/255.0, green: 25.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        shadeButtonCircle!.glowWidth = 2
        shadeButtonCircle!.name = "shadeThrown"
        self.addChild(shadeButtonCircle!)
    }
    
    func animateShadeButtonAndPlaySound(shadeButton: SKNode, touchPoint: CGPoint) {
        // math to find distance of touch point from center
        let touchDistanceFromCenter = sqrt(pow(shadeButton.position.x - touchPoint.x, 2) + pow(shadeButton.position.y - touchPoint.y, 2))
        // math to find out if touch point is in the circle
        if(touchDistanceFromCenter < shadeButton.frame.size.width/2) {
            runAction(SKAction.playSoundFileNamed("shade.mp3", waitForCompletion:false))
            let increaseAction = SKAction.scaleTo(1.2, duration: 0.5)
            let decreaseAction = SKAction.scaleTo(1.0, duration: 1.3)
            decreaseAction.timingMode = .EaseOut
            shadeButton.runAction(SKAction.sequence([increaseAction, decreaseAction]))
            
        }
    }
    
    func presentMenuScene() {
        let transition = SKTransition.moveInWithDirection(.Left, duration: 0.6)
        if let scene = menuScene {
            self.view?.presentScene(scene, transition: transition)
        } else {
            let scene = MenuScene()
            scene.scaleMode = .AspectFill
            scene.size = self.view!.bounds.size
            scene.shadeScene = self
            self.view?.presentScene(scene, transition: transition)
        }
        
    }
}
