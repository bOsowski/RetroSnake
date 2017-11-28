//
//  Direction.swift
//  Snake
//
//  Created by Bartosz Osowski on 26/11/2017.
//  Copyright © 2017 Bartosz Osowski. All rights reserved.
//

import SpriteKit

class Direction{
    
    static let directions = [DIRECTION.NORTH: CGPoint(x:0,y:1), DIRECTION.EAST: CGPoint(x:1,y:0),DIRECTION.SOUTH: CGPoint(x:0,y:-1), DIRECTION.WEST: CGPoint(x:-1,y:0)]
    
}

enum DIRECTION:Int{
    case NORTH = 180, EAST = 90, SOUTH = 0, WEST = -90
}
