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

func statement(invoice: Invoice, plays: Plays) -> String {
    var totalAmount = 0
    var volumeCredits = 0
    var result = "청구 내역 (고객명: \(invoice.customer))\n"

    for performance in invoice.performances {
        guard let play = plays[performance.playID] else { continue }
        let amount = amountFor(performance: performance, with: play)

        volumeCredits += max(performance.audience - 30, 0)
        if (play.type == .comedy) {
            volumeCredits += Int(performance.audience / 5)
        }

        result += " \(play.name): $\(amount/100) (\(performance.audience)석)\n"
        totalAmount += amount
    }

    result += "총액: $\(totalAmount/10)\n"
    result += "적립 포인트: \(volumeCredits)점\n"
    return result
    
    func amountFor(performance: Performance, with play: Play) -> Int {
        var amount = 0
        switch play.type {
        case .tragedy :
            amount = 40000
            if (performance.audience > 30) {
                amount += 1000 * (performance.audience - 30)
            }
        case .comedy :
            amount = 30000
            if (performance.audience > 20) {
                amount += 10000 + 500 * (performance.audience - 20)
            }
            amount += 300 * performance.audience
        }
        return amount
    }
}

