//
//  LoanApplication.swift
//  Loans
//
//  Created by Sylus Abel on 22/05/2026.
//

import Foundation

struct LoanApplication {
    var loan: AvailableLoans
    var amount: Double
    var periodMonths: Int
    var disbursementAccount: String
    var startDate: Date
}

struct RepaymentInstallment: Identifiable {
    let id = UUID()
    let title: String
    let dueDate: Date
    let amount: Double
}
