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
    
    var player1ScoreLabel = SKLabelNode()
    var player2ScoreLabel = SKLabelNode()
    
    let ballSpeed = 20
    
    var score = (player1Score: 0, player2Score: 0)
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        player1 = self.childNode(withName: "player1") as! SKSpriteNode
        player2 = self.childNode(withName: "player2") as! SKSpriteNode
        
        player1ScoreLabel = self.childNode(withName: "player1ScoreLabel") as! SKLabelNode
        player2ScoreLabel = self.childNode(withName: "player2ScoreLabel") as! SKLabelNode
        
        // Give the ball a start direction
        applyRandomStartDirection()
    
        // Setup the border
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        print(-frame.size.height/2.0 - ball.size.height)
        
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
    
    func updateScore(playerWhoScored: SKSpriteNode){
        if playerWhoScored == player1 {
            score.player1Score += 1
            player1ScoreLabel.text = "\(score.player1Score)"
        }
        else if playerWhoScored == player2 {
            score.player2Score += 1
            player2ScoreLabel.text = "\(score.player2Score)"
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
        
        // Check if player 1 should get a point
        if ball.position.y > (frame.size.height/2.0 - ball.size.height) {
            updateScore(playerWhoScored: player1)
            resetBall()
        }
        // Check if player 2 should get a point
        else if ball.position.y < (-frame.size.height/2.0 + ball.size.height) {
            updateScore(playerWhoScored: player2)
            resetBall()
        }
    }
}
