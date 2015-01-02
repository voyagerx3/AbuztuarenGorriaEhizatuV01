//
//  ScoreController.swift
//  UBoat LEX
//
//  Created by Geovanny Inca on 25/12/14.
//  Copyright (c) 2014 Berganza. All rights reserved.
//

import Foundation
protocol ScoreUpdateDelegate {
    
    func scoreUpdated(sender: ScoreController)
    
}

class ScoreController {
    
    init(){
        score = 0
        let prefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.synchronize()
        highScore = prefs.integerForKey("highscore")
    }
    
    private(set) var highScore : Int {
        didSet {
            let prefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
            prefs.setInteger(highScore, forKey: "highscore")
            prefs.synchronize()
        }
    }
    
    var delegate : ScoreUpdateDelegate!
    private(set) var score : Int {
        didSet {
            if(score > highScore){
                highScore = score
            }
            delegate?.scoreUpdated(self)
        }
    }
    
    /**
    * Add to the current score
    * Will ignore zero and negative values
    */
    func incrementScore(value: Int){
        if(value > 0){
            score += value
        }
    }
    
}