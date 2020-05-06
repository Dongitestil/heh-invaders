//
//  ViewController.swift
//  heh-invaders
//
//  Created by student on 06/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ship: UIImageView!
    
    var enemies = [[Enemy]]()
    var cdEnemy = 10
    
    var left = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spawnEnemies()
        
        startTimer()
        // Do any additional setup after loading the view.
    }
    
    func spawnEnemies() {
        for i in 0...3 {
            var enemiesRow = [Enemy]()
            for j in 0...2 {
                let frame = CGRect(x: view.frame.width * 0.2 * CGFloat(i) + view.frame.width * 0.1,
                                   y: view.frame.height * 0.05 + view.frame.width * 0.2 * CGFloat(j),
                                   width: view.frame.width * 0.2,
                                   height: view.frame.width * 0.2)
                let newEnemy = Enemy(frame: frame)
                newEnemy.image = #imageLiteral(resourceName: "enemy")
                view.addSubview(newEnemy)
                enemiesRow.append(newEnemy)
            }
            enemies.append(enemiesRow)
        }
    }
    
    @objc func startTimer() {
        //if !isGameOver {
        let gameLoopStart = mach_absolute_time()
            
        changeEnemyPosition()
            
        let gameLoopEnd = mach_absolute_time()
        let dTime = Double(gameLoopStart/1000000000) + Double(1.0/60.0) - Double(gameLoopEnd/1000000000)
        if (dTime > 0) {
            perform(#selector(startTimer), with: nil, afterDelay: dTime)
        } else {
            startTimer()
        }
        //}
    }

    func changeEnemyPosition() {
        cdEnemy += 1
        
        if cdEnemy >= 10 {
            for i in 0...3 {
                for j in 0...2 {
                    let enemy = enemies[i][j]
                    if left {
                        enemy.frame.origin.x -= view.frame.width * 0.01
                    } else {
                        enemy.frame.origin.x += view.frame.width * 0.01
                    }
                }
            }
            if enemies[0][0].frame.origin.x - view.frame.width * 0.01 <= 0 {
                left = false
            }
            if enemies[3][2].frame.origin.x + enemies[3][2].frame.width + view.frame.width * 0.01 >= view.frame.width {
                left = true
            }
            cdEnemy = 0
        }
    }
    
    @IBAction func buttonLeft(_ sender: UIButton) {
        changeShipPosition(direction: -1)
    }
 
    @IBAction func buttonRight(_ sender: UIButton) {
        changeShipPosition(direction: 1)
    }
    
    func changeShipPosition(direction: Int) {
        let dX = view.frame.width * 0.07 * CGFloat(direction)
        if (ship.frame.origin.x + dX > CGFloat(10)) && (ship.frame.origin.x + dX < view.frame.width - ship.frame.width) {
            ship.frame.origin.x += dX
        }
    }

}

