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
    
    var panelScore = 0 {
        didSet {
            UserDefaults.standard.set(panelScore, forKey: panelScoreKey)
            panelScoreLabel.text = String(panelScore)
        }
    }
    var audienceScore = 0 {
        didSet {
            UserDefaults.standard.set(audienceScore, forKey: audienceScoreKey)
            audienceScoreLabel.text = String(audienceScore)
        }
    }
    
    var panelAskedCount = 0 {
        didSet {
            UserDefaults.standard.set(panelAskedCount, forKey: panelAskedKey)
            panelAskedLabel.text = "\(panelAskedCount) Asked"
            panelAskedStepper.value = Double(panelAskedCount)
        }
    }
    var audienceAskedCount = 0 {
        didSet {
            UserDefaults.standard.set(audienceAskedCount, forKey: audienceAskedKey)
            audienceAskedLabel.text = "\(audienceAskedCount) Asked"
            audienceAskedStepper.value = Double(audienceAskedCount)
        }
    }

    let panelScoreKey = "panelScoreKey"
    let audienceScoreKey = "audienceScoreKey"
    let panelAskedKey = "panelAskedKey"
    let audienceAskedKey = "audienceAskedKey"
    
    var lastUpdatedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UserDefaults.standard.register(defaults: [panelScoreKey : 0, audienceScoreKey: 0, panelAskedKey: 0, audienceAskedKey: 0])
        let savedPanelScore = UserDefaults.standard.object(forKey: panelScoreKey) as! NSNumber
        panelScore = savedPanelScore.intValue
        let savedAudienceScore = UserDefaults.standard.object(forKey: audienceScoreKey) as! NSNumber
        audienceScore = savedAudienceScore.intValue
        
        panelScoreLabel.text = String(panelScore)
        audienceScoreLabel.text = String(audienceScore)
        
        panelAskedCount = UserDefaults.standard.integer(forKey: panelAskedKey)
        audienceAskedCount = UserDefaults.standard.integer(forKey: audienceAskedKey)
        
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
        panelScore += 1
        lastUpdatedDate = Date()
    }
    
    @IBAction func lowerPanelScore(_ sender: AnyObject) {
        panelScore -= 1
        lastUpdatedDate = Date()
    }
    
    @IBAction func panelPlusTen(_ sender: Any) {
        panelScore += 10
        lastUpdatedDate = Date()
    }
    
    @IBAction func raiseAudienceScore(_ sender: AnyObject) {
        audienceScore += 1
        lastUpdatedDate = Date()
    }

    @IBAction func lowerAudienceScore(_ sender: AnyObject) {
        audienceScore -= 1
        lastUpdatedDate = Date()
    }
    
    @IBAction func audiencePlusTen(_ sender: Any) {
        audienceScore += 10
        lastUpdatedDate = Date()
    }
    
    @IBAction func panelQuestionCountChange(_ sender: UIStepper) {
        panelAskedCount = Int(sender.value)
        lastUpdatedDate = Date()
    }
    
    @IBAction func audienceQuestionCountChanged(_ sender: UIStepper) {
        audienceAskedCount = Int(sender.value)
        lastUpdatedDate = Date()
    }
    
    @IBAction func resetScores(_ sender: AnyObject) {
        let resetAlert = UIAlertController(title: "Are you sure?",
                                           message: "Really reset the scores? There is no 'undo'",
                                           preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Reset",
                                        style: .destructive) { (_) in
                                            self.panelScore = 0
                                            self.audienceScore = 0
                                            self.lastUpdatedDate = Date()
        }
        resetAlert.addAction(resetAction)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default,
                                         handler: nil)
        resetAlert.addAction(cancelAction)
        
        self.present(resetAlert, animated: true, completion: nil)
    }
}

