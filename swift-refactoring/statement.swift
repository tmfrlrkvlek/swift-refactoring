//
//  statement.swift
//  swift-refactoring
//
//  Created by 이지수 on 4/21/24.
//

import Foundation

/**
 수정할 부분
~~ 1. 청구 내역을 HTML로 출력하는 부분 필요~~
 ~~2. 연극 장르와 공연료 정책이 달라질 때마다 statement() 함수를 수정해야 함~~
    => 새로운 장르를 추가하려면 해당 장르의 서브클래스를 작성하고, `createPerformanceCalculator()` 함수에 추가하면 됨
 **/

func statement(invoice: Invoice, plays: Plays) throws -> String {
    return renderPlainText(data: try createStatementData(invoice: invoice, plays: plays))
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

func htmlStatement(invoice: Invoice, plays: Plays) throws -> String {
    return renderHtml(data: try createStatementData(invoice: invoice, plays: plays))
}

private func renderHtml(data: EnrichedStatementData) -> String {
    var result = """
<h1>청구 내역 (고객명: \(data.customer))</h1>
<table>
<tr><th>연극</th><th>좌석 수</th><th>금액</th></tr>
"""
    result = data.performances.reduce(result, { before, performance in
        before + """
    <tr><td>\(performance.play.name)</td><td>\(performance.audience)</td><td>$\(performance.amount / 10)</td>
"""
    })
    return result + "</table>\n"
}
