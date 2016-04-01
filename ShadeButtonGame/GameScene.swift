//
//  GameScene.swift
//  ShadeButtonGame
//
//  Created by Jacob Wittenauer on 3/10/16.
//  Copyright (c) 2016 Jacob Wittenauer. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let fontString = "Futura-CondensedMedium"
    let fontColorString = "#FF007AFF"//"#FFC0E4FF"
    
    let backgroundColorString = "#FFC0E4FF"//"#FF007AFF"
    
    weak var levelSelectScene: LevelSelectScene?
    
    var levelSelectLabel: SKLabelNode?
    var levelLabel: SKLabelNode!
    
    var howToNode: SKSpriteNode?
    var info: GameInfoLabel?
    var title: SKLabelNode?
    
    var score: SKLabelNode?
    
    var shadeGems: [[ShadeGem?]] = []
    
    var shadeButtonGame: ShadeButtonGame?
    
    var gameStarted = false
    var levelWon = false
    var level: Int = 1
    var howToPresented = false
    var soundOff = false
    
    override func didMoveToView(view: SKView) {
        soundOff = NSUserDefaults.standardUserDefaults().boolForKey("soundOff")
        if !gameStarted {
            self.scene!.backgroundColor = SKColor(hexString: backgroundColorString)!
            createAndPlaceGoBackToMenu()
            createAndPlaceLevelLabel()
            createAndPlaceRestartLevel()
            
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
            
            score = SKLabelNode(fontNamed: fontString)
            score?.fontColor = SKColor(hexString: fontColorString)
            score!.fontSize = 28
            score!.text = "\(shadeButtonGame!.numClicks) (\(shadeButtonGame!.clicksToWin))"
            score?.position = CGPoint(x: CGRectGetMaxX(self.scene!.frame) - CGFloat(buttonSize), y: CGFloat(initialY - (buttonSize * 5)))
            
            addChild(score!)
        }
        gameStarted = true
        if(level == 1) {
            howToPresented = true
            presentHowTo()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(howToPresented) {
            info?.removeFromSuperview()
            howToNode?.removeFromParent()
            title?.removeFromParent()
            howToPresented = false
            return
        }
        if levelWon {
            if(shadeButtonGame!.beatLevel()) {
                presentNextLevel()
            } else {
                presentLevel(level)
            }
        }
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            let nodes = nodesAtPoint(location)
            
            for node in nodes {
                if node.name == "shadeGem" && !levelWon {
                    let touchedGem = node.parent as! ShadeGem
                    shadeButtonGame!.buttonPressedAtLocation(row: touchedGem.row!, col: touchedGem.column!)
                    if(!soundOff) {
                        runAction(SKAction.playSoundFileNamed("switch\(touchedGem.shadeSound!).wav", waitForCompletion:false))
                    }
                    refreshNodes()
                    checkForWin()
                } else if node.name == "back" {
                    presentMenuScene()
                } else if node.name == "restart" {
                    presentLevel(level)
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
        score!.text = "\(shadeButtonGame!.numClicks) (\(shadeButtonGame!.clicksToWin))"
    }
    
    func checkForWin() {
        if shadeButtonGame!.hasWon() {
            if(NSUserDefaults.standardUserDefaults().integerForKey("HighestLevelWon") < level && level <= 10) {
                NSUserDefaults.standardUserDefaults().setInteger(level, forKey: "HighestLevelWon")
            }
            levelWon = true
            let youWinLabel = SKLabelNode(fontNamed: fontString)
            youWinLabel.fontSize = 52
            youWinLabel.fontColor = SKColor(hexString: fontColorString)
            youWinLabel.text = shadeButtonGame!.beatLevel() ? "Yas!" : "Almost!"
            youWinLabel.name = "win"
            youWinLabel.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMaxY(self.scene!.frame) + youWinLabel.frame.height)
            youWinLabel.zPosition = 100
            youWinLabel.alpha = 0
            addChild(youWinLabel)
            
            
            let nextLevel = SKLabelNode(fontNamed: fontString)
            nextLevel.fontSize = 19
            nextLevel.fontColor = SKColor(hexString: fontColorString)
            nextLevel.text = shadeButtonGame!.beatLevel() ? "Touch for Next Level" : "Touch to Retry Level"
            nextLevel.name = "next"
            nextLevel.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMinY(self.scene!.frame) - nextLevel.frame.height)
            nextLevel.zPosition = 100
            nextLevel.alpha = 0
            addChild(nextLevel)
            
            let fadeInAction = SKAction.fadeAlphaTo(1, duration: 1)
            let bringDownActionYouWin = SKAction.moveToY(levelLabel.position.y - youWinLabel.frame.height * 2 - 8, duration: 1)
            let bringUpActionNextLevel = SKAction.moveToY(CGRectGetMinY(self.scene!.frame) + nextLevel.frame.height + 60, duration: 1)
            nextLevel.runAction(SKAction.group([fadeInAction, bringUpActionNextLevel]))
            youWinLabel.runAction(SKAction.group([fadeInAction, bringDownActionYouWin]))
            if(!soundOff) {
                runAction(SKAction.playSoundFileNamed("shade.mp3", waitForCompletion:false))
            }


        }
    }
    
    func createAndPlaceGoBackToMenu() {
        self.levelLabel = SKLabelNode(fontNamed: fontString)
        self.levelLabel!.fontSize = 23
        self.levelLabel!.fontColor = SKColor(hexString: fontColorString)
        self.levelLabel!.text = "Level Select"
        self.levelLabel!.name = "back"
        self.levelLabel!.position = CGPoint(x: CGRectGetMinX(self.scene!.frame) + self.levelLabel!.frame.width/1.8, y: CGRectGetMaxY(self.scene!.frame) - self.levelLabel!.frame.height)
        addChild(self.levelLabel!)
    }
    
    func createAndPlaceRestartLevel() {
        self.levelLabel = SKLabelNode(fontNamed: fontString)
        self.levelLabel!.fontSize = 23
        self.levelLabel!.fontColor = SKColor(hexString: fontColorString)
        self.levelLabel!.text = "Restart"
        self.levelLabel!.name = "restart"
        self.levelLabel!.position = CGPoint(x: CGRectGetMaxX(self.scene!.frame) - self.levelLabel!.frame.width/1.8, y: CGRectGetMaxY(self.scene!.frame) - self.levelLabel!.frame.height)
        addChild(self.levelLabel!)
    }
    
    func createAndPlaceLevelLabel() {
        levelLabel = SKLabelNode(fontNamed: fontString)
        var levelText = "\(level)"
        if(level <= 1) {
            levelText = "Basic"
        } else if (level >= 11) {
            levelText = "So Random"
        }
        levelLabel.text = "Level: " + levelText
        levelLabel.fontSize = 36
        levelLabel.fontColor = SKColor(hexString: fontColorString)
        levelLabel.position = CGPoint(x: CGRectGetMaxX(self.scene!.frame)/2, y: CGRectGetMaxY(self.scene!.frame) - levelLabel.frame.height * 2)
        addChild(levelLabel)
    }
    
    
    
    func presentMenuScene() {
        let transition = SKTransition.fadeWithColor(SKColor(hexString: backgroundColorString)!, duration: 0.6)
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
        if(level > 100) {
            presentLevel(101) //100 = random easy, 101 = random hard
        } else if (level + 1 > 10) {
            presentLevel(100)
        } else {
            presentLevel(level+1)
        }
    }
    
    func presentLevel(level: Int) {
        let gameScene = GameScene()
        gameScene.level = level
        gameScene.scaleMode = .AspectFill
        gameScene.size = self.view!.bounds.size
        let transition = SKTransition.fadeWithColor(UIColor.purpleColor(), duration: 0.6)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    func presentHowTo() {
        howToNode = SKSpriteNode(color:SKColor.whiteColor(), size: CGSize(width: self.scene!.frame.width/1.4, height: self.scene!.frame.height/1.8))
        howToNode!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidY(self.scene!.frame))
        howToNode!.zPosition = 200
        
        
        title = SKLabelNode(fontNamed: fontString)
        title!.text = "How To Play"
        title!.fontColor = SKColor(hexString: backgroundColorString)
        title!.fontSize = 24
        title!.position = CGPoint(x: CGRectGetMidX(howToNode!.frame), y: CGRectGetMaxY(howToNode!.frame) - title!.frame.height * 1.8)
        title!.zPosition = 201
        self.addChild(title!)
        
        
        
        info = GameInfoLabel(frame: howToNode!.frame)
        info!.text = "\n・Touch to shade a square's light\n・Touching a square will flip it and its four adjacent squares' color\n・A yellow square needs to be shaded if it has a darkened border\n・Complete the level in the specified number of touches to move on!"
        info!.textAlignment = .Left
        
        info!.lineBreakMode = .ByWordWrapping
        info!.numberOfLines = 12
        info!.textColor = UIColor.blackColor()
        //info!.center = CGPointMake(CGRectGetMidX(self.scene!.frame),CGRectGetMidY(self.scene!.frame))
        info!.layer.borderColor = UIColor.purpleColor().CGColor
        info!.layer.borderWidth = 3.0
        
        if CGRectIntersectsRect(info!.frame, title!.frame) {
            title!.fontSize = 20
            title!.position = CGPoint(x: CGRectGetMidX(howToNode!.frame), y: CGRectGetMaxY(howToNode!.frame) - title!.frame.height * 1.4)
        }
        
        self.view?.addSubview(info!)
        self.addChild(howToNode!)
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

}

class GameInfoLabel : UILabel {
    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}
