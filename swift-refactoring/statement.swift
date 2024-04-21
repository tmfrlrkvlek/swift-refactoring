//
//  statement.swift
//  swift-refactoring
//
//  Created by 이지수 on 4/21/24.
//

import Foundation

func statement(invoice: Invoice, plays: Plays) -> String {
    var totalAmount = 0
    var volumeCredits = 0
    var result = "청구 내역 (고객명: \(invoice.customer))\n"

    for performance in invoice.performances {
        guard let play = plays[performance.playID] else { continue }
        var amount = 0

        switch play.type {
        case .tragedy : // 비극
            amount = 40000
            if (performance.audience > 30) {
                amount += 1000 * (performance.audience - 30)
            }
        case .comedy : // 희극
            amount = 30000
            if (performance.audience > 20) {
                amount += 10000 + 500 * (performance.audience - 20)
            }
            amount += 300 * performance.audience
        }

        // 포인트를 적립한다.
        volumeCredits += max(performance.audience - 30, 0)
        // 희극 관객 5명마다 추가 포인트를 제공한다.
        if (play.type == .comedy) {
            volumeCredits += Int(performance.audience / 5)
        }

        // 청구 내역을 출력한다.
        result += " \(play.name): $\(amount/100) (\(performance.audience)석)\n"
        totalAmount += amount
    }

    result += "총액: $\(totalAmount/10)\n"
    result += "적립 포인트: \(volumeCredits)점\n"
    return result
}

