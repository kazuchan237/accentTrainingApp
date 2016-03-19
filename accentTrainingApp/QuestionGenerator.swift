//
//  QuestionGenerator.swift
//  neaterDifferent
//
//  Created by HochinKazuma on 18/03/2016.
//  Copyright © 2016 k. All rights reserved.
//

import Foundation


class QuestionGenerator{
    let quizChoice: QuizChoice?
    let questionSets = [
        ["back","bark","beck","buck"],
        ["ban","barn","ben","bun"],
        ["hate","heat","height","hit"],
        ["lake","leak","lick","like"],
        ["wait","wheat","white","wit"]
    ]
    var askedQuestions = [Int]()
    var answer: String?
    var questionSetIndex: Int? //which set ie. back, bark set = 0
    var answerIndex: Int? // index of answer ie. beck = 2
    
    
    init(completQuizChoice: QuizChoice){
        self.quizChoice = completQuizChoice
    }
    
    func checkAnswered(index: Int)->Bool{
        for askedIndex in askedQuestions{
            if index == askedIndex{
                return true
            }
        }
        return false
    }
    func generateQuestion(){
        repeat{questionSetIndex = Int(arc4random_uniform(UInt32(5)))}
            while(checkAnswered(questionSetIndex!))
        askedQuestions.append(questionSetIndex!)
        answerIndex = Int(arc4random_uniform(UInt32(questionSets[questionSetIndex!].count)))
        answer = questionSets[questionSetIndex!][answerIndex!]
    }
    
    func getQuestionFileName()->String{ // returns the name of the file in the format: london_anna_back
        let accent = quizChoice!.getQuizAccent()
        let speakerName = quizChoice!.getQuizSpeaker()
        return "\(accent)_\(speakerName)_\(answer!)"
    }
    
    func getQuestionSet() -> [String] {
        return questionSets[questionSetIndex!]
    }
    
    func getAnswer()-> String {
        return answer!
    }
    
    
    
    
    
}