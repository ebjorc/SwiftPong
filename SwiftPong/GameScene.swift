//
//  GameScene.swift
//  SwiftPong
//
//  Created by Erik Björck on 2020-08-05.
//  Copyright © 2020 Erik Björck. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ball = SKSpriteNode()
    var player1 = SKSpriteNode()
    var player2 = SKSpriteNode()
    
    let ballSpeed = 20
    
    var score = (player1Score: 0, player2Score: 0)
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        player1 = self.childNode(withName: "player1") as! SKSpriteNode
        player2 = self.childNode(withName: "player2") as! SKSpriteNode
        
        // Give the ball a start direction
        applyRandomStartDirection()
    
        // Setup the border
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if location.y > 0 {
                player2.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
            if location.y < 0 {
                player1.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
        }
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func resetBall(){
        ball.position.x = 0
        ball.position.y = 0
        ball.physicsBody?.isResting = true
        let seconds = 0.25
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.applyRandomStartDirection()
        }
    }
    
    func applyRandomStartDirection(){
        let positiveNegative = [-1, 1]
        if let randomDir1 = positiveNegative.randomElement(), let randomDir2 = positiveNegative.randomElement() {
            ball.physicsBody?.applyImpulse(CGVector(dx: randomDir1*ballSpeed, dy: randomDir2*ballSpeed))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if ball.position.y < player1.position.y - ball.size.height*2 {
            score.player2Score += 1
            resetBall()
        }
        
        if ball.position.y > player2.position.y + ball.size.height*2 {
            score.player1Score += 1
            resetBall()
        }
    }
}
