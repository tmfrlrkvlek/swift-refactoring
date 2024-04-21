//
//  UnitTest.swift
//  UnitTest
//
//  Created by 이지수 on 4/21/24.
//

import XCTest

final class UnitTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let invoice = Invoice(customer: "BigCo",
                              performances: [
                                Performance(playID: "hamlet", audience: 55),
                                Performance(playID: "as-like", audience: 35),
                                Performance(playID: "othello", audience: 40)
                              ])
        let plays = [
            "hamlet" : Play(name: "Hamlet", type: .tragedy),
            "as-like" : Play(name: "As You Like it", type: .comedy),
            "othello" : Play(name: "Othello", type: .tragedy)
        ]
        let result = try? statement(invoice: invoice, plays: plays)
        let expectedResult = """
청구 내역 (고객명: BigCo)
 Hamlet: $650 (55석)
 As You Like it: $580 (35석)
 Othello: $500 (40석)
총액: $17300
적립 포인트: 47점

"""
        
        XCTAssertEqual(result, expectedResult)
    }
    
    func testErrorExample() throws {
        let invoice = Invoice(customer: "BigCo",
                              performances: [
                                Performance(playID: "hamlet", audience: 55),
                                Performance(playID: "as-like", audience: 35),
                                Performance(playID: "othello", audience: 40)
                              ])
        let plays = [
            "hamlet_error" : Play(name: "Hamlet", type: .tragedy),
            "as-like" : Play(name: "As You Like it", type: .comedy),
            "othello" : Play(name: "Othello", type: .tragedy)
        ]
        do {
            let _ = try statement(invoice: invoice, plays: plays)
            XCTFail()
        } catch {
            XCTAssertEqual(error as? StatementError, StatementError.playIDNotMatched)
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
