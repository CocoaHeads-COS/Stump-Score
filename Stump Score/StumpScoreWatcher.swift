//
//  StumpScoreWatcher.swift
//  Stump Score
//
//  Created by Tom Harrington on 8/7/20.
//  Copyright © 2020 Atomic Bird LLC. All rights reserved.
//

import Foundation
import Firebase

struct StumpScores: Equatable {
    enum ScoreKeys: String, CaseIterable {
        case panelScore
        case audienceScore
        case panelAskedCount
        case audienceAskedCount
    }
    
    typealias StumpScoresDict = [ScoreKeys:Int]
    typealias SnapshotDict = [String:Int]
    
    var scoreDict: StumpScoresDict
    
    /// Initialize all zeroe scores
    init() {
        scoreDict = StumpScoresDict()
        ScoreKeys.allCases.forEach { scoreDict[$0] = 0 }
    }

    /// Initialize from a Firebase snapshot
    init(stringDict: SnapshotDict) {
        scoreDict = StumpScoresDict()
        ScoreKeys.allCases.forEach {
            scoreDict[$0] = stringDict[$0.rawValue] ?? 0
        }
    }

    /// Convert to plist types for Firebase
    func stringDict() -> [String:Int] {
        var stringDict: [String:Int] = [:]
        scoreDict.forEach { stringDict[$0.key.rawValue] = $0.value }
        return stringDict
    }
    
    /// Wrap dictionary access with a subscript
    subscript(key: ScoreKeys) -> Int {
        get {
            return scoreDict[key] ?? 0
        }
        set {
            scoreDict[key] = newValue
        }
    }
}

class StumpScoreWatcher {
    var scoreRef: DatabaseReference!
    var ref: DatabaseReference!
    var score = StumpScores() {
        didSet {
            self.scoreReceived?(score)
        }
    }
    var scoreReceived: ((StumpScores) -> Void)?
    
    let scoresPath = "stumpScores"
    
    func sync(scores: StumpScores) -> Void {
        self.score = scores
        let scoreDict = scores.stringDict()
        print("Sending update: \(scoreDict)")
        scoreRef.setValue(scoreDict)
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
        guard let scoreStringDict = snapshot.value as? StumpScores.SnapshotDict else { return }
        let score = StumpScores(stringDict: scoreStringDict)
        self.score = score
        print("New score value: \(score)")
    }
}
