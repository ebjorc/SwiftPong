//
//  MenuViewController.swift
//  SwiftPong
//
//  Created by Erik Björck on 2020-08-07.
//  Copyright © 2020 Erik Björck. All rights reserved.
//

import UIKit
import Foundation

enum GameType {
    case easy
    case medium
    case hard
    case twoPlayers
}

class MenuViewController: UIViewController {
    
    @IBAction func twoPlayerButtonPressed(_ sender: UIButton) {
        moveToGame(gameType: .twoPlayers)
    }
    
    @IBAction func easyButtonPressed(_ sender: UIButton) {
        moveToGame(gameType: .easy)
    }
    @IBAction func mediumButtonPressed(_ sender: UIButton) {
        moveToGame(gameType: .medium)
    }
     
    @IBAction func hardButtonPressed(_ sender: UIButton) {
        moveToGame(gameType: .hard)
    }
    
    func moveToGame(gameType: GameType){
        let gameVC = self.storyboard?.instantiateViewController(identifier: "gameVC") as! GameViewController
        currentGameType = gameType
        self.navigationController?.pushViewController(gameVC, animated: true)
        
        
        
    }
}
