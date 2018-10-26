//
//  AddGameViewController.swift
//  TriviaGameIOS
//
//  Created by Andrew Beauchamp on 10/19/18.
//  Copyright © 2018 Andrew Beauchamp. All rights reserved.
//

import UIKit

class AddGameViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var newQuestionTextField: UITextField!
    @IBOutlet weak var answerATextField: UITextField!
    @IBOutlet weak var answerBTextField: UITextField!
    @IBOutlet weak var answerCTextField: UITextField!
    @IBOutlet weak var answerDTextField: UITextField!
    @IBOutlet weak var correctAnswerSelector: UISegmentedControl!
    var newTriviaQuestion: TriviaQuestion! //subclass of trivia question so the same properties can be accessed and used to add to the array of questions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))//Gets rid of the keyboard when the user tapped off of it
    }
    
    
    @IBAction func AddTapped(_ sender: Any) {
        //This guard creates the constants for the textfields and makes sure that if they are empty then an error message will pop up for the user to fix the mistake and add their question or return to the Trivia Game
        guard
                let question = newQuestionTextField.text, !question.isEmpty,
                let a = answerATextField.text, !a.isEmpty,
                let b = answerBTextField.text, !b.isEmpty,
                let c = answerCTextField.text, !c.isEmpty,
                let d = answerDTextField.text, !d.isEmpty
        else {
            let errorAlert = UIAlertController(title: "Error Detected", message: "Please fill all options or press cancel to return to Trivia Game", preferredStyle: UIAlertController.Style.alert)
            let dismissAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default ) {UIAlertAction in}
                                              errorAlert.addAction(dismissAction)
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        //Makes new trivia question through a subclass of TriviaQuestion
        newTriviaQuestion = TriviaQuestion(question: question, answers: [a, b, c, d], correctAnswerIndex: correctAnswerSelector.selectedSegmentIndex)
        performSegue(withIdentifier: "unwindToQuizScreen", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard //If a newTrivia question is detected then it will be added to the questions array
            let destinationVC = segue.destination as? QuizScreenViewController, //sets the destination as destinationVC so we can access the properties of QuizScreenViewController
            let newTrivia = newTriviaQuestion 
            else  {return}
        destinationVC.questions.append(newTrivia)
        destinationVC.resetGame( )
    }
    
    //Unwind segue when the cancel button is tapped
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToQuizScreen", sender: self)
    }
}
