//
//  QuizOptionsController.swift
//  neaterDifferent
//
//  Created by Mujavid Bukhari on 09/03/2016.
//  Copyright © 2016 k. All rights reserved.
//

import Foundation
import UIKit


class QuizOptionsController: CustomViewController{
    
    let quizOptions = QuizChoice()
    let lengthOptions = ["Short (15)","Medium (25)","Long (40)"]
    let accentOptions = ["London","US","Manchester","NewZealand","Australia","Glasgow"]
    let speakerOptions = [
        "London" : ["Anna","Chloe","John","Matthew"],
        "US" : ["01","04","05","06"],
        "Manchester":["01","02","03"],
        "NewZealand": ["03","04","05"],
        "Australia": ["03","04"],
        "Glasgow":["01","02","03","04"]
        // "Sheffield":["02","03","04","05"]
    ]
	var testModeColor = UIColor(red: 90/255, green: 158/255, blue: 1, alpha: 1)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		getLengthOptions()
		self.view.backgroundColor = appColors["practice"]
    }
	
    func getLengthOptions(){
        displayLabel("Choose quiz length", textColor: appColors["practice"]!)
		displaySingleColumnButtons(lengthOptions, textColor: appColors["practice"]!, nextFunction: #selector(QuizOptionsController.getAccentOptions(_:)))
    }
	
    func getAccentOptions(sender: CustomButton){
        self.quizOptions.setLength(sender.currentTitle!)
        removeViews(1)
		delay(0.3){
			self.displayLabel("Choose an accent", textColor: self.appColors["practice"]!)
			self.displayTwoColumnButtons(self.accentOptions, textColor: self.appColors["practice"]!, nextFunction:#selector(QuizOptionsController.getSpeakerOptions(_:)))
		}
    }
    
    func getSpeakerOptions(sender: CustomButton){
        self.quizOptions.setAccent(sender.currentTitle!)
        removeViews(1)
		delay(0.3){
			self.displayLabel("Choose a speaker", textColor: self.appColors["practice"]!)
			self.displayTwoColumnButtons(self.speakerOptions[self.quizOptions.getQuizAccent()]!, textColor: self.appColors["practice"]!, nextFunction: #selector(QuizOptionsController.moveToQuestionView(_:)))
		}
    }
    
    func moveToQuestionView(sender:CustomButton){
        self.quizOptions.setSpeaker(sender.currentTitle!)
        if let resultController = storyboard!.instantiateViewControllerWithIdentifier("QuestionViewController") as? QuestionViewController {
            resultController.questionChoice = self.quizOptions
            presentViewController(resultController, animated: true, completion: nil)
        }
    }
	
	func displaySingleColumnButtons(buttonLabelSet: [String], textColor: UIColor, nextFunction: Selector){
		var posX: Int
		var posY: Int
		var counter = 1
		
		let viewHeight = Float(self.view.frame.height)
		let viewWidth = Float(self.view.frame.width)
		let gutterSize = Int(viewWidth / 18.75)
		let buttonWidth = Int(viewWidth) - (2 * gutterSize)
		posX = gutterSize;
		
		let buttonHeight = Int(((Int(viewHeight * 0.5) / (buttonLabelSet.count)) - gutterSize))
		
		for label in buttonLabelSet {
			
			posY = Int(80 + (counter * (buttonHeight + gutterSize)))
			
			let customButton = CustomButton(
				frame: CGRect(x: posX, y: posY, width: buttonWidth, height: buttonHeight)
			)
			customButton.setTitleColor(textColor, forState: .Normal)
			customButton.setTitle(label, forState: .Normal)
			customButton.titleLabel!.font = UIFont(name: "Arial", size: CGFloat(viewWidth / 14.4))
			customButton.addTarget(self, action: nextFunction, forControlEvents: .TouchUpInside)
			customButton.backgroundColor = appColors["white"]
			self.view.addSubview(customButton)
			customButton.tag = 1
			counter = counter + 1
		}
	}
	
	func displayTwoColumnButtons(buttonLabelSet: [String], textColor: UIColor, nextFunction: Selector){
		
		var posX: Int
		var posY: Int
		var counter = 0
		
		//select (x, y, width, height) based on actual view dimensions
		let viewHeight = Float(self.view.frame.height);
		let viewWidth = Float(self.view.frame.width);
		let gutterWidth = viewWidth / 18.75;
		let buttonWidth = (viewWidth - (3 * gutterWidth))/2
		
		//get 75% of height, remove gutter space and divide remaining area by 3
		let buttonHeight = (((viewHeight) * 0.75) - (4 * gutterWidth)) / 3
		
		for label in buttonLabelSet {
			
			posX = Int(gutterWidth + (gutterWidth + buttonWidth) * Float(counter % 2))
			posY = Int((gutterWidth + buttonHeight) * Float( 1 + counter / 2))
			
			let customButton = CustomButton(
				frame: CGRect(x: posX, y: posY, width: Int(buttonWidth), height: Int(buttonHeight))
			)
			customButton.setTitleColor(textColor, forState: .Normal)
			customButton.setTitle(label, forState: .Normal)
			customButton.titleLabel!.font = UIFont(name: "Arial", size: CGFloat(viewWidth / 14.4))
			customButton.addTarget(self, action: nextFunction, forControlEvents: .TouchUpInside)
			customButton.backgroundColor = appColors["white"]
			self.view.addSubview(customButton)
			customButton.tag = 1
			counter = counter + 1
		}
	}
	
}