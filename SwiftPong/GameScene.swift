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
    
    let ballSpeed = 10
    
    var score = (player1Score: 0, player2Score: 0)
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        
        player1 = self.childNode(withName: "player1") as! SKSpriteNode
        player1.position.y  = (-self.frame.height/2) + (player1.frame.height*2)
        
        player2 = self.childNode(withName: "player2") as! SKSpriteNode
        player2.position.y  = (self.frame.height/2) - (player2.frame.height*2)
        
        player1ScoreLabel = self.childNode(withName: "player1ScoreLabel") as! SKLabelNode
        player2ScoreLabel = self.childNode(withName: "player2ScoreLabel") as! SKLabelNode
    
        // Setup the border
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        border.categoryBitMask = 4
        
        self.physicsBody = border
        
        // Give the ball a start direction
        applyRandomStartDirection()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if location.y > 0 && currentGameType == .twoPlayers {
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
        touchesBegan(touches, with: event)
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
        
        switch currentGameType  {
        case .easy:
            player2.run(SKAction.moveTo(x: ball.position.x, duration: 1.25))
        case .medium:
            player2.run(SKAction.moveTo(x: ball.position.x, duration: 1))
        case .hard:
            player2.run(SKAction.moveTo(x: ball.position.x, duration: 0.75))
        case .twoPlayers:
            break
        }
        
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
