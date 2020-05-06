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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc func startTimer() {
        //if !isGameOver {
        let gameLoopStart = mach_absolute_time()
            
        //do something
            
        let gameLoopEnd = mach_absolute_time()
        let dTime = Double(gameLoopStart/1000000000) + Double(1.0/60.0) - Double(gameLoopEnd/1000000000)
        if (dTime > 0) {
            perform(#selector(startTimer), with: nil, afterDelay: dTime)
        } else {
            startTimer()
        }
        //}
    }



}

