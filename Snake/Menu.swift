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
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func speedSliderMoved(sender: UISlider) {
        Menu.Speed = Double(sender.value)
    }
    
    override func viewDidLoad() {
        slider.setValue(Float(Menu.Speed), animated: false)
    }
}
