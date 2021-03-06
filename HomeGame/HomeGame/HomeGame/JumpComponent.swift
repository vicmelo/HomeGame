//
//  JumpComponent.swift
//  HomeGame
//
//  Created by Bharbara Cechin on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

// Jump Component for jumping entities (like the main character)
class JumpComponent: GKComponent {
    var rightMovement: Bool!
//    var node: SKNode
    
    
    var distance: Double = 0
    
    var player: Player {
        return self.entity as! Player
    }

    override init(/*with node:SKNode*/) {
//        self.node = node
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func jumpAnimate(){
        
        
        //
        
        let posToJump = 0.8 * distance
        
        if rightMovement{
            player.positionToJump.x = CGFloat (posToJump)
            player.jump(positionDirection: .right )
            
        }
        else{
            player.positionToJump.x =  CGFloat (-posToJump)
            player.jump(positionDirection: .left)

        }
        
//        self.node.physicsBody?.applyImpulse(<#T##impulse: CGVector##CGVector#>)
        
//        guard let animationComponent = self.entity?.component(ofType: FallComponent.self) else { return }
//         animationComponent.animate()
        
        //player.jump()
    }
    
}
