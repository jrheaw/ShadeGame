//
//  LevelSelectScene.swift
//  ShadeButtonGame
//
//  Created by Jacob Wittenauer on 3/16/16.
//  Copyright © 2016 Jacob Wittenauer. All rights reserved.
//

import SpriteKit

class LevelSelectScene: SKScene {
    
    var menuLabel: SKLabelNode?
    var muteButton: SKSpriteNode?
    var gameScene = GameScene()
    var hightestLevelUnlocked = 0
    weak var menuScene: MenuScene?
    
    override func didMoveToView(view: SKView) {
        self.scene!.backgroundColor = SKColor(red: 234.0/255.0, green: 183.0/255.0, blue: 233.0/255.0, alpha: 1.0)
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
        
        //let buttonDisabledTexture = SKTexture(imageNamed: "LevelLocked")
        //var levelUnlocked = NSUserDefaults.standardUserDefaults().integerForKey(kHighestUnlockedLevelKey)
        
        let title = SKLabelNode(fontNamed: "Zapfino")
        title.text = "Select Level"
        title.fontColor = SKColor(red: 229.0/255.0, green: 64.0/255.0, blue: 117.0/255.0, alpha: 1.0)
        title.fontSize = 32
        title.position = CGPointMake(size.width * 0.5, size.height - 90)
        self.addChild(title)
        
        
        // Add button for levels
        for i in 0 ..< levelsCount {
            
            let levelButton = SKLabelNode(fontNamed: "Marker Felt Wide")
            levelButton.text = "\(i+1)"
            levelButton.name = "\(i+1)"
            levelButton.fontSize = 40
            
            if(i > hightestLevelUnlocked) {
                levelButton.fontColor = SKColor(red: 255.0/255.0, green: 222.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            }
            
//            let buttonTexture = SKTexture(imageNamed: "Level\(i)")
//            let levelButton = Button(texture: buttonTexture, color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: buttonTexture.size(), disableTexture: buttonDisabledTexture)
//            levelButton.enabled = i <= levelUnlocked
            levelButton.position = CGPointMake(CGFloat((i%5 - 1) * 65), CGFloat((-i/5) * 65))
            layoutNode.addChild(levelButton)
        }
        
        let layoutFrame: CGRect = layoutNode.calculateAccumulatedFrame()
        layoutNode.position = CGPointMake(size.width * 0.5 - (layoutFrame.size.width * 0.5) - layoutFrame.origin.x, size.height - 170)
        
        
        
        if hightestLevelUnlocked >= 10 {
            let randomLayoutNode = SKNode()
            self.addChild(randomLayoutNode)
            let randomLabel = SKLabelNode(fontNamed: "Zapfino")
            randomLabel.text = "Random"
            randomLabel.fontSize = 24
            randomLabel.fontColor = SKColor(red: 229.0/255.0, green: 64.0/255.0, blue: 117.0/255.0, alpha: 1.0)
            randomLabel.position = CGPointMake(size.width * 0.5, size.height - (layoutFrame.height + 90 + title.frame.height + randomLabel.frame.height))
            
            let randomEasy = SKLabelNode(fontNamed: "Marker Felt Wide")
            randomEasy.text = "Easy"
            randomEasy.name = "100"
            randomEasy.fontSize = 24
            randomEasy.position = CGPointMake(0, 0)
            //srandomEasy.fontColor = SKColor.blackColor()
            
            let randomHard = SKLabelNode(fontNamed: "Marker Felt Wide")
            randomHard.text = "Hard"
            randomHard.name = "101"
            randomHard.fontSize = 24
            randomHard.position = CGPointMake(randomEasy.frame.width + 57, 0)
        
            
            addChild(randomLabel)
            randomLayoutNode.addChild(randomEasy)
            randomLayoutNode.addChild(randomHard)
            
            let randomLayoutFrame: CGRect = randomLayoutNode.calculateAccumulatedFrame()
            randomLayoutNode.position = CGPointMake(size.width * 0.5 - (randomLayoutFrame.size.width * 0.5) - randomLayoutFrame.origin.x, size.height - (layoutFrame.height + 109 + title.frame.height + randomLabel.frame.height + randomEasy.frame.height))
            
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
        self.menuLabel = SKLabelNode(fontNamed: "Marker Felt Wide")
        self.menuLabel!.fontSize = 15
        self.menuLabel!.fontColor = UIColor.grayColor()
        self.menuLabel!.text = "⬅︎ Main Menu"
        self.menuLabel!.name = "back"
        self.menuLabel!.position = CGPoint(x: CGRectGetMinX(self.scene!.frame) + self.menuLabel!.frame.width/1.8, y: CGRectGetMaxY(self.scene!.frame) - self.menuLabel!.frame.height)
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
        print("sound is off? \(soundOff)")
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
