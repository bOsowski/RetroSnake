//
//  Menu.swift
//  Snake
//
//  Created by Bartosz Osowski on 29/11/2017.
//  Copyright © 2017 Bartosz Osowski. All rights reserved.
//

import Foundation
import SpriteKit

class Menu:UIViewController{
    static var Speed = 0.1;
    @IBAction func speedSliderMoved(sender: UISlider) {
        Menu.Speed = Double(sender.value)
    }
}
