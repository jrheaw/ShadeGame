//
//  GameScene.swift
//  ShadeButtonGame
//
//  Created by Jacob Wittenauer on 3/10/16.
//  Copyright (c) 2016 Jacob Wittenauer. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    weak var levelSelectScene: LevelSelectScene?
    
    var levelSelectLabel: SKLabelNode?
    var levelLabel: SKLabelNode!
    
    var shadeGems: [[ShadeGem?]] = []
    
    var shadeButtonGame: ShadeButtonGame?
    
    var gameStarted = false
    var levelWon = false
    var level: Int = 1
    
    override func didMoveToView(view: SKView) {
        if !gameStarted {
            self.scene!.backgroundColor = UIColor(red: 234.0/255.0, green: 183.0/255.0, blue: 233.0/255.0, alpha: 1.0)
            createAndPlaceGoBackToMenu()
            createAndPlaceLevelLabel()
            
            shadeButtonGame = ShadeButtonGame(level: level)
            
            let shadeGemRow = [ShadeGem?] (count: 5, repeatedValue: nil)
            shadeGems = [[ShadeGem?]] (count: 5, repeatedValue: shadeGemRow)
            
            var buttonSize = 64
            
            if ((Int(CGRectGetMaxX(self.scene!.frame)) - (buttonSize * 5))/2) <= 5 {
                buttonSize = 55
            }
            
            let initialY = (Int(CGRectGetMaxY(self.scene!.frame)) + (buttonSize * 5))/2 - (buttonSize/2)
            let initialX = (Int(CGRectGetMaxX(self.scene!.frame)) - (buttonSize * 5))/2 + (buttonSize/2)
        
            for i in 0 ..< 5 {
                for j in 0 ..< 5 {
                    let point = CGPoint(x: initialX + (i * buttonSize), y: initialY - (j * buttonSize))
                    let gem = ShadeGem()
                    gem.configureAtPosition(point, size: buttonSize, row: i, column: j, buttonState: shadeButtonGame!.getButtonStateAtPosition(i,j))
                    shadeGems[i][j] = gem
                    addChild(gem)
                }
            }
        }
        gameStarted = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            let nodes = nodesAtPoint(location)
            
            for node in nodes {
                if node.name == "shadeGem" && !levelWon {
                    let touchedGem = node.parent as! ShadeGem
                    print("Gem touched at \(touchedGem.row!) \(touchedGem.row!)")
                    shadeButtonGame!.buttonPressedAtLocation(row: touchedGem.row!, col: touchedGem.column!)
                    refreshNodes()
                    checkForWin()
                } else if node.name == "back" {
                    presentMenuScene()
                } else if node.name == "next" {
                    presentNextLevel()
                }
            }
            
        }
        
    }
    
    func refreshNodes() {
        for i in 0 ..< 5 {
            for j in 0 ..< 5 {
                shadeGems[i][j]?.changeState(shadeButtonGame!.getButtonStateAtPosition(i,j))
            }
        }
    }
    
    func checkForWin() {
        if shadeButtonGame!.hasWon() {
            NSUserDefaults.standardUserDefaults().setInteger(level, forKey: "HighestLevelWon")
            levelWon = true
            let youWinLabel = SKLabelNode(fontNamed: "Marker Felt Wide")
            youWinLabel.fontSize = 52
            youWinLabel.fontColor = UIColor(red: 229.0/255.0, green: 64.0/255.0, blue: 117.0/255.0, alpha: 1.0)
            youWinLabel.text = "YAS KWEEN"
            youWinLabel.name = "win"
            youWinLabel.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMaxY(self.scene!.frame) + youWinLabel.frame.height)
            youWinLabel.zPosition = 100
            youWinLabel.alpha = 0
            addChild(youWinLabel)
            
            let nextLevel = SKLabelNode(fontNamed: "Zapfino")
            nextLevel.fontSize = 19
            nextLevel.fontColor = UIColor.blackColor()
            nextLevel.text = "Touch Me for Next Level"
            nextLevel.name = "next"
            nextLevel.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMinY(self.scene!.frame) - nextLevel.frame.height)
            nextLevel.zPosition = 100
            nextLevel.alpha = 0
            addChild(nextLevel)
            
            let fadeInAction = SKAction.fadeAlphaTo(1, duration: 1)
            let bringDownActionYouWin = SKAction.moveToY(CGRectGetMidY(self.scene!.frame), duration: 1)
            let bringUpActionNextLevel = SKAction.moveToY(CGRectGetMinY(self.scene!.frame) + nextLevel.frame.height, duration: 1)
            youWinLabel.runAction(SKAction.group([fadeInAction, bringDownActionYouWin]))
            nextLevel.runAction(SKAction.group([fadeInAction, bringUpActionNextLevel]))
            runAction(SKAction.playSoundFileNamed("shade.mp3", waitForCompletion:false))
        }
    }
    
    func createAndPlaceGoBackToMenu() {
        self.levelLabel = SKLabelNode(fontNamed: "Marker Felt Wide")
        self.levelLabel!.fontSize = 15
        self.levelLabel!.fontColor = UIColor.grayColor()
        self.levelLabel!.text = "⬅︎ Level Select"
        self.levelLabel!.name = "back"
        self.levelLabel!.position = CGPoint(x: CGRectGetMinX(self.scene!.frame) + self.levelLabel!.frame.width/1.8, y: CGRectGetMaxY(self.scene!.frame) - self.levelLabel!.frame.height)
        addChild(self.levelLabel!)
    }
    
    func createAndPlaceLevelLabel() {
        levelLabel = SKLabelNode(fontNamed: "Zapfino")
        var levelText = "\(level)"
        if(level <= 1) {
            levelText = "Basic"
        } else if (level >= 6) {
            levelText = "So Random"
        }
        levelLabel.text = "Level: " + levelText
        levelLabel.fontSize = 19
        levelLabel.fontColor = UIColor(red: 229.0/255.0, green: 64.0/255.0, blue: 117.0/255.0, alpha: 1.0)
        levelLabel.position = CGPoint(x: CGRectGetMaxX(self.scene!.frame)/2, y: CGRectGetMaxY(self.scene!.frame) - levelLabel.frame.height * 2)
        addChild(levelLabel)
    }
    
    
    
    func presentMenuScene() {
        let transition = SKTransition.fadeWithColor(UIColor.purpleColor(), duration: 0.6)
        if let scene = levelSelectScene {
            self.view?.presentScene(scene, transition: transition)
        } else {
            let scene = LevelSelectScene()
            scene.scaleMode = .AspectFill
            scene.size = self.view!.bounds.size
            scene.gameScene = self
            self.view?.presentScene(scene, transition: transition)
        }
    }
    
    func presentNextLevel() {
        let gameScene = GameScene()
        gameScene.level = ++level
        gameScene.scaleMode = .AspectFill
        gameScene.size = self.view!.bounds.size
        let transition = SKTransition.fadeWithColor(UIColor.purpleColor(), duration: 1.0)
        self.view?.presentScene(gameScene, transition: transition)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

}
