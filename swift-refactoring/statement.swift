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

private typealias StatementData = (customer: String, performances: [EnrichedPerformance])

private struct EnrichedPerformance {
    let play: Play
    let audience: Int
    let amount: Int
}

func statement(invoice: Invoice, plays: Plays) throws -> String {
    let data: StatementData
    data.customer = invoice.customer
    var performances: [EnrichedPerformance] = []
    for performance in invoice.performances {
        performances.append(try enrich(performance))
    }
    data.performances = performances
    return renderPlainText(data: data)
    
    func enrich(_ performance: Performance) throws -> EnrichedPerformance {
        let intermediateResult = EnrichedPerformance(
            play: try playFor(performance),
            audience: performance.audience,
            amount: 0
        )
        return EnrichedPerformance(
            play: intermediateResult.play,
            audience: intermediateResult.audience,
            amount: amountFor(intermediateResult)
        )
    }
    
    func playFor(_ performance: Performance) throws -> Play {
        guard let play =  plays[performance.playID] else {
            throw StatementError.playIDNotMatched
        }
        return play
    }
    
    func amountFor(_ performance: EnrichedPerformance) -> Int {
        var result = 0
        switch performance.play.type {
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

private func renderPlainText(data: StatementData) -> String {
    var result = "청구 내역 (고객명: \(data.customer))\n"
    for performance in data.performances {
        result += " \(performance.play.name): $\(performance.amount/100) (\(performance.audience)석)\n"
    }
    result += "총액: $\(totalAmount()/10)\n"
    result += "적립 포인트: \(totalVolumeCredits())점\n"
    return result
    
    func totalAmount() -> Int {
        var result = 0
        for performance in data.performances {
            result += performance.amount
        }
        return result
    }
    
    func totalVolumeCredits() -> Int {
        var result = 0
        for performance in data.performances {
            result += volumeCreditsFor(performance)
        }
        return result
    }
    
    func volumeCreditsFor(_ performance: EnrichedPerformance) -> Int {
        var result = 0
        result += max(performance.audience - 30, 0)
        if (performance.play.type == .comedy) {
            result += Int(performance.audience / 5)
        }
        return result
    }
}
