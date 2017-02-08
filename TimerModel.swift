//
//  TimerModel.swift
//  Swift3Timer
//
//  Created by cagdas on 08/02/2017.
//  Copyright © 2017 cagdas. All rights reserved.
//

import Foundation

// Timer class
class TimerModel: NSObject {
    var counter: Double
    var timer: Timer
    
    override init() {
        self.counter = 0.0
        self.timer = Timer()
    }
}
