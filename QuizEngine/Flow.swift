//
//  Flow.swift
//  QuizEngine
//
//  Created by Rohit Saini on 15/01/22.
//

import Foundation

protocol Router{
    func routeTo(question: String,answerCallback: @escaping (String) -> Void)
}

class Flow{
    let router: Router
    let questions: [String]
    init(questions: [String],router:Router){
        self.router = router
        self.questions = questions
    }
    
    func start(){
        if let firstQuestion = questions.first{
            router.routeTo(question: firstQuestion){ [weak self] _ in
                guard let strongSelf = self else{return}
                let firstQuestionIndex = strongSelf.questions.firstIndex(of: firstQuestion)!
                let nextQuestion = strongSelf.questions[firstQuestionIndex + 1]
                strongSelf.router.routeTo(question: nextQuestion) { _ in }
            }
        }
    }
}
