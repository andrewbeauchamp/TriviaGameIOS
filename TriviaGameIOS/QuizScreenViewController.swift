//
//  QuizScreenViewController.swift
//  TriviaGameIOS
//
//  Created by Andrew Beauchamp on 10/19/18.
//  Copyright © 2018 Andrew Beauchamp. All rights reserved.
//

import UIKit

class QuizScreenViewController: UIViewController {
    //Properties
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerAButton: UIButton!
    @IBOutlet weak var answerBButton: UIButton!
    @IBOutlet weak var answerCButton: UIButton!
    @IBOutlet weak var answerDButton: UIButton!
    
    @IBAction func resetGameTapped(_ sender: Any) {
        resetGame()
    }
    //Initalize array to hold our questions
    var questions = [TriviaQuestion] ( )
    
    var questionsPlaceHolder = [TriviaQuestion] ( )
    
    //Property observer for our score when someone gets a question right
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var currentIndex: Int!
    var currentQuestion: TriviaQuestion! {
        didSet {
            //setting the questions in an array so that they will appear to be random when a user loads up the program
            if let currentQuestion = currentQuestion{
                questionLabel.text = currentQuestion.question
                answerAButton.setTitle(currentQuestion.answers [0], for: .normal)
                answerBButton.setTitle(currentQuestion.answers [1], for: .normal)
                answerCButton.setTitle(currentQuestion.answers [2], for: .normal)
                answerDButton.setTitle(currentQuestion.answers [3], for: .normal)
                setNewColors()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        populateQuestions( )
        setNewColors( )
        getNewQuestion( )
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToQuizScreen(segue: UIStoryboardSegue) {}
    
    
    //Populate questions array for testing the app and having default questions
    func populateQuestions ( ) {
        let question1 = TriviaQuestion(question: "How it do?", answers: ["it do", "it don't", "good", "bad"], correctAnswerIndex: 0)
        let question2 = TriviaQuestion(question: "How do you signal an SOS when stranded on a beach?", answers: ["deal with it yourself", "Have fun", "Just write SOS lol", "Smoke puffs"], correctAnswerIndex: 2)
        let question3 = TriviaQuestion(question: "Who killed Franz Ferdinand?", answers: ["Some Guy", "Time Travelers", "The Muffin man", "Gavrillo Princip"], correctAnswerIndex: 3)
        questions.append(question1)
        questions.append(question2)
        questions.append(question3)
    }
    //colors used for randomizing
    let backgroundColors = [
        UIColor(red: 255/255, green: 70/255, blue: 70/255, alpha:1.0),
         UIColor(red: 100/255, green: 180/255, blue: 175/255,   alpha:1.0),
         UIColor(red: 200/255, green: 230/255, blue: 100/255,   alpha:1.0),
         UIColor(red: 30/255, green: 15/255, blue: 120/255,   alpha:1.0),
          UIColor(red: 90/255, green: 79/255, blue: 165/255,   alpha:1.0)
    ]
    
    func setNewColors () {
        //Makes a random color generator so we can get a different value color in the backgroundColors and is divided by five for each color you have
        let randomNumber = Int.random(in: 1...100000000000)
        let randomColorA = backgroundColors[(randomNumber + 1)%5]
        let randomColorB = backgroundColors[(randomNumber + 2)%5]
        let randomColorC = backgroundColors[(randomNumber + 3)%5]
        let randomColorD = backgroundColors[(randomNumber + 4)%5]
        
        answerAButton.backgroundColor = randomColorA
        answerBButton.backgroundColor = randomColorB
        answerCButton.backgroundColor = randomColorC
        answerDButton.backgroundColor = randomColorD
    }
    //used to get a new question from the array and display it for the user
    func getNewQuestion ( ) {
        if questions.count > 0 {
            currentIndex = Int.random(in: 0..<questions.count)
            currentQuestion = questions[currentIndex]
        } else{
            //Make a function for game over scenario
            showGameOverAlert()
        }
    }
    //gives the user 1 point if they get the answer right and when they do it shows an alert to tell them they got it right and if it's incorrect a different alert appears and doesn't add a point to the variable score
    @IBAction func answerTapped(_ sender: UIButton) {
        print(sender.tag)
        if currentQuestion.correctAnswerIndex == sender.tag {
            score += 1
            showCorrectAnswerAlert()
        } else {
            showIncorrectAnswerAlert()
        }
    }
    //The alert used to show the user that they got a correct answer
    func showCorrectAnswerAlert () {
        let correctAlert = UIAlertController (title: "!Correct!", message: "\(currentQuestion.correctAnswer) is the correct answer great work!", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Thank you!", style: UIAlertAction.Style.default) {UIAlertAction in
            self.questionsPlaceHolder.append(self.questions[self.currentIndex] )
            self.questions.remove(at: self.currentIndex)
            self.getNewQuestion()
        }
        correctAlert.addAction(okAction)
        self.present(correctAlert, animated: true, completion: nil)
    }
    //The alert used to show the user that they got a incorrect answer
    func showIncorrectAnswerAlert () {
        let inCorrectAlert = UIAlertController (title: "Incorrect.", message: "\(currentQuestion.correctAnswer) is the incorrect answer.", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Real sorry about that.", style: UIAlertAction.Style.default) {UIAlertAction in
            self.questionsPlaceHolder.append(self.questions[self.currentIndex] )
            self.questions.remove(at: self.currentIndex)
            self.getNewQuestion()
    }
        inCorrectAlert.addAction(okAction)
        self.present(inCorrectAlert, animated: true, completion: nil)
    }
    //The alert that shows when the user has answered all questions and it shows how many questions the user got right
    func showGameOverAlert ( ) {
        let endAlert = UIAlertController(title: "Trivia Results", message: "Game over! your score was \(score) out of \(questionsPlaceHolder.count)", preferredStyle: UIAlertController.Style.alert)
        let resetAction = UIAlertAction(title: "Reset", style: UIAlertAction.Style.default) {UIAlertAction in
        self.resetGame()
        }
        endAlert.addAction(resetAction)
        self.present(endAlert,animated: true, completion: nil)
    }
    
    func resetGame () {
        //Need to reset game after adding a new question so the question will appear when the new game loads up
     score = 0
        if !questions.isEmpty {
            questionsPlaceHolder.append(contentsOf: questions)
            questions.removeAll()
        }
        questions = questionsPlaceHolder
        questionsPlaceHolder.removeAll()
        getNewQuestion()
    }
    
}
