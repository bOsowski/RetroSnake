//
//  GameScene.swift
//  Snake
//
//  Created by Bartosz Osowski on 26/11/2017.
//  Copyright © 2017 Bartosz Osowski. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var snake = [BodyPart]()
    var firstTouch:CGPoint?
    var directionToTurn:DIRECTION?
    var food:SKSpriteNode?
    var gameOver = false
    
    var touchDeltaX:Float = Float(0)
    var touchDeltaY:Float = Float(0)
    
    override func didMove(to view: SKView) {
        childNode(withName: "GameOver")?.alpha = 0
        snake.append(BodyPart(bodyPart: childNode(withName: "Head")! as! SKSpriteNode))
        snake.append(BodyPart(bodyPart: childNode(withName: "Body")! as! SKSpriteNode))
        snake.append(BodyPart(bodyPart: childNode(withName: "Tail")! as! SKSpriteNode))
        food = childNode(withName: "Food") as? SKSpriteNode
        spawnFood(food: food!)
        
        
        
        let wait = SKAction.wait(forDuration: 1.0)
        
        let moveAction = SKAction.run{
            
            if(self.gameOver){
                return
            }
            
            self.snake[0].previousDirection = self.snake[0].direction
            
            if self.directionToTurn != nil && (self.directionToTurn == DIRECTION.NORTH && self.snake[0].direction != DIRECTION.SOUTH) || (self.directionToTurn == DIRECTION.SOUTH && self.snake[0].direction != DIRECTION.NORTH) || (self.directionToTurn == DIRECTION.EAST && self.snake[0].direction != DIRECTION.WEST) || (self.directionToTurn == DIRECTION.WEST && self.snake[0].direction != DIRECTION.EAST){
                self.snake[0].direction = self.directionToTurn!
                self.directionToTurn = nil
            }
            
            self.snake[0].part.zRotation = CGFloat(GLKMathDegreesToRadians(Float(self.snake[0].direction.rawValue)))
            
            self.snake[0].previousPosition = self.snake[0].part.position
            
            self.snake[0].part.position.x += (Direction.directions[self.snake[0].direction]?.x)! * self.snake[0].part.calculateAccumulatedFrame().height
            
            self.snake[0].part.position.y += (Direction.directions[self.snake[0].direction]?.y)! * self.snake[0].part.calculateAccumulatedFrame().height
            
            if self.snake[0].part.position.x < -4.5 {
                self.snake[0].part.position.x = 4.5
            }
            if self.snake[0].part.position.x > 4.5 {
                self.snake[0].part.position.x = -4.5
            }
            if self.snake[0].part.position.y < -8.5 {
                self.snake[0].part.position.y = 8.5
            }
            if self.snake[0].part.position.y > 8.5 {
                self.snake[0].part.position.y = -8.5
            }

            
            if self.food?.position == self.snake[0].part.position{
                print("snake should grow.")
                self.snake.append(BodyPart(bodyPart: SKSpriteNode(imageNamed: "snakeTail")))
                self.changeTexture(spriteNode: self.snake[self.snake.count-2].part, textureName: "snakeBody")
                self.snake[self.snake.count-1].part.size.width = 1;
                self.snake[self.snake.count-1].part.size.height = 1;
                self.addChild(self.snake[self.snake.count-1].part)
                self.spawnFood(food: self.food!)

            }
            else{
                print("snake position x = \(self.snake[0].part.position.x)     snake position y = \(self.snake[0].part.position.y)")
            }
            
            
            
            for i in 1..<self.snake.count{
                self.snake[i].previousPosition = self.snake[i].part.position
                self.snake[i].part.position = self.snake[i-1].previousPosition!
                self.snake[i].previousDirection = self.snake[i].direction
                self.snake[i].direction = self.snake[i-1].previousDirection!
                self.snake[i].part.zRotation = CGFloat(GLKMathDegreesToRadians(Float(self.snake[i-1].direction.rawValue)))
                
                //change corners
                if i != self.snake.count-1 && self.snake[i].direction != self.snake[i-1].direction{
                    
                    if self.snake[i-1].direction == DIRECTION.NORTH && self.snake[i].direction == DIRECTION.EAST ||
                    self.snake[i-1].direction == DIRECTION.EAST && self.snake[i].direction == DIRECTION.SOUTH ||
                    self.snake[i-1].direction == DIRECTION.SOUTH && self.snake[i].direction == DIRECTION.WEST ||
                    self.snake[i-1].direction == DIRECTION.WEST && self.snake[i].direction == DIRECTION.NORTH{
                        
                        
                        self.changeTexture(spriteNode: self.snake[i].part, textureName: "snakeTurningRight")
                    }
                    else{
                       self.changeTexture(spriteNode: self.snake[i].part, textureName: "snakeTurningLeft")
                    }
                }
                else if i != self.snake.count-1{
                    self.changeTexture(spriteNode: self.snake[i].part, textureName: "snakeBody")
                }
                
                //end change corners
                
                if(self.snake[0].part.position == self.snake[i].part.position){
                    //game over
                    print("Game Over")
                    self.childNode(withName: "GameOver")?.alpha = 0.65
                    self.gameOver = true
                }
            }
        }
        
        let repeatMoveAction = SKAction.repeatForever(SKAction.sequence([wait, moveAction]))
        
        self.run(repeatMoveAction)

    }
    
    func changeTexture(spriteNode: SKSpriteNode, textureName: String){
        spriteNode.texture = SKTexture(imageNamed: textureName)
        spriteNode.size.width = 1;
        spriteNode.size.height = 1;
    }
    
    func spawnFoodAtRandomPos(food:SKNode){
        food.position.x = CGFloat(Double(Int(CGFloat(Float(arc4random_uniform(UInt32(((self.scene?.size.width)!-1)))))-(self.scene?.size.width)!/2))-0.5)
        
        food.position.y = CGFloat(Double(Int(CGFloat(Float(arc4random_uniform(UInt32(((self.scene?.size.height)!-1)))))-(self.scene?.size.height)!/2))+0.5)
        
        if food.position.y < -8.5 || food.position.y > 8.5 || food.position.x < -4.5 || food.position.x > 4.5{
            spawnFoodAtRandomPos(food:food)
        }
        print("food pos x = \(food.position.x)     food pos y = \(food.position.y)")
    }
    
    func spawnFood(food:SKNode){
        spawnFoodAtRandomPos(food: food)
        for body in snake{
            if food.position == body.part.position{ //colliding
                spawnFood(food: food)
            }
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        firstTouch = touches.first?.location(in: view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        let lastTouch = touches.first?.location(in: view)
        
        let firstTouchXPos:Float =  Float((firstTouch?.x)!)
        let lastTouchXPos:Float =  Float((lastTouch?.x)!)
        let firstTouchYPos:Float = Float((firstTouch?.y)!)
        let lastTouchYPos:Float = Float((lastTouch?.y)!)

        
        touchDeltaX = lastTouchXPos - firstTouchXPos
        touchDeltaY = lastTouchYPos - firstTouchYPos
        
        print("touchDeltaX = \(touchDeltaX)    touchDeltaY = \(touchDeltaY)")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if touchDeltaX < Float(-40){
            print("Move snake west")
            touchDeltaX = Float(0)
            directionToTurn = DIRECTION.WEST
        }else if touchDeltaX > Float(40){
            print("Move snake east")
            touchDeltaX = Float(0)
            directionToTurn = DIRECTION.EAST
        }
        if touchDeltaY < Float(-40) {
            print("Move snake nort")
            touchDeltaY = Float(0)
            directionToTurn = DIRECTION.NORTH
        }else if touchDeltaY > Float(40){
            print("Move snake south")
            touchDeltaY = Float(0)
            directionToTurn = DIRECTION.SOUTH
        }
        
    }
}
