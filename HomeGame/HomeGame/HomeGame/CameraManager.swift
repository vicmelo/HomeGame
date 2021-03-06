//
//  CameraManager.swift
//  ColisionsTest
//
//  Created by Douglas Gehring on 21/07/17.
//  Copyright © 2017 Douglas Gehring. All rights reserved.
//


/***** MISSING INTEGRATION WITH CODE *****/

import SpriteKit
import UIKit

class CameraManager: AnyObject {

    var esquerda = false
    var direita = false
    
    var lastPositionToRight = CGPoint(x: 1, y: 0)
    var lastPositionToLeft = CGPoint(x: 1, y: 0)
    
    var cameraNode:SKCameraNode!
    
    var viewWidth:CGFloat!
    
    var passed = false
    
    var introAnimation = false
    
    init(viewWidth:CGFloat) {
        
        cameraNode = SKCameraNode()
        self.viewWidth = viewWidth
    
    }
    
    
    
    func getCostomCamera()->SKCameraNode{
        
        return self.cameraNode
    }
    
    
    func setLeftSideCameraConfigurations(node:SKNode){
        
        if(passed){
            
            if(direita){
                
                lastPositionToRight = node.position
                
            }
            
            direita  = false
            
            esquerda = true
            
            if((lastPositionToRight.x - 1) > node.position.x){
                
                lastPositionToRight.x = node.position.x + 1
                
            }
            
            
            
        }else{
            lastPositionToRight = CGPoint(x: 1, y: 0)
            
        }
        
        
        
        
        
        
    }
    
    
    func setRightSideCameraConfiguration(){
        
        
        esquerda = false
        direita = true
        
    }
    
    
    func checkCameraPositionAndPerformMovement(node:SKNode){
        
        
        
        /*
            if(node.position.x <= (-1)){
            
                passed = false
            
            }else{
            
                passed = true
            }
        
        
            
            if(node.position.x >= lastPositionToRight.x && direita){
                
                
                //cameraNode.run(SKAction.move(to: CGPoint(x: (node.position.x - 1), y: node.position.y), duration: 0.01))
                
                cameraNode.position.x = (node.position.x - 1)
                
            }
        
        
        if(passed){
        
            if(node.position.x <= (lastPositionToRight.x - 1) && esquerda){
                
                //cameraNode.run(SKAction.move(to: CGPoint(x: (node.position.x + 1), y: node.position.y), duration: 0.01))
                cameraNode.position.x = (node.position.x + 1)
                
            
                cameraNode.position.x = (node.position.x + 1)
            }
            
            
            cameraNode.position.y = node.position.y+100
            
        }
 */
        
        if(node.position.y < -123 && !introAnimation){
            return
        }
        
        if(node.position.x >= 0){
            
            cameraNode.position.y = node.position.y+100
            cameraNode.position.x = node.position.x
            
        }
        
        
        
    }
    
    
    
    func checkCameraPositionAndPerformMovementIntroAnimation(node:SKNode){
        
        
        
        /*
         if(node.position.x <= (-1)){
         
         passed = false
         
         }else{
         
         passed = true
         }
         
         
         
         if(node.position.x >= lastPositionToRight.x && direita){
         
         
         //cameraNode.run(SKAction.move(to: CGPoint(x: (node.position.x - 1), y: node.position.y), duration: 0.01))
         
         cameraNode.position.x = (node.position.x - 1)
         
         }
         
         
         if(passed){
         
         if(node.position.x <= (lastPositionToRight.x - 1) && esquerda){
         
         //cameraNode.run(SKAction.move(to: CGPoint(x: (node.position.x + 1), y: node.position.y), duration: 0.01))
         cameraNode.position.x = (node.position.x + 1)
         
         
         cameraNode.position.x = (node.position.x + 1)
         }
         
         
         cameraNode.position.y = node.position.y+100
         
         }
         */
        
        if(node.position.y < -123 && !introAnimation){
            return
        }
        
        if(node.position.x >= 0){
            
            cameraNode.position.y = node.position.y+75
            cameraNode.position.x = node.position.x
            
        }
        
        
        
    }

    
    
    func performZoomToEndGame(){
        
        self.cameraNode.run(SKAction.scale(to: 0.68, duration: 3))
        
    }
    
    func performZoomToIntroAnimation(){
        
        self.cameraNode.run(SKAction.scale(to: 0.8, duration: 3))
        
    }
    
    func performZoomToIntroAnimationFinal(){
        
        self.cameraNode.run(SKAction.scale(to: 0.7, duration: 3))
    }
    
}
