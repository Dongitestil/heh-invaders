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
    
    var storage = UserDefaults.standard
    
    init(){
        self.highScore = storage.integer(forKey: "HighestHeh")
    }
    
    func saveScore(scr: Int){
        score += scr
        if score > highScore{
            highScore = score
        }  
    }
    
    func save() {
        storage.set(highScore, forKey: "HighestHeh")
    }
}
