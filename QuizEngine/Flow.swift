//
//  Flow.swift
//  QuizEngine
//
//  Created by Rohit Saini on 15/01/22.
//

import Foundation

protocol Router{
    typealias AnswerCallback = (String) -> Void
    func routeTo(question: String,answerCallback: @escaping AnswerCallback)
    func routeTo(result: [String: String])
}

class Flow{
    private let router: Router
    private let questions: [String]
    private var result: [String: String] = [:]
    init(questions: [String],router:Router){
        self.router = router
        self.questions = questions
    }
    
    func start(){
        if let firstQuestion = questions.first{
            router.routeTo(question: firstQuestion,answerCallback: nextCallback(from: firstQuestion))
        }
        else{
            router.routeTo(result: result)
        }
    }
    
    private func nextCallback(from question: String) -> Router.AnswerCallback{
        return { [weak self] in self?.routeNext(question, $0)}
    }
    private func routeNext(_ question: String, _ answer: String){
        if let currentQuestion = questions.firstIndex(of: question){
            result[question] = answer
            if currentQuestion + 1 < questions.count{
                let nextQuestion = questions[currentQuestion + 1]
                router.routeTo(question: nextQuestion, answerCallback: nextCallback(from: nextQuestion))
            }
            else{
                router.routeTo(result: result)
            }
        }
    }
}
