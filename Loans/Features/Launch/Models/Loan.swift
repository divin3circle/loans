//
//  Loan.swift
//  Loans
//
//  Created by Sylus Abel on 22/05/2026.
//

import Foundation
import SwiftUI

struct AvailableLoans {
    let title: String
    let description: String
    let image: String
    let color: Color
}


extension AvailableLoans {
    static var mock: [AvailableLoans] {
        [
            AvailableLoans(title: "Salary E-loan", description: "Get quick loans to boost your income.", image: "eloan", color: .accentColor),
            AvailableLoans(title: "Buy Now Pay Later", description: "Buy goods today pay later.", image: "paylater", color: .purple),
            AvailableLoans(title: "Stock Loan", description: "boost your business stock today", image: "stockloan", color: .orange),
            ]
    }
}
