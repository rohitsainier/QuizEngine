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
        let sut = Flow(questions: [], router: router)
        sut.start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }

    func test_start_withOneQuestion_RouteToCorrectQuestion(){
        let sut = Flow(questions: ["Q1"], router: router)
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_start_withOneQuestion_RouteToCorrectQuestion2(){
        let sut = Flow(questions: ["Q2"], router: router)
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }

    func test_start_withTwoQuestion_RouteToFirstQuestion(){
        let sut = Flow(questions: ["Q1","Q2"], router: router)
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_startTwice_withTwoQuestion_RouteToFirstQuestionTwice(){
        let sut = Flow(questions: ["Q1","Q2"], router: router)
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1","Q1"])
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestion_RouteToSecondQuestion(){
        let sut = Flow(questions: ["Q1","Q2"], router: router)
        
        sut.start()
        router.answerCallback("A1")
        
        XCTAssertEqual(router.routedQuestions, ["Q1","Q2"])
    }

    class RouterSpy: Router{
        var routedQuestions: [String] = []
        var answerCallback: ((String) -> Void) = { _ in }
                             func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            self.answerCallback = answerCallback
            routedQuestions.append(question)
        }
    }
}












