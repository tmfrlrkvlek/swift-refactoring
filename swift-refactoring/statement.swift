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

private struct StatementData {
    let customer: String
    let performances: [EnrichedPerformance]
}

private struct IntermediatePerformance {
    let play: Play
    let audience: Int
}

private struct EnrichedStatementData {
    let customer: String
    let performances: [EnrichedPerformance]
    let totalAmount: Int
    let totalVolumeCredits: Int
}

private struct EnrichedPerformance {
    let play: Play
    let audience: Int
    let amount: Int
    let volumeCredits: Int
}

func statement(invoice: Invoice, plays: Plays) throws -> String {
    return renderPlainText(data: enrich(StatementData(
        customer: invoice.customer,
        performances: try invoice.performances.map(enrich(_:)))
    ))
    
    func enrich(_ data: StatementData) -> EnrichedStatementData {
        return EnrichedStatementData(
            customer: data.customer,
            performances: data.performances,
            totalAmount: totalAmount(data: data),
            totalVolumeCredits: totalVolumeCredits(data: data)
        )
    }
    
    func enrich(_ performance: Performance) throws -> EnrichedPerformance {
        let intermediateResult = IntermediatePerformance(
            play: try playFor(performance),
            audience: performance.audience
        )
        return EnrichedPerformance(
            play: intermediateResult.play,
            audience: intermediateResult.audience,
            amount: amountFor(intermediateResult),
            volumeCredits: volumeCreditsFor(intermediateResult)
        )
    }
    
    func playFor(_ performance: Performance) throws -> Play {
        guard let play =  plays[performance.playID] else {
            throw StatementError.playIDNotMatched
        }
        return play
    }
    
    func amountFor(_ performance: IntermediatePerformance) -> Int {
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
    
    func volumeCreditsFor(_ performance: IntermediatePerformance) -> Int {
        var result = 0
        result += max(performance.audience - 30, 0)
        if (performance.play.type == .comedy) {
            result += Int(performance.audience / 5)
        }
        return result
    }
    
    func totalAmount(data: StatementData) -> Int {
        return data.performances.map({ $0.amount }).reduce(0, +)
    }
    
    func totalVolumeCredits(data: StatementData) -> Int {
        return data.performances.map({ $0.volumeCredits }).reduce(0, +)
    }
}

private func renderPlainText(data: EnrichedStatementData) -> String {
    var result = data.performances.reduce("청구 내역 (고객명: \(data.customer))\n", { before, performance in
        return before +
        " \(performance.play.name): $\(performance.amount/100) (\(performance.audience)석)\n"
    })
    result += "총액: $\(data.totalAmount/10)\n"
    result += "적립 포인트: \(data.totalVolumeCredits)점\n"
    return result
}
