//
//  main.swift
//  swift-refactoring
//
//  Created by 이지수 on 4/21/24.
//

import Foundation

main()

func main() {
    guard let invoicePath = Bundle.main.path(forResource: "invoices", ofType: "json", inDirectory: "Mocks"),
          let invoicesString = try? String(contentsOfFile: invoicePath),
          let invoicesData = invoicesString.data(using: .utf8),
          let invoices = try? JSONDecoder().decode([Invoice].self, from: invoicesData),
          let invoice = invoices.first,
          let playsPath = Bundle.main.path(forResource: "plays", ofType: "json", inDirectory: "Mocks"),
          let playsString = try? String(contentsOfFile: playsPath),
          let playsData = playsString.data(using: .utf8),
          let plays = try? JSONDecoder().decode(Plays.self, from: playsData)
    else { return }
    
    let errorMessage: String = "오류가 발생하였습니다."
    let message: String? = try? statement(invoice: invoice, plays: plays)
    print(message ?? errorMessage)
}
