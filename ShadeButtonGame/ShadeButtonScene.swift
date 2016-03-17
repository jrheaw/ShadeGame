//
//  ShadeButton.swift
//  ShadeButtonGame
//
//  Created by Jacob Wittenauer on 3/11/16.
//  Copyright © 2016 Jacob Wittenauer. All rights reserved.
//

import SpriteKit

class ShadeButtonScene: SKScene {

    var inCaseOfLabel: SKLabelNode?
    var shadeLabel: SKLabelNode?
    var menuLabel: SKLabelNode?
    
    var shadeButtonCircle: SKShapeNode?
    
    weak var menuScene: MenuScene?
   
    
    override func didMoveToView(view: SKView) {
        self.scene!.backgroundColor = UIColor(red: 234.0/255.0, green: 183.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        createAndPlaceInCaseOfShade()
        createAndPlaceGoBackToMenu()
        drawShadeButtonCircle()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.locationInNode(self)
            let nodeAtTouch = self.nodeAtPoint(touchPoint)
            if nodeAtTouch.name == "shadeThrown" {
                animateShadeButtonAndPlaySound(nodeAtTouch, touchPoint: touchPoint)
            } else if nodeAtTouch.name == "back" {
                presentMenuScene()
            }
        }
    }
    
    func createAndPlaceInCaseOfShade() {
        self.inCaseOfLabel = SKLabelNode(fontNamed: "Zapfino")
        self.inCaseOfLabel!.fontSize = 19
        self.inCaseOfLabel!.fontColor = UIColor.blackColor()
        self.inCaseOfLabel!.text = "IN CASE OF"
        self.inCaseOfLabel!.name = "incaseof"
        self.inCaseOfLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMaxY(self.scene!.frame) - (3 * self.inCaseOfLabel!.frame.height))
        addChild(self.inCaseOfLabel!)
        
        self.shadeLabel = SKLabelNode(fontNamed: "Marker Felt Wide")
        self.shadeLabel!.fontSize = 73
        self.shadeLabel!.fontColor = UIColor(red: 229.0/255.0, green: 64.0/255.0, blue: 117.0/255.0, alpha: 1.0)
        self.shadeLabel!.text = "SHADE"
        self.shadeLabel!.name = "shade"
        self.shadeLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: self.inCaseOfLabel!.position.y - (2 * self.inCaseOfLabel!.frame.height + 10))
        addChild(self.shadeLabel!)
    }
    
    func createAndPlaceGoBackToMenu() {
        self.menuLabel = SKLabelNode(fontNamed: "Marker Felt Wide")
        self.menuLabel!.fontSize = 15
        self.menuLabel!.fontColor = UIColor.grayColor()
        self.menuLabel!.text = "⬅︎ Back it up"
        self.menuLabel!.name = "back"
        self.menuLabel!.position = CGPoint(x: CGRectGetMinX(self.scene!.frame) + self.menuLabel!.frame.width/1.8, y: CGRectGetMaxY(self.scene!.frame) - self.menuLabel!.frame.height)
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
