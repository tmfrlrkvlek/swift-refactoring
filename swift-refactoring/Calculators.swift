//
//  Calculators.swift
//  swift-refactoring
//
//  Created by 이지수 on 5/5/24.
//

import Foundation

func createPerformanceCalculator(performance: Performance, play: Play) -> PerformanceCalculator & AmountCalculator {
    switch play.type {
    case .tragedy : return TragedyCalculator(performance: performance, play: play)
    case .comedy : return ComedyCalculator(performance: performance, play: play)
    }
}

protocol AmountCalculator {
    var amount: Int { get }
}

class PerformanceCalculator {
    let performance: Performance
    let play: Play
    
    var volumeCredits: Int {
        return max(self.performance.audience - 30, 0)
    }
    
    init(performance: Performance, play: Play) {
        self.performance = performance
        self.play = play
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
    
    override var volumeCredits: Int {
        return super.volumeCredits + Int(self.performance.audience / 5)
    }
}
