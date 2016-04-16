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
	var quizLength = 0
    var counter = 0
    var stopCount = 0
    var userScore = 0
	@IBOutlet weak var quitQuizButton: UIButton!
	@IBOutlet weak var restartQuizButton: UIButton!
	
	
    override func viewDidLoad(){
        super.viewDidLoad()
		audioPlayer = AVAudioPlayer()
        questionGenerator = QuestionGenerator(completQuizChoice: questionChoice!)
		quizLength = questionChoice!.getQuizLengthInt()
		
		setUpReplayButton()
		
		// delay after speaker selected and before audio plays to prepare user
        delay(0.5){
            self.generateQuestion()
        }
    }
	
	func replaySound(sender: CustomButton){
		playSound((questionGenerator?.getQuestionFileName())!)
	}
    
    func generateQuestion(){
        
        removeViews(1)
        questionGenerator?.generateQuestion()
        let fileName = questionGenerator?.getQuestionFileName()
        let percentage = Double(userScore) / Double(quizLength)
		print("\(userScore/100), \(quizLength)")
		print("\(percentage)")
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
    
    func returnToDefaultState(button: CustomButton){ //to put the button back to its original state
        button.backgroundColor = appColors["lightGrey"]
        button.setTitleColor(appColors["darkGrey"], forState: .Normal)
    }
    
    func feedbackForWrong(wrongButton: CustomButton, correctButton: CustomButton, wrongFile: String, correctFile: String){
        if stopCount != 1 {
			wrongButton.setTitleColor(self.appColors["white"], forState: .Normal)
			wrongButton.backgroundColor = appColors["incorrectRed"]
			playSound(wrongFile)
			delay(1.2){
				self.returnToDefaultState(wrongButton)
				
				if(self.stopCount != 1){
					correctButton.setTitleColor(self.appColors["white"], forState: .Normal)
					correctButton.backgroundColor = self.appColors["correctGreen"]
					self.playSound(correctFile)
					self.delay(1){
						self.returnToDefaultState(correctButton)
					}
				}
			}
		}
    }   

}