//
//  QuestionViewController.swift
//  neaterDifferent
//
//  Created by HochinKazuma on 18/03/2016.
//  Copyright © 2016 k. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class QuestionViewController: CustomViewController {
    
    var questionChoice: QuizChoice?
    var audioPlayer: AVAudioPlayer?
    var questionGenerator: QuestionGenerator?
	var replayButton = UIButton()
	var questionNumber = 1
	var testModeColor = UIColor.clearColor()
    var counter = 0
    var stopCount = 0
    var userScore = 0
	@IBOutlet weak var quitQuizButton: UIButton!
	@IBOutlet weak var restartQuizButton: UIButton!
	
	
    override func viewDidLoad(){
        super.viewDidLoad()
		audioPlayer = AVAudioPlayer()
        questionGenerator = QuestionGenerator(completQuizChoice: questionChoice!)
		
		if questionGenerator?.quizChoice?.getQuizType() == "practice" {
			testModeColor = appColors["practice"]!
		} else {
			testModeColor = appColors["timetrial"]!
		}
		quitQuizButton.setTitleColor(testModeColor, forState: .Normal)
		restartQuizButton.setTitleColor(testModeColor, forState: .Normal)

		setUpReplayButton()
		
		// delay after speaker selected and before audio plays to prepare user
        delay(1.15){
            self.generateQuestion()
        }
    }
	
	func setUpReplayButton(){
		let image = UIImage(named: "speaker")
		replayButton.frame = CGRectMake(
			CGFloat(self.view.frame.width * 0.2),
			CGFloat(self.view.frame.height * 0.15),
			CGFloat(self.view.frame.width * 0.6),
			(image?.size.height)!
		)
		replayButton.setImage(image, forState: .Normal)
		replayButton.titleLabel?.hidden = true
		replayButton.imageView?.contentMode = .Center
        replayButton.addTarget(self, action: #selector(QuestionViewController.replaySound(_:)), forControlEvents: .TouchUpInside)
		self.view.addSubview(replayButton)
	}
	
	func replaySound(sender: CustomButton){
		playSound((questionGenerator?.getQuestionFileName())!)
	}
    
    func generateQuestion(){
        
        removeViews(1)
        questionGenerator?.generateQuestion()
        let fileName = questionGenerator?.getQuestionFileName()
        let percentage = (Double(userScore) / Double(questionChoice!.getQuizLengthInt()))*100
        print("\(percentage)%")
        playSound(fileName!)
		
		self.displayButtons(self.questionGenerator!.getQuestionSet(), nextFunction: #selector(QuestionViewController.questionButtonPressed(_:)))
		
    }
    
    //gets the audio file in the assets and plays
    func playSound(fileName:String){
        
        if let asset = NSDataAsset(name:fileName) {
            do {
                try audioPlayer = AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                audioPlayer!.play()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    @IBAction func quitPressed(sender: UIButton) {
        self.stopCount = 1
        self.audioPlayer!.stop()
    }
    
    func putButtonBack(button: CustomButton){ //to put the button back to its original state
        button.backgroundColor = appColors["lightGrey"]
        button.setTitleColor(appColors["darkGrey"], forState: .Normal)
    }
    
    func feedbackForWrong(wrongButton: CustomButton, correctButton: CustomButton, wrongFile: String, correctFile: String){
        if(stopCount == 1){return}
        wrongButton.setTitleColor(self.appColors["white"], forState: .Normal)
        wrongButton.backgroundColor = appColors["incorrectRed"]
        playSound(wrongFile)
        delay(1){
            self.putButtonBack(wrongButton)
            self.delay(0.8){
                if(self.stopCount == 1){return}
                correctButton.setTitleColor(self.appColors["white"], forState: .Normal)
                correctButton.backgroundColor = self.appColors["correctGreen"]
                self.playSound(correctFile)
                self.delay(1.4){
                    self.playSound(correctFile)
                }
            }
        }
    }
    
    
    func questionButtonPressed(sender: CustomButton){
        var time: Double
		sender.setTitleColor(appColors["white"], forState: .Normal)
		if sender.currentTitle! == questionGenerator?.getAnswer(){
			// if correct answer selected
            
            questionGenerator?.changeRhymeProb((questionGenerator?.rhymeSetIndex!)!, value: 0.5) //reduce the probability of asking correct rhyme
            
            playSound("feedback-correct")
            sender.backgroundColor = appColors["correctGreen"]
            userScore = userScore + 1
			time = 1.3
        } else {
			// if wrong answer selected
            
            self.playSound("feedback-wrong")
            sender.backgroundColor = appColors["incorrectRed"]
            
            questionGenerator?.changeRhymeProb((questionGenerator?.rhymeSetIndex!)!, value: 1.5) // increase the probability of wrong rhyme
            
            if self.questionChoice?.getQuizType() == "practice" {
				
				// feedback only for practice mode
                delay(1){
                    let accent = self.questionChoice!.getQuizAccent()
                    let speakerName = self.questionChoice!.getQuizSpeaker()
                    let answer: String = sender.currentTitle!
                    let wrongFileName =  "\(accent)_\(speakerName)_\(answer)"
                    let correctFileName = self.questionGenerator?.getQuestionFileName()
                    for view in self.view.subviews as [UIView] {

                        if let correctB = view as? CustomButton {
                            if correctB.currentTitle! == self.questionGenerator?.getAnswer(){
								
								//duplicating code here, but the for loop didn't work for some reason?
                                self.feedbackForWrong(sender, correctButton: correctB, wrongFile: wrongFileName, correctFile: correctFileName!)
                            }
                        }
                    }
                }
                time = 6
            }else {
				time = 1.3
			}
        }
		questionNumber += 1
        delay(time) {
            if(self.stopCount == 1){return}
            else if(self.questionNumber == ((self.questionChoice?.getQuizLengthInt())!+1)){ // session completed 
                self.audioPlayer!.stop()
                if let resultController = self.storyboard!.instantiateViewControllerWithIdentifier("HighscoresController") as? HighscoresController{
                    self.presentViewController(resultController, animated: true, completion: nil)
                }
            }
            else{self.generateQuestion()}
        }
    }
	
	func displayButtons(buttonLabelSet: [String], nextFunction: Selector){

		var counter = 0
		
		//select (x, y, width, height) based on actual view dimensions
		let viewHeight = Float(self.view.frame.height);
		let viewWidth = Float(self.view.frame.width);
		let gutterWidth: Float = 20;
		let buttonWidth: Float = (viewWidth - (3 * gutterWidth))/2
		
		//get 70% of height, remove gutter space and divide remaining area by 3
		let buttonHeight = (((viewHeight) * 0.75) - (4 * gutterWidth)) / 3
		
		for label in buttonLabelSet {
			
			let customButton = CustomButton(
				frame: CGRect(
					x: Int(gutterWidth + (gutterWidth + buttonWidth) * Float(counter % 2)),
					y: Int((gutterWidth + buttonHeight) * Float( counter / 2) + (viewHeight * 0.45)),
					width: Int(buttonWidth),
					height: Int(buttonHeight))
			)
			customButton.setTitleColor(appColors["darkGrey"], forState: .Normal)
			customButton.setTitle(label, forState: .Normal)
			customButton.titleLabel?.font = UIFont(name: "Arial", size: 24)
			customButton.addTarget(self, action: nextFunction, forControlEvents: .TouchUpInside)
			customButton.backgroundColor = appColors["lightGrey"]
            fadeInToSubview(customButton, delay: 0.25, completionAction: nil)
			customButton.tag = 1
			counter = counter + 1
		}
		
		let quizTotalLabel = UILabel(frame: CGRect(
			x: Int(gutterWidth),
			y: Int(viewHeight - viewHeight * 0.075),
			width: Int(viewWidth - 2 * gutterWidth),
			height: Int(viewHeight * 0.075)
			))
		let quizTotalLabelBackground = UIView(frame: CGRect(
			x: Int(gutterWidth),
			y: Int((gutterWidth + buttonHeight) * 2 + (viewHeight * 0.45)),
			width: Int(viewWidth - 2 * gutterWidth),
			height: Int(viewHeight * 0.2)
			))
		quizTotalLabel.textColor = appColors["white"]
		quizTotalLabel.text = "\(questionNumber) of \(questionChoice!.getQuizLengthInt())"
		quizTotalLabel.font = UIFont(name: "Arial", size: 20)
		quizTotalLabel.textAlignment = .Center
		
		quizTotalLabelBackground.layer.cornerRadius = 10
		quizTotalLabelBackground.backgroundColor = testModeColor
		
		self.view.addSubview(quizTotalLabelBackground)
		self.view.addSubview(quizTotalLabel)
		
	}
   

}