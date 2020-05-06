//
//  GameStorage.swift
//  heh-invaders
//
//  Created by student on 07/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

import Foundation

class GameStorage{
    var score = 0
    var highScore = 0
    var enemiesAlive = 12
    
    func saveScore(scr: Int){
        score += scr
        if score > highScore{
            highScore = score
        }
    }
}
