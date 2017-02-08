//
//  ViewController.swift
//  Swift3Timer
//
//  Created by cagdas on 08/02/2017.
//  Copyright © 2017 cagdas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    fileprivate let mainTimerModel: TimerModel = TimerModel()
    fileprivate let lapTimerModel: TimerModel = TimerModel()
    fileprivate var isPlay: Bool = false
    fileprivate var laps: [String] = []
    
    // MARK: disable landscape mode
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var lapTimerLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var lapRestButton: UIButton!
    @IBOutlet weak var lapsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCircleButton(playPauseButton)
        initCircleButton(lapRestButton)
        
        lapRestButton.isEnabled = false
        
        lapsTableView.delegate = self;
        lapsTableView.dataSource = self;
    }
    
    fileprivate func initCircleButton(_ button: UIButton) {
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.backgroundColor = UIColor.white
    }
    
    // MARK: hide status bar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: play, pause, lap, and reset
    @IBAction func playPauseTimer(_ sender: AnyObject) {
        lapRestButton.isEnabled = true
        changeButton(lapRestButton, title: "Lap", titleColor: UIColor.black)
        if !isPlay {
            mainTimerModel.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: Selector.updateMainTimer, userInfo: nil, repeats: true)
            lapTimerModel.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: Selector.updateLapTimer, userInfo: nil, repeats: true)
            isPlay = true
            changeButton(playPauseButton, title: "Stop", titleColor: UIColor.red)
        } else {
            mainTimerModel.timer.invalidate()
            lapTimerModel.timer.invalidate()
            isPlay = false
            changeButton(playPauseButton, title: "Start", titleColor: UIColor.green)
            changeButton(lapRestButton, title: "Reset", titleColor: UIColor.black)
            
        }
    }
    
    @IBAction func lapResetTimer(_ sender: AnyObject) {
        if !isPlay {
            resetMainTimer()
            resetLapTimer()
            changeButton(lapRestButton, title: "Lap", titleColor: UIColor.lightGray)
            lapRestButton.isEnabled = false
        } else {
            if let timerLabelText = timerLabel.text {
                laps.append(timerLabelText)
            }
            lapsTableView.reloadData()
            resetLapTimer()
            lapTimerModel.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: Selector.updateLapTimer, userInfo: nil, repeats: true)
        }
    }
    
    fileprivate func changeButton(_ button: UIButton, title: String, titleColor: UIColor) {
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(titleColor, for: UIControlState())
    }
    
    // MARK: reset timer seperately
    fileprivate func resetMainTimer() {
        resetTimer(mainTimerModel, label: timerLabel)
        laps.removeAll()
        lapsTableView.reloadData()
    }
    
    fileprivate func resetLapTimer() {
        resetTimer(lapTimerModel, label: lapTimerLabel)
    }
    
    fileprivate func resetTimer(_ stopwatch: TimerModel, label: UILabel) {
        stopwatch.timer.invalidate()
        stopwatch.counter = 0.0
        label.text = "00:00:00"
    }
    
    // MARK: update two timer labels seperately
    func updateMainTimer() {
        updateTimer(mainTimerModel, label: timerLabel)
    }
    
    func updateLapTimer() {
        updateTimer(lapTimerModel, label: lapTimerLabel)
    }
    
    func updateTimer(_ stopwatch: TimerModel, label: UILabel) {
        stopwatch.counter = stopwatch.counter + 0.035
        
        var minutes: String = "\((Int)(stopwatch.counter / 60))"
        if (Int)(stopwatch.counter / 60) < 10 {
            minutes = "0\((Int)(stopwatch.counter / 60))"
        }
        
        var seconds: String = String(format: "%.2f", (stopwatch.counter.truncatingRemainder(dividingBy: 60)))
        if stopwatch.counter.truncatingRemainder(dividingBy: 60) < 10 {
            seconds = "0" + seconds
        }
        
        label.text = minutes + ":" + seconds
    }
}

// MARK: tableView dataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "lapCell"
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let labelNum = cell.viewWithTag(11) as? UILabel {
            labelNum.text = "Lap \(laps.count - (indexPath as NSIndexPath).row)"
        }
        if let labelTimer = cell.viewWithTag(12) as? UILabel {
            labelTimer.text = laps[laps.count - (indexPath as NSIndexPath).row - 1]
        }
        
        return cell
    }
}

fileprivate extension Selector {
    static let updateMainTimer = #selector(ViewController.updateMainTimer)
    static let updateLapTimer = #selector(ViewController.updateLapTimer)
}


