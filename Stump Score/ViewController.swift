//
//  ViewController.swift
//  Stump Score
//
//  Created by Tom Harrington on 8/23/16.
//  Copyright © 2016 Atomic Bird LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var panelScoreLabel: UILabel!
    @IBOutlet weak var audienceScoreLabel: UILabel!
    @IBOutlet weak var panelAskedLabel: UILabel!
    @IBOutlet weak var audienceAskedLabel: UILabel!
    @IBOutlet weak var panelAskedStepper: UIStepper!
    @IBOutlet weak var audienceAskedStepper: UIStepper!
    @IBOutlet weak var lastUpdatedDateLabel: UILabel!
    
    var stumpScoreWatcher: StumpScoreWatcher?
    var stumpScore = StumpScores() {
        didSet {
            panelScoreLabel.text = String(stumpScore.panelScore)
            audienceScoreLabel.text = String(stumpScore.audienceScore)
            panelAskedStepper.value = Double(stumpScore.panelAskedCount)
            panelAskedLabel.text = "\(stumpScore.panelAskedCount) Asked"
            audienceAskedStepper.value = Double(stumpScore.audienceAskedCount)
            audienceAskedLabel.text = "\(stumpScore.audienceAskedCount) Asked"
        }
    }
    
    var lastUpdatedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        panelScoreLabel.text = "-"
        audienceScoreLabel.text = "-"
        panelAskedLabel.text = "-"
        audienceAskedLabel.text = "-"
        
        stumpScoreWatcher = StumpScoreWatcher()
        stumpScoreWatcher?.startWatching()
        stumpScoreWatcher?.scoreReceived = { (incomingScore) in
            print("Received \(incomingScore)")
            self.stumpScore = incomingScore
            self.lastUpdatedDate = Date()
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            let secondSinceLastTouch = Int(self.lastUpdatedDate.timeIntervalSinceNow) * -1
            
            self.lastUpdatedDateLabel.text = "\(secondSinceLastTouch)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func raisePanelScore(_ sender: AnyObject) {
        stumpScore.panelScore += 1
        stumpScoreWatcher?.sync(scores: stumpScore)
    }
    
    @IBAction func lowerPanelScore(_ sender: AnyObject) {
        stumpScore.panelScore -= 1
        stumpScoreWatcher?.sync(scores: stumpScore)
    }
    
    @IBAction func panelPlusTen(_ sender: Any) {
        stumpScore.panelScore += 10
        stumpScoreWatcher?.sync(scores: stumpScore)
    }
    
    @IBAction func raiseAudienceScore(_ sender: AnyObject) {
        stumpScore.audienceScore += 1
        stumpScoreWatcher?.sync(scores: stumpScore)
    }

    @IBAction func lowerAudienceScore(_ sender: AnyObject) {
        stumpScore.audienceScore -= 1
        stumpScoreWatcher?.sync(scores: stumpScore)
    }
    
    @IBAction func audiencePlusTen(_ sender: Any) {
        stumpScore.audienceScore += 10
        stumpScoreWatcher?.sync(scores: stumpScore)
    }
    
    @IBAction func panelQuestionCountChange(_ sender: UIStepper) {
        stumpScore.panelAskedCount = Int(sender.value)
        stumpScoreWatcher?.sync(scores: stumpScore)
    }
    
    @IBAction func audienceQuestionCountChanged(_ sender: UIStepper) {
        stumpScore.audienceAskedCount = Int(sender.value)
        stumpScoreWatcher?.sync(scores: stumpScore)
    }
    
    @IBAction func resetScores(_ sender: AnyObject) {
        let resetAlert = UIAlertController(title: "Are you sure?",
                                           message: "Really reset the scores? There is no 'undo'",
                                           preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Reset",
                                        style: .destructive) { (_) in
            self.stumpScore = StumpScores()
            self.stumpScoreWatcher?.sync(scores: self.stumpScore)
        }
        resetAlert.addAction(resetAction)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default,
                                         handler: nil)
        resetAlert.addAction(cancelAction)
        
        self.present(resetAlert, animated: true, completion: nil)
    }
}

