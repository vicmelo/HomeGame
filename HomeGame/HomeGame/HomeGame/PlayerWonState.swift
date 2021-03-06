//
//  PlayerWonState.swift
//  HomeGame
//
//  Created by Laura Corssac on 12/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit
import GameplayKit

class PlayerWonState: GKState {
    
    
    let player: Player!

    init(with player: Player) {
        self.player = player
        super.init()
    }
    
    
    override func didEnter(from previousState: GKState?) {
        
        let creditsScene = SKScene(fileNamed: "NewCreditsScene")
        GameViewController.sharedView.presentScene(creditsScene)
        
    }
    
    
    

}
