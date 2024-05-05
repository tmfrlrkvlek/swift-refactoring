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

protocol AmountCalculator {
    var amount: Int { get }
}

class PerformanceCalculator {
    let performance: Performance
    let play: Play
    
    var volumeCredits: Int {
        var result = 0
        result += max(self.performance.audience - 30, 0)
        if (self.play.type == .comedy) {
            result += Int(self.performance.audience / 5)
        }
        return result
    }
    
    init(performance: Performance, play: Play) {
        self.performance = performance
        self.play = play
    }
}

func createPerformanceCalculator(performance: Performance, play: Play) -> PerformanceCalculator & AmountCalculator {
    switch play.type {
    case .tragedy : return TragedyCalculator(performance: performance, play: play)
    case .comedy : return ComedyCalculator(performance: performance, play: play)
    }
}

final class TragedyCalculator: PerformanceCalculator, AmountCalculator {
    var amount: Int {
        var result = 40000
        if (self.performance.audience > 30) {
            result += 1000 * (self.performance.audience - 30)
        }
        return result
    }
}

final class ComedyCalculator: PerformanceCalculator, AmountCalculator {
    var amount: Int {
        var result = 30000
        if (self.performance.audience > 20) {
            result += 10000 + 500 * (self.performance.audience - 20)
        }
        result += 300 * self.performance.audience
        return result
    }
}
