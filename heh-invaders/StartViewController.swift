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
    var game = GameStorage()
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highScoreLabel.text = String(game.highScore)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ViewController
        destination.game = game
    }
}
