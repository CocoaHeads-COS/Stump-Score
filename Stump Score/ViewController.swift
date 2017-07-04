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
    
    let panelScoreKey = "panelScoreKey"
    let audienceScoreKey = "audienceScoreKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UserDefaults.standard.register(defaults: [panelScoreKey : 0, audienceScoreKey: 0])
        let savedPanelScore = UserDefaults.standard.object(forKey: panelScoreKey) as! NSNumber
        panelScore = savedPanelScore.intValue
        let savedAudienceScore = UserDefaults.standard.object(forKey: audienceScoreKey) as! NSNumber
        audienceScore = savedAudienceScore.intValue
        
        panelScoreLabel.text = String(panelScore)
        audienceScoreLabel.text = String(audienceScore)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func raisePanelScore(_ sender: AnyObject) {
        panelScore += 1
    }
    
    @IBAction func lowerPanelScore(_ sender: AnyObject) {
        panelScore -= 1
    }
    
    @IBAction func raiseAudienceScore(_ sender: AnyObject) {
        audienceScore += 1
    }

    @IBAction func lowerAudienceScore(_ sender: AnyObject) {
        audienceScore -= 1
    }
    
    @IBAction func resetScores(_ sender: AnyObject) {
        let resetAlert = UIAlertController(title: "Are you sure?",
                                           message: "Really reset the scores? There is no 'undo'",
                                           preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Reset",
                                        style: .destructive) { (_) in
                                            self.panelScore = 0
                                            self.audienceScore = 0
        }
        resetAlert.addAction(resetAction)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default,
                                         handler: nil)
        resetAlert.addAction(cancelAction)
        
        self.present(resetAlert, animated: true, completion: nil)
    }
}

