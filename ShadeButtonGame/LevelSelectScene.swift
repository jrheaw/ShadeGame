//
//  LevelSelectScene.swift
//  ShadeButtonGame
//
//  Created by Jacob Wittenauer on 3/16/16.
//  Copyright © 2016 Jacob Wittenauer. All rights reserved.
//

import SpriteKit

class LevelSelectScene: SKScene {
    
    var menuLabel: SKSpriteNode?
    var muteButton: SKSpriteNode?
    var gameScene = GameScene()
    var hightestLevelUnlocked = 0
    weak var menuScene: MenuScene?
    
    let fontString = "Futura-CondensedMedium"
    let fontColorString = "#FFC0E4FF"
    
    let backgroundColorString = "#FF007AFF"
    
    override func didMoveToView(view: SKView) {
        self.scene!.backgroundColor = SKColor(hexString: backgroundColorString)!
        createAndPlaceMute()
        
        createAndPlaceGoBackToMenu()
        
        hightestLevelUnlocked = NSUserDefaults.standardUserDefaults().integerForKey("HighestLevelWon")
        
        var levelsCount = 0
        if let levelsFilePath = NSBundle.mainBundle().pathForResource("levels", ofType: "txt") {
            if let levelsContents = try? String(contentsOfFile: levelsFilePath, usedEncoding: nil) {
                let lines = levelsContents.componentsSeparatedByString("\n")
                levelsCount = lines.count/3
            }
        }
        // Setup layout node
        let layoutNode = SKNode()
        self.addChild(layoutNode)
        
        let title = SKLabelNode(fontNamed: fontString)
        title.text = "Select Level"
        title.fontColor = SKColor(hexString: fontColorString)
        title.fontSize = 32
        title.position = CGPointMake(size.width * 0.5, size.height - 90)
        self.addChild(title)
        
        
        // Add button for levels
        for i in 0 ..< levelsCount {
            let levelButton = SKLabelNode(fontNamed: fontString)
            levelButton.text = "\(i+1)"
            levelButton.name = "\(i+1)"
            levelButton.fontSize = 40
            levelButton.fontColor = SKColor(hexString: fontColorString)
            
            let maxSize = max(levelButton.frame.width, levelButton.frame.height)
            
            let levelButtonNode = SKSpriteNode(color: SKColor(hexString:backgroundColorString)!, size: CGSize(width: maxSize, height: maxSize))
            levelButtonNode.addChild(levelButton)
            levelButtonNode.name = "\(i+1)"
            
            if(i > hightestLevelUnlocked) {
                levelButton.fontColor = SKColor(hexString: "#ff80c8ff")
            }
            
            levelButtonNode.position = CGPointMake(CGFloat((i%5 - 1) * 65), CGFloat((-i/5) * 65))
            layoutNode.addChild(levelButtonNode)
        }
        
        let layoutFrame: CGRect = layoutNode.calculateAccumulatedFrame()
        layoutNode.position = CGPointMake(size.width * 0.5 - (layoutFrame.size.width * 0.5) - layoutFrame.origin.x, size.height - 170)
        
        
        
        if hightestLevelUnlocked >= 10 {
            let randomLayoutNode = SKNode()
            self.addChild(randomLayoutNode)
            let randomLabel = SKLabelNode(fontNamed: fontString)
            randomLabel.text = "Random"
            randomLabel.fontSize = 32
            randomLabel.fontColor = SKColor(hexString: fontColorString)
            randomLabel.position = CGPointMake(size.width * 0.5, size.height - (layoutFrame.height + 120 + title.frame.height + randomLabel.frame.height))
            
            let randomEasy = SKLabelNode(fontNamed: fontString)
            randomEasy.text = "Easy"
            randomEasy.name = "100"
            randomEasy.fontSize = 40
            randomEasy.position = CGPointMake(0, 0)
            randomEasy.fontColor = SKColor(hexString: fontColorString)
            //srandomEasy.fontColor = SKColor.blackColor()
            
            let randomHard = SKLabelNode(fontNamed: fontString)
            randomHard.text = "Hard"
            randomHard.name = "101"
            randomHard.fontSize = 40
            randomHard.position = CGPointMake(randomEasy.frame.width + 57, 0)
            randomHard.fontColor = SKColor(hexString: fontColorString)
        
            
            addChild(randomLabel)
            randomLayoutNode.addChild(randomEasy)
            randomLayoutNode.addChild(randomHard)
            
            let randomLayoutFrame: CGRect = randomLayoutNode.calculateAccumulatedFrame()
            randomLayoutNode.position = CGPointMake(size.width * 0.5 - (randomLayoutFrame.size.width * 0.5) - randomLayoutFrame.origin.x, size.height - (layoutFrame.height + 120 + title.frame.height + randomLabel.frame.height + randomEasy.frame.height))
            
        }
        
        

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let nodeAtTouch = self.nodeAtPoint(touch.locationInNode(self))
            if nodeAtTouch.name == "back" {
                presentMenuScene()
            } else if nodeAtTouch.name == "mute" {
                let soundOff = NSUserDefaults.standardUserDefaults().boolForKey("soundOff")
                NSUserDefaults.standardUserDefaults().setBool(!soundOff, forKey: "soundOff")
                print("setting sound is off to be \(!soundOff)")
                let texture = soundOff ? SKTexture(imageNamed: "audioOn") : SKTexture(imageNamed: "audioOff")
                muteButton!.texture = texture
            } else if let levelString = nodeAtTouch.name {
                if let level = Int(levelString) {
                    if level <= hightestLevelUnlocked + 1 || level == 100 || level == 101 {
                        presentGameScene(level)
                    }
                }
            }
        }
    }
    
    func createAndPlaceGoBackToMenu() {
        self.menuLabel = SKSpriteNode(imageNamed: "arrowLeft")
        self.menuLabel!.name = "back"
        self.menuLabel!.position = CGPoint(x: CGRectGetMinX(self.scene!.frame) + self.menuLabel!.frame.width/1.8, y: CGRectGetMaxY(self.scene!.frame) - self.menuLabel!.frame.height/2)
        addChild(self.menuLabel!)
    }
    
    func presentGameScene(level: Int) {
        let transition = SKTransition.fadeWithColor(UIColor.purpleColor(), duration: 0.6)
        if(gameScene.level != level) {
            gameScene = GameScene()
        }
        gameScene.size = self.view!.bounds.size
        gameScene.scaleMode = .AspectFill
        gameScene.level = level
        gameScene.levelSelectScene = self
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    func createAndPlaceMute() {
        let soundOff = NSUserDefaults.standardUserDefaults().boolForKey("soundOff")
        muteButton = soundOff ? SKSpriteNode(imageNamed: "audioOff") : SKSpriteNode(imageNamed: "audioOn")
        muteButton!.name = "mute"
        muteButton!.position = CGPoint(x: CGRectGetMaxX(self.scene!.frame) - muteButton!.frame.width/1.8, y: CGRectGetMaxY(self.scene!.frame) - muteButton!.frame.height/2)
        addChild(muteButton!)
    }
    
    func presentMenuScene() {
        let transition = SKTransition.moveInWithDirection(.Left, duration: 0.6)
        if let scene = menuScene {
            self.view?.presentScene(scene, transition: transition)
        } else {
            let scene = MenuScene()
            scene.scaleMode = .AspectFill
            scene.size = self.view!.bounds.size
            self.view?.presentScene(scene, transition: transition)
        }
        
    }
}
