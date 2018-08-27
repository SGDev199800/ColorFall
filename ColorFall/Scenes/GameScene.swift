//
//  GameScene.swift
//  ColorFall
//
//  Created by Saurav Gupta on 28/07/18.
//  Copyright © 2018 Saurav Gupta. All rights reserved.
//

import SpriteKit
import AudioToolbox

enum playColors {
    static let colors = [
        
         UIColor(red: 56/255, green: 204/255, blue: 113/255, alpha: 1.0),
         UIColor(red: 42/255, green: 152/255, blue: 219/255, alpha: 1.0),
         UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
         UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
    ]
}

enum SwitchState : Int {
    case green, blue, yellow, red
}

class GameScene: SKScene {
    
    var gameLabel = SKLabelNode(text: "0")
    var gameCountAdd = 0
    
    var colorSwitch : SKSpriteNode!
    var switchState  = SwitchState.green
    var currentColorIndex : Int?
    
    
    override func didMove(to view: SKView) {
        
        setupPhysics()
        layoutScene()
        
    }

    var yPhysics : CGFloat?
    
    func setupPhysics() {
        
//        yPhysics = CGFloat(arc4random_uniform(5))
    
        physicsWorld.gravity = CGVector(dx: 0, dy: -2)   // -9.8 is default
                                                              // if you it to go up then make gravity positive

        physicsWorld.contactDelegate = self
    }
       
    
    func layoutScene(){
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        colorSwitch = SKSpriteNode(imageNamed: "colorCircle")
        colorSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)
        
        colorSwitch.zPosition = ZPositions.colorSwitch
        
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorSwitch.physicsBody?.isDynamic = false
        addChild(colorSwitch)
        
        gameLabel.fontSize = 60.0
        gameLabel.fontName = "AvenirNext-Bold"
        gameLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 80.0)
        gameLabel.color = UIColor.white
        gameLabel.alpha = 0.8
        gameLabel.zPosition = ZPositions.label
        addChild(gameLabel)
        
        spawnBall()
    }
    
    func spawnBall(){
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "Oval"), color: playColors.colors[currentColorIndex!], size: CGSize(width: 30.0, height: 30.0))
        ball.colorBlendFactor = 1.0
        ball.name = "Oval"
        ball.size = CGSize(width: 30.0, height: 30.0)
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.zPosition = ZPositions.ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
 
//        let velocity = CGVector(dx: 0, dy: -3.0)
//
//        self.enumerateChildNodes(withName: "Oval", using: {
//
//            (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
//            // do something with node or stop
//            node.physicsBody?.applyForce(velocity)
//            return
//        })
        
        self.action(forKey: "speed")?.speed += 10
     
        addChild(ball)
    
        
    }
    

    
    func turnWheel() {
        
        if let newState = SwitchState(rawValue: switchState.rawValue + 1) {
            switchState = newState
        }else{
            switchState = .green
        }
        
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2 , duration: 0.25))
        
    }
    
    func gameOver() {
        
        UserDefaults.standard.set(gameCountAdd, forKey: "RecentScore")
        if gameCountAdd > UserDefaults.standard.integer(forKey: "HighScore"){
            UserDefaults.standard.set(gameCountAdd, forKey: "HighScore")
        }
       
        let scene = MenuScene(size: self.view!.bounds.size)
        self.view?.presentScene(scene)
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
            turnWheel()
    }
    
    func gameCounter() {
        
       gameLabel.text = "\(gameCountAdd)"
        
    }
    
}

extension GameScene : SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // 0 1
        // 1 0
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory {
            if let ball = contact.bodyA.node?.name == "Oval" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode{
                if currentColorIndex == switchState.rawValue{
                    
                    run(SKAction.playSoundFileNamed("ting", waitForCompletion: false))
                    gameCountAdd += 1
                    gameCounter()
                    
                    ball.run(SKAction.fadeOut(withDuration: 0.15), completion: {
                        ball.removeFromParent()
                        self.spawnBall()
                    })
                }else{
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    gameOver()
                }
            }
        }
    }
    
}












