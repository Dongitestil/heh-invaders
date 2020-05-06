//
//  ViewController.swift
//  heh-invaders
//
//  Created by student on 06/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scoreTitle: UILabel!
    @IBOutlet weak var highScoreTitle: UILabel!
    @IBOutlet weak var gameStatusLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var startNewGameButton: UIButton!
    @IBOutlet weak var background: UIImageView!
    
    
    @IBOutlet weak var ship: UIImageView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var enemies = [[Enemy]]()
    var cdEnemy = 10
    
    var cdMissile = 20
    var missiles = [UIImageView]()
    var cdFireBolt = 40
    var fireBolts = [UIImageView]()
    
    var game = GameStorage()
    var gameStatus = "isActive"
    
    var level = 1
    
    var left = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleResultLayout(isHidden: true)
        
        spawnShip()
        leftButton.frame = CGRect(x: 0,
                                  y: ship.frame.origin.y - 40,
                                  width: view.frame.width * 0.5,
                                  height: 30)
        rightButton.frame = CGRect(x: view.frame.width * 0.5,
                                   y: ship.frame.origin.y - 40,
                                   width: view.frame.width * 0.5,
                                   height: 30)
        spawnEnemies()
        
        startTimer()
    }
    
    func toggleResultLayout(isHidden: Bool) {
        gameStatusLabel.isHidden = isHidden
        scoreTitle.isHidden = isHidden
        highScoreTitle.isHidden = isHidden
        scoreLabel.isHidden = isHidden
        highScoreLabel.isHidden = isHidden
        startNewGameButton.isHidden = isHidden
        background.isHidden = isHidden
    }
    
    func spawnShip() {
        ship.frame = CGRect(x: view.frame.width * 0.35,
                            y: view.frame.height - view.frame.width * 0.3 - CGFloat(25),
                            width: view.frame.width * 0.3,
                            height: view.frame.width * 0.3)
    }
    
    func spawnEnemies() {
        for i in 0...3 {
            var enemiesRow = [Enemy]()
            for j in 0...2 {
                let enemyFrame = CGRect(x: view.frame.width * 0.2 * CGFloat(i) + view.frame.width * 0.1,
                                   y: view.frame.height * 0.05 + view.frame.width * 0.2 * CGFloat(j),
                                   width: view.frame.width * 0.2,
                                   height: view.frame.width * 0.2)
                let newEnemy = Enemy(frame: enemyFrame)
                newEnemy.image = #imageLiteral(resourceName: "enemy")
                view.addSubview(newEnemy)
                enemiesRow.append(newEnemy)
            }
            enemies.append(enemiesRow)
        }
    }
    
    @objc func startTimer() {
        if gameStatus == "isActive" {
            let gameLoopStart = mach_absolute_time()
                
            shootMissile()
            changeMissilePosition()
            changeEnemyPosition()
            shootFireBolt()
            changeFireBoltPosition()
                
            let gameLoopEnd = mach_absolute_time()
            let dTime = Double(gameLoopStart/1000000000) + Double(1.0/60.0) - Double(gameLoopEnd/1000000000)
            if (dTime > 0) {
                perform(#selector(startTimer), with: nil, afterDelay: dTime)
            } else {
                startTimer()
            }
        }
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
    
    @IBAction func onLeft(_ sender: UIButton) {
        changeShipPosition(direction: -1)
    }
 
    @IBAction func onRight(_ sender: UIButton) {
        changeShipPosition(direction: 1)
    }
    
    func changeShipPosition(direction: Int) {
        let dX = view.frame.width * 0.07 * CGFloat(direction)
        if (ship.frame.origin.x + dX > CGFloat(10)) && (ship.frame.origin.x + dX < view.frame.width - ship.frame.width) {
            ship.frame.origin.x += dX
        }
    }
    
    func shootMissile() {
        cdMissile += 1
        
        if cdMissile >= (20+10*(level-1)) {
            let missileFrame = CGRect(x: ship.frame.origin.x + ship.frame.width * 0.4,
                                      y: ship.frame.origin.y - ship.frame.height * 0.5,
                                      width: ship.frame.width * 0.2,
                                      height: ship.frame.width * 0.5)
            let newMissile = UIImageView(frame: missileFrame)
            newMissile.image = #imageLiteral(resourceName: "missile")
            view.addSubview(newMissile)
            missiles.append(newMissile)
            cdMissile = 0
        }
    }
    
    func changeMissilePosition() {
        for (index, missile) in missiles.enumerated() {
            missile.frame.origin.y -= 8 + CGFloat(level)
            
            if missile.frame.origin.y < -missile.frame.height {
                missiles[index].removeFromSuperview()
                missiles.remove(at: index)
            } else {
            for i in 0...3 {
                for j in 0...2 {
                    if missile.frame.intersects(enemies[i][j].frame)&&(enemies[i][j].isHidden==false) {
                        enemies[i][j].hp -= 1
                        if enemies[i][j].hp < 1 {
                            print(index)
                            missiles[index].removeFromSuperview()
                            missiles.remove(at: index)
                            enemies[i][j].isHidden = true
                            game.saveScore(scr: enemies[i][j].cost)
                            game.enemiesAlive -= 1
                            if game.enemiesAlive == 0{
                                nextLvL()
                            }
                        }
                }
            }
          }
        }
      }
    }

    func shootFireBolt() {
        cdFireBolt += 1
        
        if cdFireBolt >= (120-10*level) {
            let enemy = enemies[Int.random(in: 0...3)][Int.random(in: 0...2)]
            if enemy.isHidden == false {
                let fireBoltFrame = CGRect(x:enemy.frame.origin.x + enemy.frame.width * 0.35,
                                           y:enemy.frame.origin.y + enemy.frame.width * 0.2,
                                           width:enemy.frame.width * 0.5,
                                           height:enemy.frame.width * 0.7)
                let newFireBolt = UIImageView(frame: fireBoltFrame)
                newFireBolt.image = #imageLiteral(resourceName: "fireBolt")
                view.addSubview(newFireBolt)
                fireBolts.append(newFireBolt)
                cdFireBolt = 0
            }
        }
    }
    
    func changeFireBoltPosition() {
        for (index, fireBolt) in fireBolts.enumerated() {
            fireBolt.frame.origin.y += CGFloat(level)
            
            if fireBolt.frame.origin.y > view.frame.height {
                fireBolts[index].removeFromSuperview()
                fireBolts.remove(at: index)
            }else{
                if fireBolt.frame.intersects(ship.frame) {
                    fireBolts[index].removeFromSuperview()
                    fireBolts.remove(at: index)
                    gameOver(status: "You loser!")
                }
            }
        }
    }
    
    func gameOver(status: String) {
        gameStatus = "isNotActive"
        gameStatusLabel.text = status
        scoreLabel.text = String(game.score)
        highScoreLabel.text = String(game.highScore)
        toggleResultLayout(isHidden: false)
    }
    
    func nextLvL(){
        if level > 3 {
            gameOver(status: "You Winner!!!")
        }
        else{
            level+=1
            for i in 0...3{
                for j in 0...2{
                    enemies[i][j].isHidden = false
                    enemies[i][j].hp = level
                    enemies[i][j].cost = level
                }
            }
            game.enemiesAlive = 12
        }
    }
}
