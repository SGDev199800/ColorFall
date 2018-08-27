//
//  MenuScene.swift
//  ColorFall
//
//  Created by Saurav Gupta on 29/07/18.
//  Copyright © 2018 Saurav Gupta. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var difficulty = ["easy","medium","hard","extreme"]

    override func didMove(to view: SKView) {
        
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        addLogo()
        addLabels()
    }
    
    func addLogo() {
        
        let logo = SKSpriteNode(imageNamed: "Logo")
        logo.size = CGSize(width: frame.size.width/2.5, height: frame.size.width/2.5)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/3)
        addChild(logo)
        
    }
    
//    func addDifficultyButton() {
//        
//        let diffButton = SKLabelNode(text: "Difficulty: " + difficulty[0])
//        diffButton.isUserInteractionEnabled = true
//        diffButton.fontSize = 30.0
//        diffButton.fontName = "AvenirNext-Bold"
//        
//    }
    
    func addLabels() {
        
        let playLabel = SKLabelNode(text: "Tap to Play!")
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontSize = 50.0
        playLabel.color = UIColor.white
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY - frame.midX/2)
        addChild(playLabel)
        animate(label: playLabel)
        
        let highscoreLabel = SKLabelNode(text: "HighScore: " + "\( UserDefaults.standard.integer(forKey: "HighScore"))")
        highscoreLabel.fontName = "AvenirNext-Bold"
        highscoreLabel.fontSize = 30.0
        highscoreLabel.color = UIColor.white
        highscoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - highscoreLabel.frame.size.height*7)
        addChild(highscoreLabel)
        
        let recentScoreLabel = SKLabelNode(text: "Recent Score: " + "\( UserDefaults.standard.integer(forKey: "RecentScore"))")
        recentScoreLabel.fontName = "AvenirNext-Bold"
        recentScoreLabel.fontSize = 30.0
        recentScoreLabel.color = UIColor.white
        recentScoreLabel.position = CGPoint(x: frame.midX, y: highscoreLabel.position.y - recentScoreLabel.frame.size.height*2)
        addChild(recentScoreLabel)
        
    }
    
    func animate(label : SKLabelNode){
//        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
//        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        
        let sequence = SKAction.sequence([scaleUp,scaleDown])
        label.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let gameScene = GameScene(size: view!.bounds.size)
        view!.presentScene(gameScene)
    }
    
}












