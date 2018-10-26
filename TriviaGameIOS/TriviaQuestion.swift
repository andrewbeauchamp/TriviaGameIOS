//
//  TriviaQuestion.swift
//  TriviaGameIOS
//
//  Created by Andrew Beauchamp on 10/19/18.
//  Copyright © 2018 Andrew Beauchamp. All rights reserved.
//

import Foundation

class TriviaQuestion {
    let question: String
    var answers: [String]
    var correctAnswerIndex: Int
    var correctAnswer: String {
        return answers [correctAnswerIndex]
    }
    init(question: String, answers: [String], correctAnswerIndex: Int) {
        self.answers = answers
        self.correctAnswerIndex = correctAnswerIndex
        self.question = question
    }
}
