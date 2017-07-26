//
//  Level1Scene.swift
//  HomeGame
//
//  Created by Douglas Gehring on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox
class Level1Scene: SKScene , SKPhysicsContactDelegate, UIGestureRecognizerDelegate{
    
    var scenarioObjects:[ScenarioObjects]!
    var characterNodes:[CharacterNode]!
    
    //model attributes
    var player: Player! = nil
    var animationCompleted: [Bool] = [true, true, true]
    
    //player control interface
    let base: SKShapeNode = SKShapeNode(circleOfRadius: 50)
    let ball: SKShapeNode = SKShapeNode(circleOfRadius: 40)
    
    //controller attributes
    var tap: UITapGestureRecognizer!
    var stop = false
    var tolerance: Float =  5
    var joystickGesture: UIGestureRecognizer!
    var longPressSetted = false
    
    var tapLocation: CGPoint!
    
    var longPressLocation: CGPoint!
    
    //movement attributes
    var rightMov = true
    var xGreaterThanLenght = false
    var yGreaterThanLenght = false
    
    
    
    
    // Camera manager integration
    
    
    var cameraManager:CameraManager!
    
    override func sceneDidLoad() {
        
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        return true

    }
    
    override func didMove(to view: SKView) {
        
        
        
        super.didMove(to: view)
        
        
        
        //let credits = SKScene(fileNamed: "CreditsScene")
        //self.view?.presentScene(credits)
        
        self.physicsWorld.contactDelegate = self
        
        
        self.setCameraConfigurations()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gesture:)))
        longPressRecognizer.delegate = self
        longPressRecognizer.numberOfTouchesRequired = 1
        self.view?.addGestureRecognizer(longPressRecognizer)
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gesture:)))
        tapRecognizer.delegate = self
        self.view?.addGestureRecognizer(tapRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(gesture:)))
        panRecognizer.delegate = self
        panRecognizer.maximumNumberOfTouches = 1
        self.view?.addGestureRecognizer(panRecognizer)
        
        self.initScenarioElements()
        self.initCharacterNodes()
        
        self.initControllerInterface()
        
        if let view = self.view {
            view.isMultipleTouchEnabled = true
        }
        
    }
    
    
    func setCameraConfigurations(){
        
        
        self.cameraManager = CameraManager(viewWidth: (self.view?.frame.width)!)
        
        addChild(self.cameraManager.cameraNode)
        
        camera = self.cameraManager.cameraNode
        
        
    }
    
    func initScenarioElements(){
        
        /* Initializing scenario elements with the name identifier for each one*/
        
    }
    
    func initCharacterNodes(){
        
        /* Initializing characters nodes with the name identifier for each one*/
        player = Player()
        self.addChild(player.mainPlayerSprite)
        player.mainPlayerSprite.zPosition = 1
        
    }
    
    
    func fallObj (obj: SKNode){
       
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate) //treme
            let wait = SKAction.wait(forDuration: 1) //esperea 1 sec
            let fall = SKAction.move(to: CGPoint(x: obj.position.x, y: -200), duration: 2) //cai
            let sequence = SKAction.sequence([wait, fall])
            obj.run(sequence, completion: { 
                  obj.removeFromParent()
            })
          
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        var playerColision = false
        
        var playerNode:SKNode!
        
        var obstacleNode:SKNode!
        
        if let name = contact.bodyA.node?.name{
            if name == "Player" {
            
                playerNode = contact.bodyA.node
                obstacleNode = contact.bodyB.node
                playerColision = true
            
            }
            
        }
        if let name = contact.bodyB.node?.name{
            if name == "Player"{
                playerNode = contact.bodyB.node
                obstacleNode = contact.bodyA.node
                playerColision = true
            }
        }
        
        
        
        if(playerColision){
            
            if(obstacleNode.physicsBody?.contactTestBitMask == 1){
                
                // Chao escorrega
                
            }
            else if(obstacleNode.physicsBody?.contactTestBitMask == 2){
                
                // Agua - morre
                // ou
                // Ice cub - morre
            }
            else if(obstacleNode.physicsBody?.contactTestBitMask == 3){
                
                if ( obstacleNode.position.y  < playerNode.position.y  && playerNode.position.x  > obstacleNode.position.x - obstacleNode.frame.size.width/2 && playerNode.position.x < obstacleNode.position.x + obstacleNode.frame.size.width/2){
                   
                    if obstacleNode != nil {
                        self.obstacleAnimation(obstacle: obstacleNode)
                    }
                    
                }
            }
                
            else if (obstacleNode.physicsBody?.contactTestBitMask == 4){
                
                
                player?.stateMachine.enter(PlayerWonState.self)
                print("morreu")
                
            }
            
        }
        
    }
    
    
    
    func obstacleAnimation(obstacle: SKNode){
        //let wait = SKAction.wait(forDuration: 1.0)
        
        let nameArray = obstacle.name?.components(separatedBy: "_")
        let obsNumber = Int((nameArray?[1])!)
       
        
        if animationCompleted[obsNumber!] {
        animationCompleted[obsNumber!] =  false
        let rot1 = SKAction.rotate(byAngle: -CGFloat(GLKMathDegreesToRadians(1)), duration: 0.1)
        let rot2 = rot1.reversed()
        let rot3 = SKAction.rotate(byAngle: CGFloat(GLKMathDegreesToRadians(1)), duration: 0.1)
        let rot4 = rot3.reversed()
        var animationAction = Array<SKAction>()
        animationAction.append(rot1)
        animationAction.append(rot2)
        animationAction.append(rot3)
        animationAction.append(rot4)
        
        let fallAction: SKAction = SKAction.move(to: CGPoint(x: obstacle.position.x, y:-200), duration:1.0)
        let animationFull = SKAction.sequence(animationAction)
        let rotateAnimFull = SKAction.repeat(animationFull, count: 3)
        let animWithFall = SKAction.sequence([rotateAnimFull, fallAction])
        
        //let when = DispatchTime.now() + 0.5 // change 0.5 to desired number of seconds
        //  DispatchQueue.main.asyncAfter(deadline: when) {
        //obstacleNode?.physicsBody?.affectedByGravity = true
        //obstacle.run(animWithFall, completion: <#T##() -> Void#>)
        //}
        //
        obstacle.run(animWithFall, completion: {
            obstacle.removeFromParent()
            self.animationCompleted[obsNumber!] = true
        })
        
        }
        
    }
    
    
    
    
    func initControllerInterface(){
        
        base.lineWidth = 10
        
        base.strokeColor = .gray
        ball.fillColor = .lightGray
        //base.fillColor = .cyan
        ball.zPosition = 2
        base.zPosition = 2
        ball.strokeColor = ball.fillColor
        
        ball.isHidden = true
        base.isHidden = true
        
        ball.position = base.position
        
        self.cameraManager.cameraNode.addChild(base)
        self.cameraManager.cameraNode.addChild(ball)

        
        //self.addChild(base)
        //self.addChild(ball)
        
        
    }
    
    func handleTap(gesture: UITapGestureRecognizer){
        
        player?.stateMachine.state(forClass: JumpingState.self)?.rightMovement = self.rightMov
        
        tapLocation = gesture.location(in: self.view)
        
        
        player.changeState(stateClass: JumpingState.self)
        
        if childNode(withName: "fallObj") != nil{
            self.fallObj(obj: self.childNode(withName: "fallObj")!)
        }
        
        
    }
    
    //controller methodss
    public func handleLongPress (gesture: UILongPressGestureRecognizer){

        if longPressSetted{
            return
        }
        
        
        var position = gesture.location(in: self.view!)
        position = self.convertPoint(fromView: position)
        position =  (camera?.convert(position, from: self))!
   
        self.longPressLocation = position
        
        if gesture.state == .began{
            print("posicao do joystick")
            print(position)
            
            base.position = position
            ball.position = base.position
            base.isHidden = false
            ball.isHidden = false
            
        }
        
        if gesture.state == .ended || gesture.state == .cancelled{
            
            base.isHidden = true
            ball.isHidden = true
            
            ball.position = base.position
            player?.stateMachine.state(forClass: MovingState.self)?.stop = 1
            return
            
        }
        
    }
    
    
    public func handlePan(gesture: UIPanGestureRecognizer){

        var position = gesture.location(in: self.view!)
        position = self.convertPoint(fromView: position)
        position =  (camera?.convert(position, from: self))!

        self.longPressLocation = position
        
        if gesture.state == .began{
            
            base.position = position
            ball.position = base.position
            base.isHidden = false
            ball.isHidden = false
            
        }
        
        if gesture.state == .ended || gesture.state == .cancelled{
            
            base.isHidden = true
            ball.isHidden = true
            
            ball.position = base.position
            player?.stateMachine.state(forClass: MovingState.self)?.stop = 1
            return
            
        }
        
        setJoystickPosition(to: position)
       
    }
    
    
    private func setJoystickPosition(to location : CGPoint){
        
        let vector  = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
        let angle = atan2(vector.dx, vector.dy)
        
        //let degree = GLKMathRadiansToDegrees(Float(angle))
        
        let LENGHT: CGFloat = 40
        
        var xDist: CGFloat! // = sin(angle) * lenght
        var yDist: CGFloat! // = cos(angle) * lenght
        
        if abs(location.x - base.position.x) <= LENGHT
        {
            xDist = abs(location.x - base.position.x)
            self.xGreaterThanLenght = false
            
        }
        else{
            if location.x < base.position.x {
                xDist = -LENGHT
            }
            else
            {
                xDist = LENGHT
            }
            
            self.xGreaterThanLenght = true
        }
        
        if abs(location.y - base.position.y) <= LENGHT
        {
            yDist = abs(location.y - base.position.y)
            self.yGreaterThanLenght = false
            
        }
        else{
            self.yGreaterThanLenght = true
            
            if location.y > base.position.y{
                yDist = LENGHT
            }
            else {
                yDist = -LENGHT
            }
            
        }
        if angle == 0 && !(self.player?.stateMachine.currentState is JumpingState){
            
            player?.stateMachine.state(forClass: MovingState.self)?.stop = 1
            
        }
        else{



            if sin(angle) > 0{
                self.rightMov = true
                
                self.cameraManager.setRightSideCameraConfiguration()

            }
            else{
                self.rightMov = false
                
                self.cameraManager.setLeftSideCameraConfigurations(node: player.mainPlayerSprite)
                
                if !self.xGreaterThanLenght{
                    xDist = -xDist
                }
                
            }
            
            
            if cos(angle) <  0{
                if !self.yGreaterThanLenght{
                    yDist = -yDist
                }
            }
            
            ball.position = CGPoint(x: base.position.x + xDist, y:  base.position.y + yDist)
            
        }
        
        
        
    }
    
    //    func seeIfItWasTapped(touches:Set<UITouch> ) -> Bool{
    //
    //        let firstTouch = touches.first!
    //
    //        let lastTouch = touches[touches.index(touches.startIndex, offsetBy: touches.count-1)]
    //
    //        if abs (lastTouch.location(in: self).x) - abs(firstTouch.location(in: self).x) > CGFloat (tolerance)
    //        {
    //            return false
    //        }
    //
    //        if abs (lastTouch.location(in: self).y) - abs(firstTouch.location(in: self).y) > CGFloat (tolerance)
    //        {
    //
    //            return false
    //        }
    //
    //        return true
    //
    //    }
    //
    //
    //
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //
    //        print("began")
    //
    //    }
    //
    //    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //
    //        player?.stateMachine.state(forClass: MovingState.self)?.stop = 1
    //        ball.removeFromParent()
    //        base.removeFromParent()
    //
    //    }
    //
    //    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    //
    //        player?.stateMachine.enter(StoppedState.self)
    //        ball.position = base.position
    //
    //
    //    }
    
    
    //
    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //
    //        player?.stateMachine.enter(MovingState.self)
    //        player?.stateMachine.state(forClass: MovingState.self)?.stop = 0
    //
    //        if base.isHidden{
    //            base.isHidden = false
    //            ball.isHidden = false
    //        }
    //
    //        base.position = (touches.first?.location(in: self))!
    //        ball.position = (touches.first?.location(in: self))!
    //
    //
    //        for touch in touches
    //        {
    //
    //            let location = touch.location(in: self)
    //            let vector  = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
    //            var angle = atan2(vector.dx, vector.dy)
    //
    //            let degree = GLKMathRadiansToDegrees(Float(angle))
    //
    //            let lenght: CGFloat = 40
    //
    //            var xDist: CGFloat! // = sin(angle) * lenght
    //            var yDist: CGFloat! // = cos(angle) * lenght
    //
    //
    //            print(degree + 180)
    //            if abs(location.x - base.position.x) <= lenght
    //            {
    //                xDist = abs(location.x - base.position.x)
    //                self.xGreaterThanLenght = false
    //
    //            }
    //            else{
    //                if location.x < base.position.x {
    //                    xDist = -lenght
    //
    //                }
    //                else
    //                {
    //                    xDist = lenght
    //                }
    //
    //                self.xGreaterThanLenght = true
    //            }
    //
    //            if abs(location.y - base.position.y) <= lenght
    //            {
    //                yDist = abs(location.y - base.position.y)
    //                self.yGreaterThanLenght = false
    //
    //            }
    //            else{
    //                self.yGreaterThanLenght = true
    //
    //                if location.y > base.position.y{
    //                    yDist = lenght
    //                }
    //                else {
    //                    yDist = -lenght
    //                }
    //
    //            }
    //            if angle == 0 {
    //
    //                player?.stateMachine.state(forClass: MovingState.self)?.stop = 1
    //
    //            }
    //            else{
    //
    //
    //
    //                if sin(angle) > 0 { //moving to the right
    //                    self.rightMov = true
    //
    //                }
    //                else{ //moving to the left
    //                    self.rightMov = false
    //
    //                    if !self.xGreaterThanLenght{
    //                        xDist = -xDist
    //                    }
    //
    //                }
    //
    //
    //                if cos(angle) <  0{
    //                    if !self.yGreaterThanLenght{
    //                        yDist = -yDist
    //                    }
    //                }
    //                ball.position = CGPoint(x: base.position.x + xDist, y:  base.position.y + yDist)
    //
    //            }
    //
    //
    //        }
    //    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        let DISTANCE: Double = 150
        
        if (!base.isHidden && !(self.player?.stateMachine.currentState is JumpingState)){
            
            if abs (ball.position.x - base.position.x) > 3 { //&& self.player?.stateMachine.currentState is StoppedState{
               
                    
                self.player?.stateMachine.enter(MovingState.self)
                player?.stateMachine.state(forClass: MovingState.self)?.stop = 0
                
                
                if abs (longPressLocation.x - base.position.x) >= CGFloat (DISTANCE){
                    //if abs(ball.position.x - base.position.x) >= 40{
                    
                    player?.stateMachine.state(forClass: MovingState.self)?.distance = DISTANCE
                    
                    //player?.stateMachine.state(forClass: MovingState.self)?.fast = true
                    
                    if ball.position.x > base.position.x{

                        self.rightMov = true
                        player?.stateMachine.state(forClass: MovingState.self)?.rightMovement = true
                        
                    }
                    else{
                        
                        self.rightMov = false
                        player?.stateMachine.state(forClass: MovingState.self)?.rightMovement = false
                        
                    }
                    
                }
                else{
                    //player?.stateMachine.state(forClass: MovingState.self)?.fast = false
                    player?.stateMachine.state(forClass: MovingState.self)?.distance = abs (Double(longPressLocation.x - base.position.x))
                    
                    if ball.position.x > base.position.x {

                        self.rightMov = true
                        player?.stateMachine.state(forClass: MovingState.self)?.rightMovement = true
                        
                    }
                    else{
                        self.rightMov = false
                        player?.stateMachine.state(forClass: MovingState.self)?.rightMovement = false
                        
                    }
                    
                }
                
            }
                
            else if !(self.player?.stateMachine.currentState is JumpingState){

                player?.stateMachine.state(forClass: MovingState.self)?.stop = 1
                
                
            }
            
        }
        
        player.update(deltaTime: currentTime)
        //self.cameraManager.cameraNode.position.x = player.mainPlayerSprite.position.x
        //self.cameraManager.cameraNode.position.y = player.mainPlayerSprite.position.y

        self.cameraManager.checkCameraPositionAndPerformMovement(node: player.mainPlayerSprite)
 
    }
    
    
}
