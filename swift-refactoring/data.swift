//
//  data.swift
//  swift-refactoring
//
//  Created by 이지수 on 4/28/24.
//

import Foundation

enum StatementError: Error {
    case playIDNotMatched
}

struct StatementData {
    let customer: String
    let performances: [EnrichedPerformance]
}

struct IntermediatePerformance {
    let play: Play
    let audience: Int
}

struct EnrichedStatementData {
    let customer: String
    let performances: [EnrichedPerformance]
    let totalAmount: Int
    let totalVolumeCredits: Int
}

struct EnrichedPerformance {
    let play: Play
    let audience: Int
    let amount: Int
    let volumeCredits: Int
}

func createStatementData(invoice: Invoice, plays: Plays) throws -> EnrichedStatementData {
    return enrich(StatementData(
        customer: invoice.customer,
        performances: try invoice.performances.map(enrich(_:)))
    )
    
    func enrich(_ data: StatementData) -> EnrichedStatementData {
        return EnrichedStatementData(
            customer: data.customer,
            performances: data.performances,
            totalAmount: totalAmount(data: data),
            totalVolumeCredits: totalVolumeCredits(data: data)
        )
    }
    
    func enrich(_ performance: Performance) throws -> EnrichedPerformance {
        let calculator = createPerformanceCalculator(
            performance: performance,
            play: try playFor(performance)
        )
        let intermediateResult = IntermediatePerformance(
            play: try playFor(performance),
            audience: performance.audience
        )
        return EnrichedPerformance(
            play: intermediateResult.play,
            audience: intermediateResult.audience,
            amount: calculator.amount,
            volumeCredits: calculator.volumeCredits
        )
    }
    
    func playFor(_ performance: Performance) throws -> Play {
        guard let play =  plays[performance.playID] else {
            throw StatementError.playIDNotMatched
        }
        return play
    }
    
    func totalAmount(data: StatementData) -> Int {
        return data.performances.map({ $0.amount }).reduce(0, +)
    }
    
    func totalVolumeCredits(data: StatementData) -> Int {
        return data.performances.map({ $0.volumeCredits }).reduce(0, +)
    }
}
