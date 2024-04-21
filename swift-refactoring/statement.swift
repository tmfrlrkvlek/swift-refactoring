//
//  statement.swift
//  swift-refactoring
//
//  Created by 이지수 on 4/21/24.
//

import Foundation

/**
 수정할 부분
 1. 청구 내역을 HTML로 출력하는 부분 필요
 2. 연극 장르와 공연료 정책이 달라질 때마다 statement() 함수를 수정해야 함
 **/

enum StatementError: Error {
    case playIDNotMatched
}

func statement(invoice: Invoice, plays: Plays) throws -> String {
    var result = "청구 내역 (고객명: \(invoice.customer))\n"
    for performance in invoice.performances {
        result += " \(try playFor(performance).name): $\(try amountFor(performance)/100) (\(performance.audience)석)\n"
    }
    result += "총액: $\(try totalAmount()/10)\n"
    result += "적립 포인트: \(try totalVolumeCredits())점\n"
    return result
    
    func totalAmount() throws -> Int {
        var result = 0
        for performance in invoice.performances {
            result += try amountFor(performance)
        }
        return result
    }
    
    func totalVolumeCredits() throws -> Int {
        var result = 0
        for performance in invoice.performances {
            result += try volumeCreditsFor(performance)
        }
        return result
    }
    
    func volumeCreditsFor(_ performance: Performance) throws -> Int {
        var result = 0
        result += max(performance.audience - 30, 0)
        if (try playFor(performance).type == .comedy) {
            result += Int(performance.audience / 5)
        }
        return result
    }
    
    func playFor(_ performance: Performance) throws -> Play {
        guard let play =  plays[performance.playID] else {
            throw StatementError.playIDNotMatched
        }
        return play
    }
    
    func amountFor(_ performance: Performance) throws -> Int {
        var result = 0
        switch try playFor(performance).type {
        case .tragedy :
            result = 40000
            if (performance.audience > 30) {
                result += 1000 * (performance.audience - 30)
            }
        case .comedy :
            result = 30000
            if (performance.audience > 20) {
                result += 10000 + 500 * (performance.audience - 20)
            }
            result += 300 * performance.audience
        }
        return result
    }
}

