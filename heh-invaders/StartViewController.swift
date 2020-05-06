//
//  StartViewController.swift
//  heh-invaders
//
//  Created by student on 06/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    var highScore: Int = 0
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highScoreLabel.text = String(highScore)
    }
}
