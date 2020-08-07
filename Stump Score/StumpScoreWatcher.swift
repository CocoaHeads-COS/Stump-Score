//
//  StumpScoreWatcher.swift
//  Stump Score
//
//  Created by Tom Harrington on 8/7/20.
//  Copyright © 2020 Atomic Bird LLC. All rights reserved.
//

import Foundation
import Firebase

struct StumpScores: Codable, Equatable {
    var panelScore = 0
    var audienceScore = 0
    var panelAskedCount = 0
    var audienceAskedCount = 0
}

class StumpScoreWatcher {
    var scoreRef: DatabaseReference!
    var ref: DatabaseReference!
    var score = StumpScores() {
        didSet {
            self.scoreReceived?(score)
        }
    }
    var startDate = Date()
    
    var scoreReceived: ((StumpScores) -> Void)?
    
    let scoresPath = "stumpScores"
    
    func sync(scores: StumpScores) -> Void {
        self.score = scores
        guard let scoreData = try? JSONEncoder().encode(scores) else {
            return
        }
        let scoreDataString = String(data: scoreData, encoding: .utf8)
        scoreRef.setValue(scoreDataString)
    }
    
    func startWatching() -> Void {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        ref = Database.database().reference()
        
        scoreRef = ref.child("/\(scoresPath)/")

        // Load initial value at launch
        scoreRef.observeSingleEvent(of: .value) { (snapshot) in
            print("Single snapshot: \(snapshot)")
            self.update(from: snapshot)
        }
        
        // Get new values as they occur
        scoreRef.observe(.value) { (snapshot) in
            print("Value snapshot: \(snapshot)")
            self.update(from: snapshot)
        }
    }
    
    func update(from snapshot: DataSnapshot) -> Void {
        guard let scoreString = snapshot.value as? String else { return }
        guard let scoreData = scoreString.data(using: .utf8) else { return }
        guard let score = try? JSONDecoder().decode(StumpScores.self, from: scoreData) else { return }
        guard score != self.score else { return }
        self.score = score
        print("New score value: \(score)")
    }
}
