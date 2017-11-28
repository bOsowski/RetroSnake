//
//  BodyPart.swift
//  Snake
//
//  Created by Bartosz Osowski on 26/11/2017.
//  Copyright © 2017 Bartosz Osowski. All rights reserved.
//

import SpriteKit

class BodyPart{
    
    var part:SKSpriteNode
    var previousPosition:CGPoint?
    var direction = DIRECTION.SOUTH
    var previousDirection:DIRECTION?
    
    init(bodyPart: SKSpriteNode){
        part = bodyPart
    }
    
}
