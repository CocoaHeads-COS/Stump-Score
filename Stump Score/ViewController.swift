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
    @IBOutlet weak var lastUpdatedDateLabel: UILabel!
    
    var stumpScoreWatcher: StumpScoreWatcher?
    var stumpScore = StumpScores() {
        didSet {
            panelScoreLabel.text = String(stumpScore[.panelScore])
            audienceScoreLabel.text = String(stumpScore[.audienceScore])
            panelAskedLabel.text = "Asked: \(stumpScore[.panelAskedCount])"
            audienceAskedLabel.text = "Asked: \(stumpScore[.audienceAskedCount])"
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
        
        let rawStripeImage = UIImage(named: "Cheetah stripes.png")!
        view.backgroundColor = UIColor(patternImage: rawStripeImage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func raisePanelScore(_ sender: UIButton) {
        showKeypad(title:"Add", sender: sender) { scoreChange in
            self.stumpScore[.panelScore] += scoreChange
            self.stumpScoreWatcher?.sync(scores: self.stumpScore)
        }
    }
    
    @IBAction func lowerPanelScore(_ sender: UIButton) {
        showKeypad(title:"Subtract", sender: sender) { scoreChange in
            self.stumpScore[.panelScore] -= scoreChange
            self.stumpScoreWatcher?.sync(scores: self.stumpScore)
        }
    }
    
    @IBAction func raiseAudienceScore(_ sender: UIButton) {
        showKeypad(title:"Add", sender: sender) { scoreChange in
            self.stumpScore[.audienceScore] += scoreChange
            self.stumpScoreWatcher?.sync(scores: self.stumpScore)
        }
    }

    @IBAction func lowerAudienceScore(_ sender: UIButton) {
        showKeypad(title:"Subtract", sender: sender) { scoreChange in
            self.stumpScore[.audienceScore] -= scoreChange
            self.stumpScoreWatcher?.sync(scores: self.stumpScore)
        }
    }
    
    @IBAction func speakerQPlus(_ sender: Any) {
        stumpScore[.panelAskedCount] += 1
        stumpScoreWatcher?.sync(scores: stumpScore)
    }
    
    @IBAction func speakerQMinus(_ sender: Any) {
        stumpScore[.panelAskedCount] -= 1
        stumpScoreWatcher?.sync(scores: stumpScore)
    }
    
    @IBAction func attendeeQPlus(_ sender: Any) {
        stumpScore[.audienceAskedCount] += 1
        stumpScoreWatcher?.sync(scores: stumpScore)
    }

    @IBAction func attendeeQMinus(_ sender: Any) {
        stumpScore[.audienceAskedCount] -= 1
        stumpScoreWatcher?.sync(scores: stumpScore)
    }
    
    func showKeypad(title: String, sender: UIButton, completion: @escaping (Int) -> Void) -> Void {
        guard let keypad = storyboard?.instantiateViewController(withIdentifier: "KeypadViewController") as? KeypadViewController else {
            return
        }
        keypad.finishedButtonText = title
        keypad.loadView()
        keypad.modalPresentationStyle = .popover
        keypad.popoverPresentationController?.sourceView = sender
        keypad.preferredContentSize = keypad.customContainerView.frame.size
        keypad.finished = completion
        present(keypad, animated: true) {
            print("Presentation done for \(keypad)")
        }
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

