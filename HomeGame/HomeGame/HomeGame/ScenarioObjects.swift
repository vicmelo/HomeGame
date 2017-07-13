//
//  ScenarioObjects.swift
//  HomeGame
//
//  Created by Douglas Gehring on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

class ScenarioObjects: GKEntity {

    var objectSprite:SKSpriteNode!
    var objectName:String!
    
    init(objectSprite:SKSpriteNode, objectName:String) {
        
        super.init()
        
        self.objectName = objectName
        self.objectSprite = objectSprite
        
        // Fall Component for falling objects (like the ice that falls from the top of a cave)
        let fallcomponent = FallComponent()
        self.addComponent(fallcomponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Components to be added
    
    
}
