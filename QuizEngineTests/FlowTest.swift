//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Rohit Saini on 15/01/22.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest:XCTestCase{
    let router = RouterSpy()
    
    func test_start_withNoQuestion_doestNotRouteToQuestion(){
        makeSUT(questions: []).start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }

    func test_start_withOneQuestion_RouteToCorrectQuestion(){
        makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_start_withOneQuestion_RouteToCorrectQuestion2(){
        makeSUT(questions: ["Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }

    func test_start_withTwoQuestion_RouteToFirstQuestion(){
        makeSUT(questions: ["Q1","Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_startTwice_withTwoQuestion_RouteToFirstQuestionTwice(){
        let sut = makeSUT(questions: ["Q1","Q2"])
        sut.start()
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1","Q1"])
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestion_RouteToSecondQuestion(){
        let sut = makeSUT(questions: ["Q1","Q2"])
        sut.start()
        router.answerCallback("A1")
        XCTAssertEqual(router.routedQuestions, ["Q1","Q2"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestion_RouteToSecondAndThirdQuestion(){
        let sut = makeSUT(questions: ["Q1","Q2","Q3"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        XCTAssertEqual(router.routedQuestions, ["Q1","Q2","Q3"])
    }
    
    func test_startAndAnswerFirst_withOneQuestion_doesNotRouteToAnotherQuestion(){
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        router.answerCallback("A1")
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestion_RouteToResult(){
        makeSUT(questions: []).start()
        XCTAssertEqual(router.routedResult!, [:])
    }
    
    func test_start_withOneQuestion_doestNotRouteToResult(){
        makeSUT(questions: ["Q1"]).start()
        XCTAssertNil(router.routedResult)
    }
    func test_start_AndAnswerFirstAndSecondQuestion_withTwoQuestionRouteToResult(){
        let sut = makeSUT(questions: ["Q1","Q2"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        XCTAssertEqual(router.routedResult!, ["Q1":"A1","Q2":"A2"])
    }
    //MARK: - Helpers
    func makeSUT(questions: [String]) -> Flow{
        return Flow(questions: questions, router: router)
    }

    class RouterSpy: Router{
        var routedQuestions: [String] = []
        var routedResult: [String:String]? = nil
        var answerCallback: Router.AnswerCallback = { _ in }
        func routeTo(question: String, answerCallback: @escaping Router.AnswerCallback) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
            
        }
        func routeTo(result: [String : String]) {
            routedResult = result
        }
    }
}












